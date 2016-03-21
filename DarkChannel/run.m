%% Single Image Haze Removal Using Dark Channel Prior - by Shiyu Dong and Yilin Yang
clear; close all; clc;

%% read image
img_file = '../data/24.png';
img = imread(img_file);

%% dehaze
% step 1: atmospheric light - by Shiyu Dong
alpha = 0.001;
A = AtmosphericLight(img, alpha);
% step 2: transmission - by Shiyu Dong
patch_size = 15;
omega = 0.95;
t_ = Transmission(img, A, patch_size, omega);
% step 3: soft matting - by Yilin Yang
lambda = 1e-4;
epsilon = 1e-6;
t = SoftMatting(img, t_, lambda, epsilon);
% step 4: recover - by Yilin Yang
t0 = 0.1;
J = Recover(img, A, t, t0);