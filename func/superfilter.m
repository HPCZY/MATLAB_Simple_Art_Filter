function imgout = superfilter(img,block)

[rows,cols,dims] = size(img);
[labels,block] = superpixels(img,block);

table = tabulate(labels(:));
plist = zeros(block,max(table(:,2)),'uint64');
nlist = zeros(block,1);
for i = 1:rows*cols
    p = labels(i);
    nlist(p) = nlist(p)+1;
    plist(p,nlist(p)) = i;
end

R = img(:,:,1);
G = img(:,:,2);
B = img(:,:,3);
for p = 1:block
    idx = plist(p,1:nlist(p));
    R(idx) = mean(R(idx));
    G(idx) = mean(G(idx));
    B(idx) = mean(B(idx));
end
imgout = cat(3,R,G,B);

end
