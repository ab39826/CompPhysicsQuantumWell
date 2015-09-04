 function [t,y] = midpointy(dydt,tspan,y0,h)
%tspan is span of t values
%dydt is the differential function dy/dt = f(t,y)
%yo is initial value
%h is step size
 
ti = tspan(1);tf = tspan(2);
t = (ti:h:tf)'; n = length(t);
% if necessary, add an additional value of t
% so that range goes from t = ti to tf
if t(n)<tf
t(n+1) = tf;
n = n+1;
end

y = y0*ones(n,1); %preallocate y to improve efficiency
for i = 1:n-1 %implement Midpoint Method

 %First calculate yi+1/2
 hhalf = (1/2)*(t(i+1)-t(i));
 yiplushalf = y(i) + dydt(t(i),y(i))*hhalf;
 
 yiplushalfslope = dydt(t(i)+hhalf,yiplushalf);
 y(i+1) = y(i) + yiplushalfslope*(t(i+1)-t(i));
end