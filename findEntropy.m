function [entropy] = findEntropy(image)
 
[m n] = size(image);
hist = imhist(image);
 
%first find normalized histogram probability.
normhist = hist/(m*n); 
loghist = log2(normhist+1); 
entropy = -1*(normhist'*loghist);
