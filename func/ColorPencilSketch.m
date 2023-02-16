function imgout = ColorPencilSketch(img,p,thresh,w)

R = PencilSketch(img(:,:,1),p,thresh,w);
G = PencilSketch(img(:,:,2),p,thresh,w);
B = PencilSketch(img(:,:,3),p,thresh,w);
imgout = cat(3,R,G,B);

end

