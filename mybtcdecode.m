function[decodeBlock] = mybtcdecode(binBlock, mu, sigma)
Q = sum(sum(binBlock)); %number 1's
P = numel(binBlock) -Q; %number 0's

A = sqrt(Q/P);
binBlock(binBlock>=1) = mu + (sigma/A);
binBlock(binBlock<1) = mu - (sigma*A);

decodeBlock = binBlock;
end