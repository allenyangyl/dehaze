%% step 2: transmission - by Shiyu Dong
function t_ = Transmission(img, A, patch_size, omega)

% Normalize 3 channels of img according to A
norm_img = double(img)./A;

% dark channel
dark_channel = CalcDarkChannel(norm_img, patch_size);

% t_
t_ = 1 - omega*dark_channel;


end