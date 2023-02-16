function imgout = rastafarian(img,rad)

h = fspecial('gaussian', 5 ,1.5);
img2 = imfilter(img,h,'replicate');

se = strel('ball',rad,rad);
X = im2double(imdilate(uint8(img2*255),se));

Y = rgb2gray(X);
mask = zeros(size(Y));
mask(2:end-1,2:end-1) = (Y(1:end-2,2:end-1)==Y(3:end,2:end-1)) & (Y(2:end-1,1:end-2)==Y(2:end-1,3:end));

imgout = X.*mask;
end
