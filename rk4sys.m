function [tp,yp, zp] = rk4sys(dydt,tspan,y0,h,yp0)
%tspan is span of t values
%dydt is the differential function dy/dt = f(t,y)
%yo is initial value
%h is step size
 

n = length(tspan);
ti = tspan(1);tf = tspan(n);
if n == 2
t = (ti:h:tf)'; n = length(t);
if t(n)<tf
t(n+1) = tf;
n = n+1;
end
else
t = tspan;
end
tt = ti; y(1,:) = y0;
z(1,:) = yp0;
np = 1; tp(np) = tt; yp(np,:) = y(1,:); 
zp(np,:) = z(1,:);
i=1;
while(1)
tend = t(np+1);
hh = t(np+1) - t(np);
if hh>h,hh = h;end
while(1)
if tt+hh>tend,hh = tend-tt;end
%{
k1 = dydt(tt,y(i,:))'; %k1 first interval estimate
ymid = y(i,:) + k1.*hh./2;
k2 = dydt(tt+hh/2,ymid)'; %k2 improved estimate
ymid = y(i,:) + k2*hh/2;
k3 = dydt(tt+hh/2,ymid)'; %k3 improved improved estimate
yend = y(i,:) + k3*hh;
k4 = dydt(tt+hh,yend)'; % final improved estimate
phi = (k1+2*(k2+k3)+k4)/6; %weighted sum of all 4 estimates
y(i+1,:) = y(i,:) + phi*hh; %final functional numerical evaluation
%}

k1 = dydt(y(i,:))'; %k1 first interval estimate
ymid = y(i,:) + k1.*hh./2;
k2 = dydt(ymid)'; %k2 improved estimate
ymid = y(i,:) + k2*hh/2;
k3 = dydt(ymid)'; %k3 improved improved estimate
yend = y(i,:) + k3*hh;
k4 = dydt(yend)'; % final improved estimate
phi = (k1+2*(k2+k3)+k4)/6; %weighted sum of all 4 estimates
y(i+1,:) = y(i,:) + phi*hh; %final functional numerical evaluation

z(i+1,:) = z(i,:) + hh*y(i,:);

%{
k1z = dzdt(tt,z(i,:))'; %k1 first interval estimate
zmid = z(i,:) + k1z.*hh./2;
k2z = dzdt(tt+hh/2,zmid)'; %k2 improved estimate
zmid = y(i,:) + k2*hh/2;
k3z = dydt(tt+hh/2,ymid)'; %k3 improved improved estimate
zend = z(i,:) + k3z*hh;
k4z = dzdt(tt+hh,zend)'; % final improved estimate
phiz = (k1z+2*(k2z+k3z)+k4z)/6; %weighted sum of all 4 estimates
z(i+1,:) = z(i,:) + phiz*hh; %final functional numerical evaluation
%}


tt = tt+hh;
i=i+1;
if tt>=tend,break,end
end
np = np+1; tp(np) = tt; yp(np,:) = y(i,:); zp(np,:) = z(i,:);
if tt>=tf,break,end
end