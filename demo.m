clear; close all; clc

addpath('func\')

srcimg = imread('test.jpeg');
srcimg = im2double(srcimg);

rad = 3;
desimg = glass(srcimg,rad); % You can replace it with other functions

figure
subplot(121),imshow(srcimg)
subplot(122),imshow(desimg)