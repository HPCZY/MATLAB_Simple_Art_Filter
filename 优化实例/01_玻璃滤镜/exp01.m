clear; close all; clc

% ��ȡͼƬ
img = imread('test.jpeg');
% Ԥ����
img = im2double(img);
[rows,cols,dims] = size(img);
% ����
rad = 3;

%% 1
tic
imgout1 = img;
for i = 1:rows
    for j = 1:cols    
        % ����ж�
        iMin = max(i-rad,1);
        iMax = min(i+rad,rows);
        jMin = max(j-rad,1);
        jMax = min(j+rad,cols);
        % Ŀ������
        tmp = img(iMin:iMax,jMin:jMax,:);   
        % ���λ��
        x2 = randi(iMax-iMin+1);
        y2 = randi(jMax-jMin+1);  
        % ȡֵ
        imgout1(i,j,:) = tmp(x2,y2,:);
    end
end
toc

%% 2 ��Ҫ��ѭ���ڷ����ڴ�
tic
imgout2 = img;
for i = 1:rows
    for j = 1:cols  
        % ���λ��
        x2 = min(max(i+randi([-rad,rad]),1),rows);
        y2 = min(max(j+randi([-rad,rad]),1),cols);    
        % ȡֵ
        imgout2(i,j,:) = img(x2,y2,:);
    end
end
toc

%% 3 �þ����������forѭ��
tic
% �������
[x,y] = meshgrid(1:cols,1:rows);
xt = x+randi([-rad,rad],rows,cols);
yt = y+randi([-rad,rad],rows,cols);
xt(xt<1) = 1;
xt(xt>cols) = cols;
yt(yt<1) = 1;
yt(yt>rows) = rows;
% ��ֵȡֵ
R = interp2(x,y,img(:,:,1),xt,yt,'nearest');
G = interp2(x,y,img(:,:,2),xt,yt,'nearest');
B = interp2(x,y,img(:,:,3),xt,yt,'nearest');
imgout3 = cat(3,R,G,B);
toc

%% 4 ����һά���������ά����
tic
% �������
[x,y] = meshgrid(1:cols,1:rows);
xt = x+randi([-rad,rad],rows,cols);
yt = y+randi([-rad,rad],rows,cols);
xt(xt<1) = 1;
xt(xt>cols) = cols;
yt(yt<1) = 1;
yt(yt>rows) = rows;
% ֱ��ȡֵ
idx = sub2ind([rows,cols],yt,xt);
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
imgout4 = cat(3,R(idx),G(idx),B(idx));
toc

% ��ʾ
subplot(221),imshow(imgout4);
subplot(222),imshow(imgout1);
subplot(223),imshow(imgout2);
subplot(224),imshow(imgout3);



