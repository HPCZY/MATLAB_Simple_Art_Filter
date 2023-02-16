function imgout = npr(img)
%NPR

imgray = rgb2gray(img);

% 卷积核
fx = getedge(10, 1, 10, 1, pi/2);
fy = getedge(10, 1, 10, 1, 0);
% 卷积
ux = conv2(imgray, fx, 'same');
uy = conv2(imgray, fy, 'same');
% 边缘
uxy = sqrt(ux.*ux + uy.*uy);
% 这里没理解
gx = uxy.*ux;
gy = uxy.*uy;

% Using the above constraints, the goal is to solve
%   min_{f} { wx(fx - gx)^2 + wy(fy - gy)^2 + wd(f - d)^2
% to find the output image, f

[rows,cols,dims] = size(img);
pixelnum = rows*cols;
% 稀疏矩阵
num_equations = 5*pixelnum;
im2var = zeros(rows,cols);
im2var(1:pixelnum) = 1:pixelnum;

frgb = zeros(rows,cols,dims); % Output filtered image
for dim = 1:3
  e = 1; % Equation counter
  idx = 0;


  sparse_i = zeros(1,num_equations*2);
  sparse_j = zeros(1,num_equations*2);
  sparse_k = zeros(1,num_equations*2);
  b = zeros(num_equations, 1);

  for r = 1:rows
    for c = 1:cols

      % Up
      if r ~= 1
        idx = idx+1;
        sparse_i(idx) = e;
        sparse_j(idx) = im2var(r,c);
        sparse_k(idx) = 1;
        idx = idx+1;
        sparse_i(idx) = e;
        sparse_j(idx) = im2var(r-1,c);
        sparse_k(idx) = -1;
        
        b(e) = gy(r-1,c);
        e = e + 1;
      end
      
      % Down
      if r ~= rows
        idx = idx+1;
        sparse_i(idx) = e;
        sparse_j(idx) = im2var(r,c);
        sparse_k(idx) = 1;
        idx = idx+1;
        sparse_i(idx) = e;
        sparse_j(idx) = im2var(r+1,c);
        sparse_k(idx) = -1;
        
        b(e) = gy(r+1,c);
        e = e + 1;
      end
      
      % Right
      if c ~= cols
        idx = idx+1;
        sparse_i(idx) = e;
        sparse_j(idx) = im2var(r,c);
        sparse_k(idx) = 1;
        idx = idx+1;
        sparse_i(idx) = e;
        sparse_j(idx) = im2var(r,c+1);
        sparse_k(idx) = -1;
        
        b(e) = gx(r,c+1);
        e = e + 1;
      end
      
      % Left
      if c ~= 1
        idx = idx+1;
        sparse_i(idx) = e;
        sparse_j(idx) = im2var(r,c);
        sparse_k(idx) = 1;
        idx = idx+1;
        sparse_i(idx) = e;
        sparse_j(idx) = im2var(r,c-1);
        sparse_k(idx) = -1;
        
        b(e) = gx(r,c-1);
        e = e + 1;
      end
      
      % wd(f - d)^2
      idx = idx+1;
      sparse_i(idx) = e;
      sparse_j(idx) = im2var(r,c);
      sparse_k(idx) = 1;
      
      b(e) = img(r,c,dim);
      e = e + 1;
    end
  end
  
sparse_i = sparse_i(1:idx);
sparse_j = sparse_j(1:idx);
sparse_k = sparse_k(1:idx);

  A = sparse(sparse_i, sparse_j, sparse_k, num_equations, pixelnum);

  frgb(:,:,dim) = reshape(A\b,[rows,cols]); 

end

imgout = frgb-uxy;

end

