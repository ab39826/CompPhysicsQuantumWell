 function [t,y,z] = euly(dydt,tspan,y0,h, yp0)
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
z = yp0*ones(n,1);
for i = 1:n-1 %implement Euler's method
%y(i+1) = y(i) + dydt(t(i),y(i))*(t(i+1)-t(i));

y(i+1) = y(i) + dydt(y(i))*(t(i+1)-t(i));
z(i+1) = z(i) + (t(i+1)-t(i))*y(i);
end