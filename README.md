# MNIST Database Classification

### Introduction
* About the database:
 MNIST is a database of handwritten digits, available from this website http://yann.lecun.com/exdb/mnist/. It contains a training
group of 60, 000 images and a testing group of 10, 000 images. One property of this dataset is that all the images are hand written digits with standard size and contrast, which is very "similar" already.

* Tasks: 
1. Compares the classification error rates of the **heat content feature** and other blockwise similar-size low-level features including the (1) intensity histogram, (2) intensity moments, (3) Gabor coefficients, (4) gray-level co-occurrence matrix (GLCM) and (5) edge directions histogram. The classification algorithm is a **k-nearest neighbors (knn) classifier** with L2 norm as the distance measure.
2. Combining three types of features (Intensity, texture and shape). We apply **logistic regression** and **linear kernel support vector machine (SVM)** classifiers to execute the classification.

* Main results:
You may refer details and main results from our published paper in 2014 and 2016 in ICIP. 
1. "A complex network based feature extraction for image retrieval" http://www.orie.cornell.edu/orie/research/groups/multheavytail/upload/KLGK2014-081215.pdf
2. "Image feature extraction based on spectral graph information" 

### What's inside:
1. mnistclassify_feature_par.m
* Main program for MNIST image recognition -- feature generation. 
* Output: MNISTtrain_49_all.mat, MNISTtest_49_all.mat
2. mnist_classify_knn.m
* Main program for MNIST image recognition -- knn classification. 
* Output: print test accuracy of different features and these features combined with *heat content* feature.
3. mnist_classify_logistic_regression.m
* Main program for MNIST image recognition --- Logistic regression classification
* Output: print test error rate for different feature combinations.
4. mnist_classify_libsvm.m
* Main program for MNIST image recognition -- SVM classification
* Output: print test error rate for different feature combinations.
5. loadMNISTImages.m and loadMNISTLabels.m
* Load image and corresponding labels in MNIST dataset
6. graphGenNew.m
* Used to generate graph from image pixel information
* Output: inputGraph.D: degree matrix; inputGraph.GL: graph Laplacian; inputGraph.B: boundary nodes; inputGraph.P: transition matrix;
7. hcMatNew.m
* Used to generate heat content feature from input graph;
* Output: hc, heat content vector;
8. blockGen.m
* Generate image blocks for feature computing
* OUtput: inputBlock

### How to run:
1. Download the MNIST database from  http://yann.lecun.com/exdb/mnist/.
2. Download all the programs in the repository. Open Matlab, change the current path to the folder that you put all the codes in, and add all the folders and subfolders in the current folder to the current path.
3. Open mnistclassify_feature_par.m and run, or type `mnistclassify_feature_par`in command window.
4. Open mnist_classify_knn.m and run, or type ` mnist_classify_knn` in command window.
5. Open mnist_classify_logistic_regression.m and run, or type `mnist_classify_logistic_regression` in command window.
6. Open mnist_classify_libsvm.m and run, or type ` mnist_classify_libsvm` in command window.
