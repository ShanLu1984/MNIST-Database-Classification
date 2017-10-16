% ================================================================
% Main program for MNIST image recognition -- knn classification. 
% =================================================================

%% Calculate the test result
clear;

load('MNISTtrain_49_all.mat');
load('MNISTtest_49_all.mat');

fold_num = 10;

%-------------------------KNN basic-------------------------------------
optimal_k = 8;
%-------------------------------------------------------------------

%====================== Using intensity histogram
tic;
pred = knnclassify(test_hist_feature', train_hist_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For intensity histogram: %0.3f%%\n', acc * 100);
toc;

%================== Using moments
tic;
pred = knnclassify(test_moment_feature', train_moment_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For moments: %0.3f%%\n', acc * 100);
toc;

%================== Using gabors
tic;
pred = knnclassify(test_gabor_feature', train_gabor_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For gabors: %0.3f%%\n', acc * 100);
toc;

%================== Using glcm
tic;
pred = knnclassify(test_glcm_feature', train_glcm_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For glcm: %0.3f%%\n', acc * 100);
toc;

%=================== Using edge directions
tic;
pred = knnclassify(test_edge_feature', train_edge_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For edge directions: %0.3f%%\n', acc * 100);
toc;

%================= using heat content
tic;
tr_feature = train_hc_feature;
te_feature = test_hc_feature;

pred = knnclassify(te_feature', tr_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For HC: %0.3f%%\n', acc * 100);
toc;

%% Test results of feature + heat content

%============ Using combined features: histogram + hc
tic;
tr_feature = [train_hc_feature; train_hist_feature];
te_feature = [test_hc_feature; test_hist_feature];

pred = knnclassify(te_feature', tr_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For histogram + hc: %0.3f%%\n', acc * 100);
toc;

%============ Using combined features: moments + hc
tic;
tr_feature = [train_hc_feature; train_moment_feature];
te_feature = [test_hc_feature; test_moment_feature];

pred = knnclassify(te_feature', tr_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For moments + hc: %0.3f%%\n', acc * 100);
toc;
% 
%============== Using combined features: gabor + hc
tic;
tr_feature = [train_hc_feature; train_gabor_feature];
te_feature = [test_hc_feature; test_gabor_feature];

pred = knnclassify(te_feature', tr_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For gabor + hc: %0.3f%%\n', acc * 100);
toc;
% 
%============== Using combined features: glcm + hc
tic;
tr_feature = [train_hc_feature; train_glcm_feature];
te_feature = [test_hc_feature; test_glcm_feature];

pred = knnclassify(te_feature', tr_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For glcm + hc: %0.3f%%\n', acc * 100);
toc;
% 

%=============== Using combined features: edge + hc
tic;
tr_feature = [train_edge_feature; train_hc_feature];
te_feature = [test_edge_feature; test_hc_feature];
% 
pred = knnclassify(te_feature', tr_feature', train_labels', optimal_k);
acc = mean(test_labels(:) == pred(:));
fprintf('Test Accuracy For edge + hc: %0.3f%%\n', acc * 100);
toc;
