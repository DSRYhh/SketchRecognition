# A Heterogeneous Face Recognition System

## Introduction
This is a command-line implementation of [1]. Database is [CUHK student data set](http://mmlab.ie.cuhk.edu.hk/archive/facesketch.html). 

According to [1], this algorithm can be used in variety of heterogeneous face, including near-infrared and thermal infrared, although only sketch face database is used to test.

## Run

### Environment
This system requires a MATLAB&trade; environment. Toolbox listed below is required:
- MATLAB&trade; [Image Processing Toolbox](https://www.mathworks.com/products/image.html)
- MATLAB&trade; [Computer Vision System Toolbox](https://www.mathworks.com/products/computer-vision.html)

In image normalization step, an vaild [Microsoft Azure Cognitive Services](https://azure.microsoft.com/en-us/services/cognitive-services/) [Computer Vision API](https://azure.microsoft.com/en-us/services/cognitive-services/computer-vision/) subscription is required for eye detection.


### Run the entire process in command line
Run 
```
>> main
```
in MATLAB Command Window.

### Details of each step

#### Pre-process
Pre-processing includes 2 steps:
1. **Normalize each image in the database**
    1. This system use [Microsoft Cognitive Service](https://azure.microsoft.com/en-us/services/cognitive-services/) to detect eye position of the face, and normalize to a standard 200 * 250 pixels image. Because Microsoft Cognitive Service is a RESTful API, Internet connection is required at this step. It's worth to mention that if the input image size is already 200 * 250 pixels, **normalizatioin will not be applied**.
    2. Related code of eye detection can be seen in `eyeDetection.m`.
    3. After eye detection, a cropping is applied to the image to divide the image into small patches.
    4. Related code of this step is in `train.m`, and normalized images are saved in `norCUFS.mat`.

2. **Extract all feature descriptors**
    - The motivation of this step is to speed up the training step and testing step. In this step, features of all images are extracted and saved in `featureVectors.mat`. 
    - According to [1], 3 filters and 2 feature descriptors are applied to the image, which are *Difference of Gaussian* (dog), *Center-Surround Divisive Normalization* (csdn), *Gaussian smoothing filter* (gaussian) and *Scale-invariant Feature Transform* (SIFT), *Modified Local Binary Patterns* (MLBP), respectively.
    - Related function is `featureExtraction`.

#### Training and testing
1. **Training**
    - As mentioned above, we use CUHK for training and testing. More specificly, we use 88 faces for training, which is cropped. Our cropped algorithm wasn't applied to face images because there are already cropped sketches and photos in CUHK dataset. A random subspace approach is applied according to [1]. 
    - Related code can be seen in `train.m`.
    - Training result is saved in `prototype.mat`.
2. **Testing**
    - 100 images of the database were used for testing the accuracy of the algorithm.

## Experiment result
The accuracy of the latest version is **81%**.

## Differences from the paper
1. The combination SIFT and DoG is abandoned due to an all zero feature descriptor vector it will cause.
2. In score level fusion, only scores using same descriptor were added. See section 5.4 in [1].

## Library used
- [VLFeat](www.vlfeat.org), a computer vision algorithm implementation on MATLAB. `vl_sift` is used to extract SIFT feature descriptors from images.
- [LDA](https://cn.mathworks.com/matlabcentral/fileexchange/29673-lda--linear-discriminant-analysis), a LDA implementation on MATLAB. 
- [RotateAround](https://cn.mathworks.com/matlabcentral/fileexchange/40469-rotate-an-image-around-a-point), a MATLAB function to rotate a image around a specfic point.

## FAQ
1. `VCOMP100.DLL` missing

    When use vl_feat, MATLAB shows 
    ```
    Missing dependent shared libraries:
    'VCOMP100.DLL' required by ...
    ```
    There is a [solution](https://answers.microsoft.com/en-us/windows/forum/games_windows_10/windows-10-vcomp100dll-missing-cannot-start-game/d56c4b10-5309-4c82-a2c5-d6abf246a046) to the problem.

## Reference
[1] B. F. Klare and A. K. Jain, "Heterogeneous face recognition using kernel prototype similarities," IEEE Trans Pattern Anal Mach Intell, vol. 35, no. 6, pp. 1410-22, Jun 2013.