function imgout = color_segmentation(img,colors)

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