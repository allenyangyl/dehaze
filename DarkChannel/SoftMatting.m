%% step 3: soft matting - by Yilin Yang
function t = SoftMatting(img, t_, lambda, epsilon)

L = getLaplacian(img, epsilon, win_size);
win_size = 1;

end