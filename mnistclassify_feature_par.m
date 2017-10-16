%===============================================================
% Main program for MNIST image recognition -- feature generation
%===============================================================

%% Step 1: load MNIST training images and labels

clear;
close all;
clc;
tic;

trainData = loadMNISTImages('./mnist/train-images.idx3-ubyte');
trainLabels = loadMNISTLabels('./mnist/train-labels.idx1-ubyte');

one_dim_size = 28; 

input_size = [one_dim_size one_dim_size];


%-------------------Reduce the size of training samples for test----------------------------
% num_per_digit_test = 30;
% num_per_digit = num_per_digit_test * 6;
% 
% trainSampleData = zeros(one_dim_size * one_dim_size, 10 * num_per_digit);
% trainSampleLabels = zeros(10*num_per_digit,1);
% 
% digit_num = zeros(num_per_digit,1);
% 
% while(sum(digit_num) < 10 * num_per_digit)
%     num_chosen = randi([1 60000]);
%     label_prob = trainLabels(num_chosen);
%     
%     if digit_num(label_prob+1) < num_per_digit
%         digit_num(label_prob+1) = digit_num(label_prob+1) + 1;
%         trainSampleData(:,label_prob * num_per_digit + digit_num(label_prob+1))...
%             = trainData(:,num_chosen);
%         trainSampleLabels(label_prob * num_per_digit + digit_num(label_prob+1))...
%             = trainLabels(num_chosen);
%     end
% end

%---------------------------------------------------------------------------

%-------------------Original training data size------------------------------
trainSampleData = trainData;
trainSampleLabels = trainLabels;
%--------------------------------------------------------------------

clear trainData trainLabels num_chosen label_prob digit_num ans;

%% Step 2: Run feature computing of training images

size_train = size(trainSampleData,2);

%size_eig = 676;

step = 9;
lazy = 1;
iq = 1;

num_block = 49;
block_length = 10;
alpha_length = 10;

block_start = randi([1 input_size(1)-block_length+1],[2 num_block]);

choose_eig = step - 1;

%-------------------using heat contents---------------
train_hc_feature = zeros((step * lazy + 1)*(num_block),size_train); % hc
%--------------------------------------------------------------------

train_hist_feature = zeros(2 * num_block,size_train); % intensity hist
train_edge_feature = zeros(5 * num_block,size_train); % edge direction
train_moment_feature = zeros(4 * num_block,size_train); % moments
train_gabor_feature = zeros(6 * num_block,size_train); % gabor
train_glcm_feature = zeros(4 * num_block,size_train); % glcm

parpool('local',2); 

parfor i = 1:size_train
    clc;
    i
    inputData = trainSampleData(:,i);
    inputImage = reshape(inputData,one_dim_size,one_dim_size);
    
    inputBlock = blockGen(inputImage,block_start,block_length);
    
%--------------Calculate heat contents-------------------------
    hcblock = zeros(step + 1, num_block);
    histblock = zeros(2, num_block);
    edgeblock = zeros(5, num_block);
    momentblock = zeros(4, num_block);
    gaborblock = zeros(6, num_block);
    glcmblock = zeros(4,num_block);
    
    for k = 1:num_block
        block_k_graph = graphGenNew(inputBlock(k).image);
        thc = hcMatNew(block_k_graph,step,lazy);
        hcblock(:,k) = thc.total;
        
        histblock(:,k) = hist(inputBlock(k).image(:),2);
        edgeblock(:,k) = mnist_edgehist(inputBlock(k).image);
        [gSE, gMA] = phasesym(inputBlock(k).image, 1, 6);
        gaborblock(:,k) = gSE;
        glcm_temp = graycomatrix(inputBlock(k).image,'NumLevels',2);
        glcmblock(:,k) = glcm_temp(:);
        
        temp = inputBlock(k).image(:);
        momentblock(1,k) = mean(temp);
        for m_n = 2:4
            momentblock(m_n,k) = sum((temp - mean(temp)).^ m_n)/size(temp,1)^(1/m_n);
        end
    end
    

    train_hc_feature(:,i) = hcblock(:);
    train_hist_feature(:,i) = histblock(:);
    train_edge_feature(:,i) = edgeblock(:);
    train_moment_feature(:,i) = momentblock(:);
    train_gabor_feature(:,i) = gaborblock(:);
    train_glcm_feature(:,i) = glcmblock(:);
%------------------------------------------------------------

end

train_hc_feature = feature_normalization(train_hc_feature);
train_hist_feature = feature_normalization(train_hist_feature);
train_edge_feature = feature_normalization(train_edge_feature);
train_moment_feature = feature_normalization(train_moment_feature);
train_gabor_feature = feature_normalization(train_gabor_feature);
train_glcm_feature = feature_normalization(train_glcm_feature);

train_labels = trainSampleLabels;
save('MNISTtrain_49_all.mat','train_hist_feature','train_edge_feature',...
    'train_moment_feature','train_hc_feature','train_gabor_feature',...
    'train_glcm_feature','train_labels','trainSampleData');


%% Step 3: Load MNIST test images and labels

testData = loadMNISTImages('/mnist/t10k-images.idx3-ubyte');
testLabels = loadMNISTLabels('/mnist/t10k-labels.idx1-ubyte');


%-------------------Reduce the size of training samples for test----------------------------
% num_per_digit = num_per_digit_test;
% digit_num = zeros(num_per_digit,1);
% 
% testSampleData = zeros(one_dim_size * one_dim_size, 10 * num_per_digit);
% testSampleLabels = zeros(10*num_per_digit,1);
% 
% while(sum(digit_num) < 10 * num_per_digit)
%     num_chosen = randi([1 10000]);
%     label_prob = testLabels(num_chosen);
%     
%     if digit_num(label_prob+1) < num_per_digit
%         digit_num(label_prob+1) = digit_num(label_prob+1) + 1;
%         testSampleData(:,label_prob * num_per_digit + digit_num(label_prob+1))...
%             = testData(:,num_chosen);
%         testSampleLabels(label_prob * num_per_digit + digit_num(label_prob+1))...
%             = testLabels(num_chosen);
%     end
% end

%-------------------Original test data size------------------------------
testSampleData = testData;
testSampleLabels = testLabels;
%--------------------------------------------------------------------

%% Step 4: Run feature computing of test images

size_test = size(testSampleData,2);

%-------------------using heat contents------------------------------
test_hc_feature = zeros((step * lazy + 1)*(num_block),size_test); % hc
%--------------------------------------------------------------------

test_hist_feature = zeros(2 * num_block,size_test); % intensity hist
test_edge_feature = zeros(5 * num_block,size_test); % edge direction
test_moment_feature = zeros(4 * num_block,size_test); % moments
test_gabor_feature = zeros(6 * num_block,size_test); % gabor
test_glcm_feature = zeros(4 * num_block,size_test); % glcm


parfor i = 1:size_test
    clc;
    i
    inputData = testSampleData(:,i);
    inputImage = reshape(inputData,one_dim_size,one_dim_size);
    
    glcm_feature = graycomatrix(inputImage);
    inputBlock = blockGen(inputImage,block_start,block_length);
    
%-------------------Calculate heat contents---------------------- 
    hcblock = zeros(step + 1,num_block);
    alphablock = zeros(alpha_length, num_block);
    alphablock2 = zeros(step + 1, num_block);
    histblock = zeros(2, num_block);
    edgeblock = zeros(5, num_block);
    momentblock = zeros(4, num_block);
    gaborblock = zeros(6, num_block);
    glcmblock = zeros(4, num_block);
    
    for k = 1:num_block
        block_k_graph = graphGenNew(inputBlock(k).image);
        thc = hcMatNew(block_k_graph,step,lazy);
        hcblock(:,k) = thc.total;
        
        histblock(:,k) = hist(inputBlock(k).image(:), 2);
        edgeblock(:,k) = mnist_edgehist(inputBlock(k).image);
        [gSE, gMA] = phasesym(inputBlock(k).image, 1, 6);
        gaborblock(:,k) = gSE;
        glcm_temp = graycomatrix(inputBlock(k).image,'NumLevels',2);
        glcmblock(:,k) = glcm_temp(:);
        
        temp = inputBlock(k).image(:);
        momentblock(1,k) = mean(temp);
        for m_n = 2:4
            momentblock(m_n,k) = sum((temp - mean(temp)).^ m_n)/size(temp,1)^(1/m_n);
        end
    end
    
    test_hc_feature(:,i) = hcblock(:);
    test_hist_feature(:,i) = histblock(:);
    test_edge_feature(:,i) = edgeblock(:);
    test_moment_feature(:,i) = momentblock(:);
    test_gabor_feature(:,i) = gaborblock(:);
    test_glcm_feature(:,i) = glcmblock(:);
end

test_hc_feature = feature_normalization(test_hc_feature);
test_hist_feature = feature_normalization(test_hist_feature);
test_edge_feature = feature_normalization(test_edge_feature);
test_moment_feature = feature_normalization(test_moment_feature);
test_gabor_feature = feature_normalization(test_gabor_feature);
test_glcm_feature = feature_normalization(test_glcm_feature);

test_labels = testSampleLabels;
save('MNISTtest_49_all.mat','test_hist_feature','test_edge_feature',...
    'test_moment_feature','test_hc_feature','test_gabor_feature',...
    'test_glcm_feature','test_labels','testSampleData');

delete(gcp('nocreate'));
toc;
