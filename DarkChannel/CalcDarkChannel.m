%% step 0: calculate dark channel - by Shiyu Dong
function dark_channel = CalcDarkChannel(ori_img)

%ori_img = double(ori_img);

width = size(ori_img, 1);
length = size(ori_img, 2);

gray_img =  zeros(width, length);

for i = 1: width
    for j = 1: length
        gray_img(i,j) = min(ori_img(i,j,:));
    end
end

blocksize = [15, 15];

fun=@(block_struct)minblockfilter(block_struct.data);

filtered_img = blockproc(gray_img, blocksize, fun);

dark_channel = double(filtered_img);



end

function filtered_img = minblockfilter(gray_img)

filtered_img = zeros(size(gray_img));

filtered_img(:,:) = min(gray_img(:));

end