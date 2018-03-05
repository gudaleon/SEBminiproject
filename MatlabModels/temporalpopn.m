function [dydt] = temporalpopn(t, y, latitude)
%This models the population level growth of Anabaena, as a function of
%nitrogen, phosphate and light levels.


dydt = zeros(10,1);

% Parameters
r = 10e-2;
a = 0.1;
p3 = 0.001;
A = 1000;
k = 100;
r0 = 1;
k0 = 1;
kN = 10;
kC = 10;
kNC = 1;
kI = 10;
kV = 10;
kIV = 1;
rp = 6;
rd = 0.03;
kG = 10;
kIG = 1;        % Product of amount of 
pv = 0.85;      % Proportion vegetative
ph = 1-pv;      % Proportion heterocyst

% Time parameters
beta = 70;
phi = 12;
xs = 0.0001;

% Calculating the time of sunrise in hours(!)

day = floor(t/24) +1;
timeofday = mod(t,24);
n = day + 0.0008;

M = mod(n*0.98560028 + 357.5291, 360);
C = 1.9148*sind(M)+0.02*sind(2*M) + 0.0003*sind(3*M);
lambda = mod(M + C + 180 + 102.9372, 360);
delta = asind(sind(lambda)*sind(23.44));
w = acosd((sind(-0.83) - sind(latitude)*sind(delta))/cosd(latitude)*cosd(delta));
Jtransit = 2451545.5 + n + 0.0053*sind(M) - 0.0069*sind(2*lambda);
Jrise = Jtransit - w/360;
Jrise = Jrise - floor(Jrise);
Sunrise = Jrise*24;

gamma = cos((timeofday - 12)*pi/12);
rh = cos((Sunrise - 12)*pi/12);
alpha = -((-beta*rh + log(-xs/(-1 + xs)))/beta);
I = A*(exp(beta*(gamma - alpha)))/(1+exp(beta*(gamma - alpha)));
circadian = (exp(beta*(gamma - alpha)))/(1+exp(beta*(gamma - alpha)));

% Assignment of the variables

N1 = y(1);
V1 = y(2);
C1 = y(3);
P1 = y(4);

N2 = y(5);
V2 = y(6);
H2 = y(7);
C2 = y(8);
P2 = y(9);

Pext = y(10);

Z = r0*(N1/(kN+N1))*(P1/(kP+P1))*(C1/(kC + C1));
ZL = r0/(k0 + 1/kI*I + 1/(kV*V1) + 1/(kI*kV*I*V1));

Z2 = r0*(N2/(kN+N2))*(P2/(kP+P2))*(C2/(kC + C2));
ZL2 = r0/(k0 + 1/kI*I + 1/(kV*V2) + 1/(kI*kV*I*V2));

% Species 1: circadian
dydt(1) = 2*a*(C1/(C1 + k)*V1) - r*V1*Z;                                      % Nitrogen
dydt(2) = -p3*V1 + rd*V1*Z;                                                   % Logistic growth, with growth being the difference between the amount of nitrogen and carbon, and the current popn size.
dydt(3) = rp*circadian*ZL - r*V1*Z - a*(1-circadian)*(C1/C1+k)*V1);           % Carbon
dydt(4) = (Pext*ph)/(kPimp + Pext)*V1 - 

% Species 2: heterocystous
dydt(5) = 2*a*V2/(V2 + k)*H2 - r*V2*Z2;
dydt(6) = -p3*V2 + rd*pv*V2*Z2;
dydt(7) = -p3*H3 + rd*ph*V2*Z2;
dydt(8) = rp*ZL2 - r*V2*Z2 - a*H2*(C2/(C2 + k));

% Species 3:

% At the moment, this gives faster growth at higher latitudes, because the
% intensity of sunlight has not been adjusted for.

end

