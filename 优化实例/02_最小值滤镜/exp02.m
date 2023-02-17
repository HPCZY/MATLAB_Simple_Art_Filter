clear; close all; clc

% 读取图片
img = imread('test.jpeg');
% 预处理
img = im2double(img);
[rows,cols,~] = size(img);
% 参数
rad = 3;

%% 方法一：按部就班
tic
imgout1 = zeros(rows,cols,3);
for i=1:rows
    for j=1:cols
        % 限制范围
        iMin = max(i-rad,1);
        iMax = min(i+rad,rows);
        jMin = max(j-rad,1);
        jMax = min(j+rad,cols);
%         % 提取邻域
%         tmp = img(iMin:iMax,jMin:jMax,:);
        % 提取最小值
        imgout1(i,j,1) = min(img(iMin:iMax,jMin:jMax,1),[],'all');
        imgout1(i,j,2) = min(img(iMin:iMax,jMin:jMax,2),[],'all');
        imgout1(i,j,3) = min(img(iMin:iMax,jMin:jMax,3),[],'all');
    end
end
toc

%% 方法二：手撸函数流
tic
imgout2 = ones(rows,cols,3);
for i=1:rows
    for j=1:cols
        % 限制范围
        iMin = max(i-rad,1);
        iMax = min(i+rad,rows);
        jMin = max(j-rad,1);
        jMax = min(j+rad,cols);
        % 提取最小值
        for r = iMin:iMax
            for c = jMin:jMax
                if imgout2(i,j,1)>img(r,c,1)
                    imgout2(i,j,1) = img(r,c,1);
                end
                if imgout2(i,j,2)>img(r,c,2)
                    imgout2(i,j,2) = img(r,c,2);
                end
                if imgout2(i,j,3)>img(r,c,3)
                    imgout2(i,j,3) = img(r,c,3);
                end
            end
        end
    end
end
toc

%% 方法三：用现成函数
tic
len = rad*2+1;
[rows,cols,dims] = size(img);
mask = ones(len);
R = ordfilt2(img(:,:,1),1,mask,'symmetric');
G = ordfilt2(img(:,:,2),1,mask,'symmetric');
B = ordfilt2(img(:,:,3),1,mask,'symmetric');
imgout3 = cat(3,R,G,B);
toc

subplot(221),imshow(img),title('原图')
subplot(222),imshow(imgout1),title('方法一')
subplot(223),imshow(imgout2),title('方法二')
subplot(224),imshow(imgout3),title('方法三')
