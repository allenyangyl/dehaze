%% step 4: recover - by Yilin Yang
function J = Recover(img, A, t, t0)

J = (img - A) ./ max(t, t0) + A;

end