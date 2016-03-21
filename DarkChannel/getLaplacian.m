%% step 3: get Laplacian - by Yilin Yang
function L = getLaplacian(img, epsilon, win_size)

% |wk|
neb_size = (win_size * 2 + 1) ^ 2;
% image size
[h, w, c] = size(img);
img_size = w * h;
% indices
indsM = reshape(1 : img_size, h, w);
tlen = (w - 2 * win_size) * (h - 2 * win_size) * (neb_size ^ 2);
row_inds = zeros(tlen, 1);
col_inds = zeros(tlen, 1);

len = 0;
for j = win_size + 1 : w - win_size
    for i = win_size + 1 : h - win_size
        ind_x = i - win_size : i + win_size;
        ind_y = j - win_size : j + win_size;
        win_inds = indsM(ind_x, ind_y);
        win_inds = win_inds(:);
        winI = double(img(ind_x, ind_y, :));
        winI = reshape(winI, neb_size, c);
        Mean = mean(winI, 1)';
        Var = inv(winI' * winI / neb_size - Mean * Mean' + epsilon / neb_size * eye(c));

        winI = winI - repmat(Mean', neb_size, 1);
        tvals = (1 + winI * Var * winI') / neb_size;

        row_inds(1 + len : neb_size ^ 2 + len) = ...
            reshape(repmat(win_inds, 1, neb_size), neb_size ^ 2, 1);
        col_inds(1 + len : neb_size ^ 2 + len) = ...
            reshape(repmat(win_inds', neb_size, 1), neb_size ^ 2, 1);
        vals(1 + len : neb_size ^ 2 +len) = tvals(:);
        len = len + neb_size ^ 2;
    end
    disp(j);
end  

vals = vals(1 : len);
row_inds = row_inds(1 : len);
col_inds = col_inds(1 : len);
L = sparse(row_inds, col_inds, vals, img_size, img_size);

sumA = sum(L, 2);
L = spdiags(sumA(:), 0, img_size, img_size) - L;
  
end
