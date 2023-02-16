function imgout = cartoon(img,quant_levels)

  

max_gradient      = 0.1;    % maximum gradient (for edges)
sharpness_levels  = [3 14]; % soft quantization sharpness
% quant_levels      = 8;      % number of quantization levels
min_edge_strength = 0.1;    % minimum gradient (for edges)

% 双边滤波
% w     = 5;         
% sigma = [3 0.1]; 
% B = bfilter2(img,w,sigma);

img(:,:,1) = medfilt2(img(:,:,1),[3,3]);
img(:,:,2) = medfilt2(img(:,:,2),[3,3]);
img(:,:,3) = medfilt2(img(:,:,3),[3,3]);

B = applycform(img,makecform('srgb2lab'));

% 边缘
[GX,GY] = gradient(B(:,:,1)/100);
G = sqrt(GX.^2+GY.^2);
G(G>max_gradient) = max_gradient;
G = G/max_gradient;

S = (sharpness_levels(2)-sharpness_levels(1))*G+sharpness_levels(1);

E = G;%>min_edge_strength; 
E(E<min_edge_strength) = 0;


% 颜色分层
qB = B; 
dq = 100/(quant_levels-1);
qB(:,:,1) = round(qB(:,:,1)/dq)*dq;
qB(:,:,1) = qB(:,:,1)+(dq/2)*tanh(S.*(B(:,:,1)-qB(:,:,1)));

Q = applycform(qB,makecform('lab2srgb'));

% 勾勒轮廓
imgout = repmat(1-E,[1 1 3]).*Q;

end


