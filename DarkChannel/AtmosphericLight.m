%% step 1: atmospheric light - by Shiyu Dong
function A = AtmosphericLight(img, alpha, patch_size)

% calculate dark channel as a gray image
dark_channel = CalcDarkChannel(img, patch_size);

% brightness pixel value in the dark channel
bright_value = max(dark_channel(:));

% choose the top 0.1% pixel position
mask = dark_channel > bright_value*(1 - alpha);

% choose highest intensity in original image
new_img = double(rgb2gray(img)).*mask;

[~, index] = max(new_img(:));

[I_row, I_col] = ind2sub(size(new_img),index);

r_value = img(I_row, I_col, 1);
g_value = img(I_row, I_col, 2);
b_value = img(I_row, I_col, 3);

% create A
A(:,:,1) = ones(size(new_img))*double(r_value);
A(:,:,2) = ones(size(new_img))*double(g_value);
A(:,:,3) = ones(size(new_img))*double(b_value);

end