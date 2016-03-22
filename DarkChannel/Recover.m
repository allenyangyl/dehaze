%% step 4: recover - by Yilin Yang
function J = Recover(img, A, t, t0)

J = uint8((double(img) - A) ./ repmat(max(t, t0), 1, 1, 3) + A);

end