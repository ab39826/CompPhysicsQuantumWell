function [wellCalc] =quantumwell(numPoints, threshold)

%Our problem is to construct a solution for a 1- dimensional quantum well
%problem

%at a high level, our method is to employ finite differences in order to
%solve for Poisson's equation and Schrodinger's time-independent equation
%self consistently using the method of finite differences.

%Simplifications/Approximations:
%We know that the effective mass differs betweeen GaAs and AlGaAs. Based on
%the "ideal" results given to us, we would find a discontinuity in the 2nd
%derivative of the wave function. In order to correct that, we can either
%A, linearly interpolate effective mass which is more accurate but harder
%to constuct for the Schrodiner matrix or B. precompute an averaged
%effective mass across the entire quantum well system.

%We chose B and use the weighted average GaAlAs and GaAs effective masses.

%constants
hbar = 1.05457173e-34;
mstaraverage = (.41)*(4/5) + (.067)*(1/5);
h = 500/numPoints;
bGDiff = .73;


%First, construct del squared matrix
delSquared = constructdelSquared(numPoints, h);

delSquared = (hbar^2/2*mstaraverage)*delSquared;


%Next, construct symmetrix potential Matrix. (Initially zero matrix of size
%numPoints, but you proceed to add potential corrections everytime along
%diagonal of matrix basically.

V = zeros(numPoints);
Eprev = 0;
groundE = 0;

finalE = zeros(numpoints,1);
finalPot = zeros(numpoints,1);
finalTotalPot = zeros(numpoints,1);
finalWave = zeros(numpoints,1);


while(groundE-Eprev>threshold)
schrodeMatrix = delSquared+V;


%Get the ground state eigenvector and groundstate energy
[psy E] = eig(schrodeMatrix);

ground = psy(:,1);
finalWave = ground;

Eprev = groundE;
groundE = E(1,1);


%now need to ensure that the ground state wave function is normalized.

ground = ground./norm(ground);

n = ground.^2; %charge density


%Now we calculate the E field for every point within the Well
E = computeEfield(n);
finalE = E;

pot = computePotential(n,h);
finalPot = pot;

for i = 1:len
   V(i,i) = pot(i); %construct updated V matrix for next iteration. 
end

end

%now need to plot all relevant quantities wave function, e field, electrostatic potential, total potential, charge density (assume 0 (neutral) outside well)
%charge denisty is Ne*q

x = 1:1:numPoints;

subplot(2,2,1);
plot(x,finalWave);
title('Estimated Ground-State Wave Function');

subplot(2,2,2);
plot(x,finalE);
title('Estimated E-Field for the Well');

subplot(2,2,3);
plot(x,finalPot);
title('Estimated ElectroStatic Potential across Well');

subplot(2,2,4);
finalTotalPot = q*finalPot + bGDiff;
plot(x,finalTotalPot);
title('Estimated Total Potential of the Well');









function [delSquared] = constructdelSquared(n, h)

%this function, takes a size for number of points n and constructs the del
%Squared matrix from it.

delSquared = zeros(n);
delSquared(1,1:2) = [-2 1];
delSquared(end,end-1:end) = [1 -2]; %these are edge conditions

finiteDiff = [1 -2 1];

for i = 2:n-1
   delSquared(i,i-1:i+1) = finiteDiff; 
end

delSquared = delSquared/(h^2);


function [Efield] = computeEfield(n)

%need to compute the efield for the well at every point along the surface
%of the quantum well.

%Constants charge, and Number of electrons per unit area.
len = length(n);


q = 1.6e-19;
doping  = 2e18;
Ne = doping/(.2*len); %doping divided by length of well.
diGaAs = 12.4;
diGaAlAs = 10.1;

sigmae = q*Ne*n; % we construct vector to accound for doping in the well
%CHECK THIS!

for i = 1:2*len/5
   sigmae = 0;
end

for i = 3*len/5:len
   sigmae = 0; 
end

sigmaplus = -q*doping*ones(len,1);

for i = 2*len/5:3*len/5
	sigmaplus(i) = 0; %account for the fact that sigma plus is only non-zero out of the well
end



sigma = sigmae+sigmaplus;


dielec = diGaAlAs*ones(len,1);

for i = 2*len/5:3*len/5
   dielec(i) = diGaAs; %constructing appropriate dielectric vector for different materials 
end


Efield = zeros(len,1);

for i = 1:len
sumE = 0;

    for j = 1:len
    sumE = sumE +(sigma(i)/(2*dielec(i)))*sign(j-i);    
    end
    Efield(i) = sumE;
end




function [potential] = computePotential(E, h)

%use trapezoidal rule for multiple segments to improve accuracy
% potential is just the negative integral of E field

len = length(E);


potential = zeros(len,1);

potential(1) = E(1)/2;

for i = 2:len
    potential(i) = potential(i-1) + ((E(i)-E(i-1))/2)*h;
end