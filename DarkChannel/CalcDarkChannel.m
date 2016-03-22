%% step 0: calculate dark channel - by Shiyu Dong
function dark_channel = CalcDarkChannel(ori_img, patch_size)

%ori_img = double(ori_img);

width = size(ori_img, 1);
length = size(ori_img, 2);

gray_img =  zeros(width, length);

for i = 1: width
    for j = 1: length
        gray_img(i,j) = min(ori_img(i,j,:));
    end
end

blocksize = [patch_size, patch_size];

filtered_img = minblockfilter(gray_img, blocksize);

dark_channel = double(filtered_img);



end

function filtered_img = minblockfilter(gray_img, blocksize)

filtered_img = gray_img;
width = size(gray_img, 1);
length = size(gray_img, 2);

for i = 1:width
    for j = 1:length
        %if i >= blocksize(1) && i<= width - blocksize(1) && j >= blocksize(2) && j <= length - blocksize(2)
        patch_img = gray_img(max(1,i-blocksize(1)):min(width, i+blocksize(1)), max(1,j-blocksize(2)):min(length, j+blocksize(2)));
        min_val = min(patch_img(:));
        filtered_img(i,j) = min_val;
    end
end

end