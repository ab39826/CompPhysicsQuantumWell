function [image] = DPCMReverse(DPCM, Irow)
image = zeros(size(DPCM));
[m n] = size(image);
image(:,1) = Irow;

image = int8(image);
for i = 2:n
    image(:,i) = image(:,i-1) + DPCM(:,i);
end

end
