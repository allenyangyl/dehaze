%% step 1: atmospheric light - by Shiyu Dong
function A = AtmosphericLight(img, alpha, patch_size)

% calculate dark channel as a gray image
dark_channel = CalcDarkChannel(img, patch_size);

% number of pixels
numOfPixels = size(dark_channel,1)*size(dark_channel,2);
numOfSamples = floor(numOfPixels*alpha);

% sort pixel values
[~, index] = sort(dark_channel(:));
select_ind = find(index<=numOfSamples);
[select_row, select_col] = ind2sub(size(dark_channel),select_ind);

mask = zeros(size(dark_channel));

for i = 1:length(select_row)
    mask(select_row(i),select_col(i)) = 1;
end

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