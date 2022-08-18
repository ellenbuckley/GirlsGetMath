clear all; close all; clc;

%% Step 1: Read Image
I = imread('floe.tif');

f1 = figure(1);
s1 = subplot(2,2,1);

imshow(I);

title('Step 01: Original Image', 'Color', 'k');


%% Step 2: Detect Edges of the Floe

% turn image to grayscale for input to edge function
I = rgb2gray(I);

%detect edges
BWs = edge(I,'sobel');

% Display the resulting mask.
s2 = subplot(2,2,2);
imshow(BWs);
title('Step 02: Binary Gradient Mask', 'Color', 'k')

%% Step 3: Dilate the Image
se90 = strel('line',3,90);
se0 = strel('line',3,0);

BWsdil = imdilate(BWs,[se90 se0]);

%Display the dialated edge
s3 = subplot(2,2,3);
imshow(BWsdil);
title('Step 03: Dilated Gradient Mask', 'Color', 'k')

%% Step 4: Fill Interior Gaps

BWdfill = imfill(BWsdil,'holes');

% display the filled floe
s4 = subplot(2,2,4);
imshow(BWdfill);

title('Step 04: Binary Image with Filled Holes', 'Color', 'k')

%% Step 5: Remove Small Objects


BWnobord = bwareaopen(BWdfill,800);

%create a new figure
f2 = figure(2);
s5 = subplot(2,2,1);
imshow(BWnobord);
title('Step 05: Remove Small Objects','Color', 'k')

%% Step 6: Smooth the Object

seD = strel('diamond',2);
BWfinal = imerode(BWnobord,seD);

s6 = subplot(2,2,2);
imshow(BWfinal);
title('Step 06: Smoothed Image','Color', 'k');

%% Step 7: Visualize the Segmentation
s7 = subplot(2,2,3);
imshow(labeloverlay(I,BWfinal))
title('Step 07: Mask Over Original Image', 'Color', 'k')



%% Step 8: Show Outlined Floe

BWoutline = bwperim(BWfinal);
Segout = I; 
Segout(BWoutline) = 255; 

s8 = subplot(2,2,4);
imshow(Segout)
title('Step 08: Outlined Original Image', 'Color', 'k')

