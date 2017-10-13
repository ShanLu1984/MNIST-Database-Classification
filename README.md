# MNIST Database Classification

### Introduction
* About the database:
 MNIST is a database of handwritten digits, available from this website http://yann.lecun.com/exdb/mnist/. It contains a training
group of 60, 000 images and a testing group of 10, 000 images. One property of this dataset is that all the images are hand written digits with standard size and contrast, which is very "similar" already.

* Tasks: 
1. Compares the classification error rates of the **heat content feature** and other blockwise similar-size low-level features including the (1) intensity histogram, (2) intensity moments, (3) Gabor coefficients, (4) gray-level co-occurrence matrix (GLCM) and (5) edge directions histogram. The classification algorithm is a **k-nearest neighbors (knn) classifier** with L2 norm as the distance measure.
2. Combining three types of features (Intensity, texture and shape). We apply **logistic** and **linear kernel support vector machine (SVM)** classifiers to execute the classification.

### What's inside:
