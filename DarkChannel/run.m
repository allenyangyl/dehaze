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
    % step 1: atmospheric light - by Shiyu Dong
    alpha = 0.001;
    patch_size = 7;
    A = AtmosphericLight(img, alpha, patch_size);
    % step 2: transmission - by Shiyu Dong
    omega = 0.95;
    t_ = Transmission(img, A, patch_size, omega);
    % step 3: soft matting - by Yilin Yang
    lambda = 0.0001;
    epsilon = 1e-6;
    t = SoftMatting(img, t_, lambda, epsilon);
    % step 4: recover - by Yilin Yang
    t0 = 0.1;
    J = Recover(img, A, t, t0);
%     imshow(J);
    imwrite(J, ['../results/', num2str(i), '_DarkChannel.jpg']);
    time = toc;
    disp(['Image ', num2str(i), ' saved. Time: ', num2str(time), 's. ']);
end