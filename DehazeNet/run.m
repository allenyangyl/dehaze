for i = 1 : 24
    tic;
    %% read image
    try        
        img_file = ['../data/', num2str(i), '.jpg'];        
        img = imread(img_file);
    catch
        img_file = ['../data/', num2str(i), '.png'];        
        img = imread(img_file);
    end
    
    trans_file = ['../results/', num2str(i), '_DehazeNet_TransRaw.png'];
    trans = imread(trans_file);
    
    %% dehaze
    alpha = 0.001;
    nhoodSize = round([size(trans,1), size(trans,2)] / 10);
    smoothValue  = 0.001;%*diff(getrangefromclass(img)).^2;
    trans_refined = imguidedfilter(trans, img, 'NeighborhoodSize', nhoodSize, 'DegreeOfSmoothing',smoothValue);
    imwrite(trans_refined, ['../results/', num2str(i), '_DehazeNet_Trans.png']);
    
    
    img = im2double(img);
    trans_refined = im2double(trans_refined);
    t0 = 0.1;
    A  = im2double(AtmosphericLight(img, rgb2gray(trans), alpha));
    J = (double(img) - A) ./ max(trans_refined, t0) + A;
    imwrite(J, ['../results/', num2str(i), '_DehazeNet.png']);
    
    
    time = toc;
    disp(['Image ', num2str(i), ' saved. Time: ', num2str(time), 's. ']);
end