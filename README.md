# Dehaze 
by Yilin Yang & Shiyu Dong

## DarkChannel
He K, Sun J, Tang X. Single image haze removal using dark channel prior[J]. Pattern Analysis and Machine Intelligence, IEEE Transactions on, 2011, 33(12): 2341-2353.
Run "run.m" to remove haze on example images
Use function dehaze(I) in "dehaze.m" for any input image
The parameters are defined in "dehaze.m"

## DehazeNet
Cai B, Xu X, Jia K, et al. DehazeNet: An End-to-End System for Single Image Haze Removal[J]. arXiv preprint arXiv:1601.07661, 2016.
Run "Dehaze.sh" or "dehaze.py", "dehaze.m" to remove haze on example images
The training and test patches are in folder "patches"
The training and test labels are in "TrainLabels.txt" and "TestLabels.txt"
Run "train.sh" to train DehazeNet

## Data
24 Some images for haze removal

## Results
The results of these images using Dark Channel and DehazeNet
