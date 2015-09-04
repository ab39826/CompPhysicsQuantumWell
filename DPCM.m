function [D] = DPCM(image)
%generate a shifted image for vectorized subtraction
image = int8(image);
[m n] = size(image);
shiftImage = int8(zeros(m,n));
shiftImage(:,2:end) = image(:,1:end-1);
D = image - shiftImage;
