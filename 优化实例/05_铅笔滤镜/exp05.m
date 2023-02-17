clear; clc
% 读取图片
img = imread('test.jpeg');
% 预处理
img = im2double(img);
[rows,cols,~] = size(img);
% 参数
p = 20.1;
thresh = 0.3;
w = 3;


addpath('C:\Users\ASUS\Desktop\filter\func')
imgout = ColorPencilSketch(img,p,thresh,w);
fig = figure('Position',[490,42,1428,951]);
axes('Position',[0,0,0.5,1]),imshow(imgout1)
axes('Position',[0.5,0,0.5,1]),imshow(imgout)


tic
imgray = rgb2gray(img);

% 高斯梯度边缘
G1 = fspecial('Gaussian',5,.5);
G2 = fspecial('Gaussian',5,2);
dog = (1+p)*G1 - (p*G2); % difference of gaussian

%% 方法一 
imgdog = conv2(imgray,dog,'same');
dogSize = size(imgdog);
for i=1:dogSize(1)
    for j=1:dogSize(2)
        if imgdog(i,j) > thresh
            imgdog(i,j) = 1;
        else
            imgdog(i,j) = 1 + tanh(w*(imgdog(i,j)-thresh));
        end
    end
end
G3 = fspecial('Gaussian',5,1);
imgout1 = conv2(imgdog,G3,'same');
toc

%% 方法二: 用矩阵运算替代for循环
tic
imgdog = conv2(imgray,dog,'same');
mask = imgdog<=thresh;
imgdog2 = 1+tanh(w*(imgdog-thresh)).*mask;

G3 = fspecial('Gaussian',5,1);
imgout2 = conv2(imgdog2,G3,'same');
toc


fig = figure('Position',[490,42,1428,951]);
axes('Position',[0,0.5,0.5,0.5]),imshow(img)
axes('Position',[0.5,0.5,0.5,0.5]),imshow(imgray)
axes('Position',[0.,0.,0.5,0.5]),imshow(imgout1)
axes('Position',[0.5,0,0.5,0.5]),imshow(imgout)
