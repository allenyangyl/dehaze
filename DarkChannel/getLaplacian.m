%% step 3: get Laplacian - by Yilin Yang
function L = getLaplacian(img, epsilon, win_size)

% image size
[h, w, c] = size(img);
img_size = w * h;
% indices
indsM = reshape(1 : img_size, h, w);

len = 0;
for j = 1 : w
    for i = 1 : h
        % indices
        ind_x = max(1, i - win_size) : min(h, i + win_size);
        ind_y = max(1, j - win_size) : min(w, j + win_size);
        % |wk|
        neb_size = numel(ind_x) * numel(ind_y);
        % wk
        win_inds = indsM(ind_x, ind_y);
        win_inds = win_inds(:);
        winI = im2double(img(ind_x, ind_y, :));
        winI = reshape(winI, neb_size, c);
        % mean
        Mean = mean(winI, 1)';
        % variance
        Var = inv(winI' * winI / neb_size - Mean * Mean' + epsilon / neb_size * eye(c));
        % L(i,j)
        winI = winI - repmat(Mean', neb_size, 1);
        tvals = (1 + winI * Var * winI') / neb_size;
        % elements
        row_inds(1 + len : neb_size ^ 2 + len) = ...
            reshape(repmat(win_inds, 1, neb_size), neb_size ^ 2, 1);
        col_inds(1 + len : neb_size ^ 2 + len) = ...
            reshape(repmat(win_inds', neb_size, 1), neb_size ^ 2, 1);
        vals(1 + len : neb_size ^ 2 +len) = tvals(:);
        len = len + neb_size ^ 2;
    end
    disp(j);
end

% create sparse matrix L
vals = vals(1 : len);
row_inds = row_inds(1 : len);
col_inds = col_inds(1 : len);
L = sparse(row_inds, col_inds, vals, img_size, img_size);
% delta(i,j) - L
sumA = sum(L, 2);
L = spdiags(sumA(:), 0, img_size, img_size) - L;
  
end
