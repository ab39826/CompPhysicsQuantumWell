function [mu, sigma] = mybtcmeanstd(block,b1, b2)
mu = mean2(block); %compute mean and standard dev of image block
sigma = std2(block);
%now need to truncate mean and std values to fit within given bit limits.
%now round to nearest integer in range of 0 to 2^b1 for both mean and std
%dev
mu = (2^b1)*mu;
mu = round(mu/256);

mu = (256/(2^b1))*mu;

sigma = (2^b2)*sigma;
sigma = round(sigma/256);
sigma = (256/(2^b2))*sigma;

end