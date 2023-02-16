function imgout = pointillism(img,R,w)

[rows,cols,dims] = size(img);
layer1 = img;
for i = 1:2*R-1:rows
    for j = 1:2*R-1:cols      
        for x = -R:R
            for y = -R:R
                if i+x<1 || i+x>rows || j+y<1 || j+y>cols
                    continue
                end
                if x^2+y^2<=R^2
                    layer1(i+x,j+y,:) = img(i,j,:);
                end
            end
        end
    end    
end

layer2 = zeros(rows,cols,dims);
for i = 1:2*R+1:rows
    for j = 1:2*R+1:cols  
        xc = randi([i-R,i+R]); 
        yc = randi([j-R,j+R]);
        r = randi([1,R]);
        for x = -r:r
            for y = -r:r
                if xc+x<1 || xc+x>rows || yc+y<1 || yc+y>cols
                    continue
                end
                if x^2+y^2<=r^2
                    layer2(xc+x,yc+y,:) = img(i,j,:);
                end
            end
        end
    end    
end
imgout = layer1*w+layer2*(1-w);

end
