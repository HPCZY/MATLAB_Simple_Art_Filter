clear; clc
% 读取图片
img = imread('test.jpeg');
% 预处理
img = im2double(img);
[rows,cols,dims] = size(img);
% 参数
block = 1000;

%% 分块
tic
[labels,block] = superpixels(img,block);
toc

%% 方法一
tic
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
for p = 1:block
    mask = labels==p;
    R(mask) = mean(R(mask));
    G(mask) = mean(G(mask));
    B(mask) = mean(B(mask));
end
imgout1 = cat(3,R,G,B);
toc

%% 方法二
tic
plist = cell(block,1);
for i = 1:rows*cols
    p = labels(i);
    plist{p} = [plist{p},i];
end
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
for p = 1:block
    R(plist{p}) = mean(R(plist{p}));
    G(plist{p}) = mean(G(plist{p}));
    B(plist{p}) = mean(B(plist{p}));
end
imgout2 = cat(3,R,G,B);
toc

%% 方法三
tic
% 预分配内存
table = tabulate(labels(:));
plist = zeros(block,max(table(:,2)),'uint64');
nlist = zeros(block,1);
% 分组
for i = 1:rows*cols
    p = labels(i);
    nlist(p) = nlist(p)+1;
    plist(p,nlist(p)) = i;
end
% 上色
R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
for p = 1:block
    idx = plist(p,1:nlist(p));
    R(idx) = mean(R(idx));
    G(idx) = mean(G(idx));
    B(idx) = mean(B(idx));
end
imgout3 = cat(3,R,G,B);
toc

fig = figure('Position',[490,42,1428,951]);
axes('Position',[0,0.5,0.5,0.5]),imshow(img)
axes('Position',[0.5,0.5,0.5,0.5]),imshow(imgout1)
axes('Position',[0.,0.,0.5,0.5]),imshow(imgout2)
axes('Position',[0.5,0.,0.5,0.5]),imshow(imgout3)


