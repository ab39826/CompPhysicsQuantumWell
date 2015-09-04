function [tp,yp, zp] = rk4sys(dydt,tspan,y0,h,yp0)
t = tpsan(1):h:tspan(2);
y = 1:length(t);
y(1) = y0;

z = 1:length(t);
z(1) = yp0;

for i =1:(length(t)-1)
k1 = fxy(t(i),y(i));
k2 = fxy((t(i)+.5*h), (y(i)+.5*h*k1));
k3 = fxy((t(i)+.5*h), (y(i)+.5*h*k2));
k4 = fxy((t(i)+h), (y(i)+ h*k3));

y(i+1) = y(i)+(1/6)*h*(k1+2*k2+2*k3+k4);

end