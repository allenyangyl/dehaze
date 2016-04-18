for i = 1 : 24
    tic;
    %% read image
    if i == 24
        img_file = ['../data/', num2str(i), '.png'];
    else
        img_file = ['../data/', num2str(i), '.jpg'];
    end
    img = imread(img_file);
    
    trans_file = ['../results/', num2str(i), '_DehazeNet_TransRaw.png'];
    trans = imread(trans_file);
    
    img = imresize(img, [500, NaN]);
    trans = imresize(trans, [500, NaN]);
    trans = rgb2gray(trans);
    %% dehaze
    
    alpha = 0.001;
    A = AtmosphericLight(img, trans, alpha);
    nhoodSize = 80;
    smoothValue  = 0.001*diff(getrangefromclass(img)).^2;
    trans_refined = imguidedfilter(trans, img, 'NeighborhoodSize', nhoodSize, 'DegreeOfSmoothing',smoothValue);
    imwrite(trans_refined, ['../results/', num2str(i), '_DehazeNet_TransRefined.jpg']);
    
    
    img = im2double(img);
    trans_refined = im2double(trans_refined);
    t0 = 0.1;
    A  = im2double(AtmosphericLight(img, trans, alpha));
    J = (double(img) - A) ./ repmat(max(trans_refined, t0), 1, 1, 3) + A;
    imwrite(J, ['../results/', num2str(i), '_DehazeNet.jpg']);
    
    
    time = toc;
    disp(['Image ', num2str(i), ' saved. Time: ', num2str(time), 's. ']);
end