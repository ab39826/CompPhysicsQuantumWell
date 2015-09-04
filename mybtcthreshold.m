function [binBlock] = mybtcthreshold(block,mu)
block(block<mu) = 0;
block(block>=mu) = 1;
binBlock = block;
end