function imgout = minmaxfilt(img,rad,type)

if type==0
    idx = 1;
else
    idx = (rad*2+1)^2;
end
mask = ones(rad*2+1);
R = ordfilt2(img(:,:,1),idx,mask);
G = ordfilt2(img(:,:,2),idx,mask);
B = ordfilt2(img(:,:,3),idx,mask);
imgout = cat(3,R,G,B);

end

