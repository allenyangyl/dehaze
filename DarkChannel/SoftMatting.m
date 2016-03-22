%% step 3: soft matting - by Yilin Yang
function t = SoftMatting(img, t_, lambda, epsilon)

% get Laplacian
win_size = 1;
L = getLaplacian(img, epsilon, win_size);
% image size
[h, w, ~] = size(img);
img_size = w * h;
% get U
vals = ones(img_size, 1);
row_inds = 1 : img_size;
col_inds = 1 : img_size;
U = sparse(row_inds, col_inds, vals, img_size, img_size);
% get t
t = lambda * (L + lambda * U) \ t_(:);
t = reshape(t, [h, w]);
t = t / max(t(:));

end