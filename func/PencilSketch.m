function imgout = PencilSketch(img,p,thresh,w)
% 20.1,0.3,3

if size(img,3)==3
    imgray = rgb2gray(img);
else
    imgray = img;
end

G1 = fspecial('Gaussian',5,.5);
G2 = fspecial('Gaussian',5,2);
dog = (1+p)*G1-(p*G2);

imgdog = conv2(imgray,dog,'same');
mask = imgdog<=thresh;
imgdog2 = 0.9+tanh(w*(imgdog-thresh)).*mask;

G3 = fspecial('Gaussian',10,1.5);
imgout = conv2(imgdog2,G3,'same');

end

