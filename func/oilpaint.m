function imgout = oilpaint(img,rad)

[rows,cols,~] = size(img);
imgout = zeros(rows,cols,3);
for i=1:rows
    for j=1:cols
        iMin = max(i-rad,1);
        iMax = min(i+rad,rows);
        jMin = max(j-rad,1);
        jMax = min(j+rad,cols);

       tmp = img(iMin:iMax,jMin:jMax,:);
       
       imgout(i,j,1) = mode(tmp(:,:,1),'all');
       imgout(i,j,2) = mode(tmp(:,:,2),'all');
       imgout(i,j,3) = mode(tmp(:,:,3),'all');
    end
end

end
