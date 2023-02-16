function imgout = comic(img)

B = decorrstretch(img,'tol',0.3);
G = fspecial('gaussian',[5 5],2);
B = imfilter(B,G);
imgout = imadjust(B,[0.30; 0.85],[0.00; 0.90], 0.90);

end


