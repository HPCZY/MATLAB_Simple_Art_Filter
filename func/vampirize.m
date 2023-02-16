function imgout = vampirize(img,w)
% w = 0.9;
img = uint8(img*255);
imgEnhanced = entropyfilt(img,getnhood(strel('Disk',4)));
imgEnhanced = mat2gray(imgEnhanced);
imgout = imadjust(imgEnhanced,[0.30; 0.95],[0.90; .00], w);

end

