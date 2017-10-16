% =================================================================
% Main program for MNIST image recognition --- Logistic regression classification
% =================================================================

%% STEP 1: load data
clc;
clear;
close all;

load('MNISTtrain_49_all.mat');
load('MNISTtest_49_all.mat');

train_labels(train_labels==0) = 10; % Remap 0 to 10
test_labels(test_labels==0) = 10; % Remap 0 to 10

%trainSampleData;
tr1 = train_hist_feature;
tr2 = train_moment_feature;
tr3 = train_gabor_feature;
tr4 = train_glcm_feature;
tr5 = train_edge_feature;
tr6 = train_hc_feature;

%testSampleData;
te1 = test_hist_feature;
te2 = test_moment_feature;
te3 = test_gabor_feature;
te4 = test_glcm_feature;
te5 = test_edge_feature;
te6 = test_hc_feature;

% select feature
benchmark_vector = zeros(10,7);
benchmark_vector(1,:) = [1 3 5 0 0 0 0];
benchmark_vector(2,:) = [1 3 5 6 0 0 0];
benchmark_vector(3,:) = [1 4 5 0 0 0 0];
benchmark_vector(4,:) = [1 4 5 6 0 0 0];
benchmark_vector(5,:) = [2 3 5 0 0 0 0];
benchmark_vector(6,:) = [2 3 5 6 0 0 0];
benchmark_vector(7,:) = [2 4 5 0 0 0 0];
benchmark_vector(8,:) = [2 4 5 6 0 0 0];
benchmark_vector(9,:) = [2 3 4 5 0 0 0];
benchmark_vector(10,:) = [2 3 4 5 6 0 0];

%% STEP 2: Implement softmaxCost

acc = zeros(10,1);

for i = 1:size(benchmark_vector,1)
    tic;
    f_choice_temp = benchmark_vector(i,:);
    
    for f_n = 1:8
       if f_choice_temp(f_n) == 0
          f_choice = f_choice_temp(1,1:f_n - 1);
          break;
       end
    end
    
    clear trainData testData;
    
    trainData = [];
    testData = [];
    
    for j = 1:size(f_choice,2)
        eval(['trainData = [trainData',';tr',num2str(f_choice(j)),'];']);
        eval(['testData = [testData',';te',num2str(f_choice(j)),'];']);
    end
    
    numClasses = 10;     % Number of classes (MNIST images fall into 10 classes)
    lambda = 1e-4; % Weight decay parameter
    inputSize = size(trainData,1);
    theta = 0.005 * randn(numClasses * inputSize, 1);
    
    [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda,...
        trainData, train_labels);
    
    options.maxIter = 1000;
    softmaxModel = softmaxTrain(inputSize, numClasses, lambda, ...
        trainData, train_labels, options);
    
    [pred] = softmaxPredict(softmaxModel, testData);
    
    acc(i) = mean(test_labels(:) == pred(:));
    toc;
end

clc;

%% Print result

for i = 1:size(acc,1)
    acc_num = acc(i);
    fprintf('Error rate : %0.3f%%\n', (1-acc_num) * 100);
end
