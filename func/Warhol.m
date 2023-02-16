function imgout = Warhol(img)
se = strel('disk',18);
imgEnhanced = imsubtract(imadd(img,imtophat(img,se)),imbothat(img,se));

imgEnhanced1 = imadjust(imgEnhanced,[0.00 0.00 0.00; 1.00 0.38 0.40],[1.00 0.00 0.70; 0.20 1.00 0.40], [4.90 4.00 1.70]);
imgEnhanced2 = imadjust(imgEnhanced,[0.13 0.00 0.30; 0.75 1.00 1.00],[0.00 1.00 0.50; 1.00 0.00 0.27], [5.90 0.80 4.10]);

imgEnhanced3 = imadjust(img,[0.20 0.00 0.09; 0.83 1.00 0.52],[0.00 0.00 1.00; 1.00 1.00 0.00], [1.10 2.70 1.00]);
imgEnhanced4 = imadjust(img,[0.20 0.00 0.00; 0.70 1.00 1.00],[1.00 0.90 0.00; 0.00 0.90 1.00], [1.30 1.00 1.00]);
imgout = [imgEnhanced1 imgEnhanced2; imgEnhanced3 imgEnhanced4]; % (Images 2 and 4 are flipped plane-by-plane.)

end