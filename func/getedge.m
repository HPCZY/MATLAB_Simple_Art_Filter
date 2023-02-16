function h = getedge(n1,s1,n2,s2,theta)

r = [cos(theta),-sin(theta); sin(theta),cos(theta)];
[x,y] = meshgrid(-(n2-1)/2:(n2-1)/2,-(n1-1)/2:(n1-1)/2);

xt = r(1,1)*x+r(1,2)*y;
yt = r(2,1)*x+r(2,2)*y;

gx = exp(-xt.^2/(2*s1^2))/(s1*sqrt(2*pi));
gy = exp(-yt.^2/(2*s2^2))/(s2*sqrt(2*pi));    

h = -yt/s2^2.*gx.*gy;
h = h/sqrt(sum(h.^2,'all'));

end
