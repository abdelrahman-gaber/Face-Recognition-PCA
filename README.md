# Face-Recognition-PCA
Face recognition using principle component analysis.   

The project depends on a data-set of 30 Faces of different people. For each of them we have 5 or 4 images from different directions and facial expressions. The project has 2 steps:

1. Normalization of all face images, and convert them from a size of 320x320 pixels, to a normalized images with 64x64 pixels. The normalization step is required prior to recognition, to account for scale, orientation, and location variations.    

2. Recognition for any new face image. In this step, we use Principle-Component-Analysis algorithm to first train the program with some of the faces, for example, for each person the training is done with 2 of his face images. After that, the algorithm takes a new face image and label it with the name of the face with the lowest error.    

The program is done using MATLAB with a handy GUI, and for each given face it gives the first 3 matching faces with the least error.
