function imgout = cubist(img,pnum,alpha,lambda)

[rows,cols,~] = size(img);
[x,y] = meshgrid(1:cols, 1:rows);

% 参数
drow = cols/pnum;
dcol = rows/pnum;
parts = zeros(pnum*pnum,6); 
for i = 1:pnum
    for j = 1:pnum
        idx = (i-1)*pnum+j;
        parts(idx,1:2) = round([(i-0.5)*drow,(j-0.5)*dcol]);
        parts(idx,3) = 0.2+rand()*0.6;
        parts(idx,4) = 1-parts(idx,3);
        parts(idx,5) = min(drow,dcol)+rand()*50;
        parts(idx,6) = -pi/2+rand()*pi;
    end
end
% 色阶
levels = 15;
R = img(:,:,1);
minV = min(R,[],'all');    
R = round((R-minV)*levels)/levels+minV;
G = img(:,:,2);
minV = min(G,[],'all');    
G = round((G-minV)*levels)/levels+minV;
B = img(:,:,3);
minV = min(B,[],'all');    
B = round((B-minV)*levels)/levels+minV;

R = imgaussfilt(R,3);
G = imgaussfilt(G,3);
B = imgaussfilt(B,3);

newR = nan(rows,cols);
newG = nan(rows,cols);
newB = nan(rows,cols);

shapes = randperm(pnum*pnum);

for p = 1:pnum*pnum

    q = shapes(p);

    % 目标区域
    [indx,indy] = find((x-parts(q,1)).^2+(y-parts(q,2)).^2<=parts(q,5)^2);    
    xt = x(sub2ind([rows,cols],indx,indy));
    yt = y(sub2ind([rows,cols],indx,indy));
    
    % 变形   
    theta = atan2((yt-parts(q,2)), (xt-parts(q,1)));
    x_circ = parts(q,5) * cos(theta);
    y_circ = parts(q,5) * sin(theta);
    mags = transfer(sqrt(((xt-parts(q, 1)).^2 + (yt-parts(q,2)).^2) ./ (x_circ.^2 + y_circ.^2)), lambda);
    denom = ((cos(theta)/parts(q,3)).^(2/alpha)+(sin(theta)/parts(q,4)).^(2/alpha)).^(alpha/2);    
    x_dist = 2*parts(q,5)*cos(theta)./denom;
    y_dist = 2*parts(q,5)*sin(theta)./denom;
    
    % 旋转
    dx = (x_dist-x_circ).* mags;
    dy = (y_dist-y_circ).* mags;
    ndx = indx+round(cos(parts(q,6))*dx - sin(parts(q,6))*dy);
    ndy = indy+round(sin(parts(q,6))*dx + cos(parts(q,6))*dy);

    % 筛选
    indx = cat(1,indx,indx,indx,indx,indx);
    indy = cat(1,indy,indy,indy,indy,indy);
    coor = cat(2,indx,indy);

    ndx = cat(1,ndx-1,ndx,ndx,ndx,ndx+1);
    ndy = cat(1,ndy,ndy-1,ndy,ndy+1,ndy);
    ncoor = cat(2,ndx,ndy);

    [ncoor,ia] = unique(ncoor,"rows");
    coor = coor(ia,:);

    mask = ncoor(:,1)<1 | ncoor(:,1)>rows | ncoor(:,2)<1 | ncoor(:,2)>cols;
    ncoor(mask,:) = [];
    coor(mask,:) = [];

    % 赋值
    coor = sub2ind([rows,cols],coor(:,1),coor(:,2));
    ncoor = sub2ind([rows,cols],ncoor(:,1),ncoor(:,2));
    newR(ncoor) = R(coor);
    newG(ncoor) = G(coor);
    newB(ncoor) = B(coor);

end

filler = imgaussfilt(cat(3,R,G,B), 3);
imgout = cat(3,newR,newG,newB);
imgout(isnan(imgout)) = filler(isnan(imgout));
imgout = imgaussfilt(imgout, 1);

end