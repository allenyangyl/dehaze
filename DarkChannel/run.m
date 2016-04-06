%% Single Image Haze Removal Using Dark Channel Prior - by Shiyu Dong and Yilin Yang
clear; close all; clc;

for i = 1 : 24
    tic;
    %% read image
    if i == 24
        img_file = ['../data/', num2str(i), '.png'];
    else
        img_file = ['../data/', num2str(i), '.jpg'];
    end
    img = imread(img_file);
    img = imresize(img, [500, NaN]);

    %% dehaze
    J = dehaze(img);
    imwrite(J, ['../results/', num2str(i), '_DarkChannel.jpg']);
    time = toc;
    disp(['Image ', num2str(i), ' saved. Time: ', num2str(time), 's. ']);
end
