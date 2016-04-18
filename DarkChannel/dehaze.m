function [J, t_, t] = dehaze(I)

    %% dehaze
    % step 1: atmospheric light - by Shiyu Dong
    alpha = 0.001;
    patch_size = 7;
    A = AtmosphericLight(I, alpha, patch_size);
    % step 2: transmission - by Shiyu Dong
    omega = 0.95;
    t_ = Transmission(I, A, patch_size, omega);
    % step 3: soft matting - by Yilin Yang
    lambda = 0.0001;
    epsilon = 1e-6;
    t = SoftMatting(I, t_, lambda, epsilon);
    % step 4: recover - by Yilin Yang
    t0 = 0.1;
    J = Recover(I, A, t, t0);
    intensity = 25;
    J = J + intensity;
    
end