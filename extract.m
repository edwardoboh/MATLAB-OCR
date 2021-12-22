%% Extract Text from image after Morphological Thining/Closing
%% Clear console, clear all previous variables and close all figures
clc
clear all
close all
%% Read image from file and display in a new figure
subplot(2,2,1)
x=imread('name.png');
imshow(x);
title('Original Image');
%% Convert image of text to greyscale and then to a binary image
%figure;
subplot(2,2,2)
x=rgb2gray(x);
imshow(x);
title('Grayscale Image');
%figure;
subplot(2,2,3)
x=imbinarize(x);
imshow(x);
title('Binary Image');
%% Here we invert the image to ensure text is in white
% We define a structuring element here to be use in the next step for
% closing morphological operation
x=~x; 
g=strel('disk',3);
%% Preform morphological operation on image
x=imclose(x,g);
%figure;
subplot(2,2,4)
imshow(x);
title('After Morphological Closing');
%% Optical Character Recognition on the Binary image
m=ocr(x);
disp(m.Text);
disp(class(m.Words))