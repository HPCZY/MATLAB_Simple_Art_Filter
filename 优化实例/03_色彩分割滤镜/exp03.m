clear; clc

% 读取图片
img = imread('test.jpeg');
% 预处理
img = im2double(img);
% 参数
colors = 25;

tic
% 分类、聚类
im_lab = rgb2lab(img);
im_ab = im2single(im_lab(:,:,2:3));
plabels = imsegkmeans(im_ab,colors);
toc

%% 方法一
tic
% 赋值
imgout1 = zeros(size(img));
for k = 1:colors

    r = img(:,:,1);
    g = img(:,:,2);
    b = img(:,:,3);
    r(plabels~=k) = NaN;
    g(plabels~=k) = NaN;
    b(plabels~=k) = NaN;

    r(plabels==k) = mean(r(plabels==k), 'omitnan');
    g(plabels==k) = mean(g(plabels==k), 'omitnan');
    b(plabels==k) = mean(b(plabels==k), 'omitnan');

    r(plabels~=k) = 0;
    g(plabels~=k) = 0;
    b(plabels~=k) = 0;

    imgout1 = imgout1 + cat(3,r,g,b);
end
toc


%% 方法二：去除无效操作
tic
% 赋值
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);
for k = 1:colors
    r(plabels==k) = mean(r(plabels==k), 'omitnan');
    g(plabels==k) = mean(g(plabels==k), 'omitnan');
    b(plabels==k) = mean(b(plabels==k), 'omitnan');
end
imgout2 = cat(3,r,g,b);
toc

%% 方法三
tic
% 赋值
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);
for k = 1:colors
    mask = plabels==k;
    r(mask) = mean(r(mask), 'omitnan');
    g(mask) = mean(g(mask), 'omitnan');
    b(mask) = mean(b(mask), 'omitnan');
end
imgout3 = cat(3,r,g,b);
toc

%% 显示

fig = figure('Position',[490,42,1428,951]);
axes('Position',[0,0.5,0.5,0.5]),imshow(img)
axes('Position',[0.5,0.5,0.5,0.5]),imshow(imgout1)
axes('Position',[0.,0.,0.5,0.5]),imshow(imgout2)
axes('Position',[0.5,0.,0.5,0.5]),imshow(imgout3)










% fig = figure('Position',[490,42,1428,475]);
% axes('Position',[0,0,0.5,1]),imshow(img)
% axes('Position',[0.5,0,0.5,1]),imshow(imgout)
% colormap jet



% tic
% imgout1 = color_segmentation1(img,colors);
% toc
% tic
% imgout2 = color_segmentation2(img,colors);
% toc
% 
% subplot(221),imshow(img)
% subplot(222),imshow(imgout1)
% subplot(223),imshow(imgout2)


function [imgout] = color_segmentation3(img,colors)

% 分类
im_lab = rgb2lab(img);
im_ab = im2single(im_lab(:,:,2:3));
plabels = imsegkmeans(im_ab,colors);

[rows,cols,~] = size(img);
valsum = zeros(colors,3);
valnum = zeros(colors,1);
imgout = zeros(rows,cols,3);

% 确定颜色
for r = 1:rows
    for c = 1:cols
        idx = plabels(r,c);
        valnum(idx) = valnum(idx)+1;
        valsum(idx,:) = valsum(idx,:)+[img(r,c,1),img(r,c,2),img(r,c,3)];
    end
end
labelcolor = valsum./valnum;
% 赋值
for r = 1:rows
    for c = 1:cols
        idx = plabels(r,c);
        imgout(r,c,:) = labelcolor(idx,:);
    end
end

end

function [imgout] = color_segmentation2(img,colors)

im_lab = rgb2lab(img);
im_ab = im2single(im_lab(:,:,2:3));
plabels = imsegkmeans(im_ab,colors);

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
for k = 1:colors
    mask = plabels==k;
    masksum = sum(mask,'all');
    R(mask) = sum(R.*mask,'all')/masksum;
    G(mask) = sum(G.*mask,'all')/masksum;
    B(mask) = sum(B.*mask,'all')/masksum;
end
imgout = cat(3,R,G,B);

end



function imgout = color_segmentation1(img,colors)

im_lab = rgb2lab(img);
im_ab = im_lab(:,:,2:3);
imgout = zeros(size(img));

im_ab = im2single(im_ab);
plabels = imsegkmeans(im_ab,colors);
rgblabels = repmat(plabels,[1 1 3]);

for k = 1:colors
    c = img;
    c(rgblabels ~= k) = NaN;

    r = c(:,:,1);
    g = c(:,:,2);
    b = c(:,:,3);

    r(rgblabels(:,:,1) == k) = mean(r(rgblabels(:,:,1) == k), 'omitnan');
    g(rgblabels(:,:,2) == k) = mean(g(rgblabels(:,:,2) == k), 'omitnan');
    b(rgblabels(:,:,3) == k) = mean(b(rgblabels(:,:,3) == k), 'omitnan');
    c(:,:,1) = r;
    c(:,:,2) = g;
    c(:,:,3) = b;

    c(rgblabels ~= k) = 0;
    imgout = imgout + c;
end

end
