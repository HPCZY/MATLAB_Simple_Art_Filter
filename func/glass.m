function imgout = glass(img,rad)

[rows,cols,dims] = size(img);

[x,y] = meshgrid(1:cols,1:rows);
rdx = randi(rad*2+1,rows,cols)-rad-1;
rdy = randi(rad*2+1,rows,cols)-rad-1;

xt = x+rdx;
yt = y+rdy;
xt(xt<1) = 1;
xt(xt>cols) = cols;
yt(yt<1) = 1;
yt(yt>rows) = rows;

if dims==3
    R = interp2(x,y,img(:,:,1),xt,yt);
    G = interp2(x,y,img(:,:,2),xt,yt);
    B = interp2(x,y,img(:,:,3),xt,yt);
    imgout = cat(3,R,G,B);
end
if dims==1
    imgout = interp2(x,y,img,xt,yt);
end
end