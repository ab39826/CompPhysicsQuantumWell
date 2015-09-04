function [q,ea,iter]=romberg(func,a,b,es,maxit,varargin)
% romberg: Romberg integration quadrature
% q = romberg(func,a,b,es,maxit,p1,p2,...):
% Romberg integration.
% input:
% func = name of function to be integrated
% a, b = integration limits
% es = desired relative error (default = 0.000001%)
% maxit = maximum allowable iterations (default = 30)
% pl,p2,... = additional parameters used by func
% output:
% q = integral estimate
% ea = approximate relative error (%)
% iter = number of iterations

n = 1;
I(1,1) = trap(func,a,b,n,varargin{:});
iter = 0;
while iter<maxit
iter = iter + 1;
n = 2^iter;
I(iter+1,1) = trap(func,a,b,n,varargin{:});
for k = 2:iter+1
j = 2+iter-k;
I(j,k) = (4^(k-1)*I(j+1,k-1)-I(j,k-1))/(4^(k-1)-1);
end
ea = abs((I(1,iter+1)-I(2,iter))/I(1,iter+1))*100;
if ea<=es, break; end
end
q = I(1,iter+1);