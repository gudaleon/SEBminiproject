function [dydt] = temporalpopnorig(t, y, latitude)
%This models the population level growth of Anabaena, as a function of
%nitrogen, phosphate and light levels.


dydt = zeros(7,1);

% Parameters
r = 10e-2;
a = 0.1;
p3 = 0.001;
Gsc = 10000;
k = 100;
r0 = 1;
k0 = 1;
kN = 10;
kC = 10;
kNC = 1;
kI = 100;
kV = 10;
kIV = 1;
rp = 1;
rd = 0.03;
kG = 10;
kIG = 1;
pv = 0.85;
ph = 1-pv;
rph = 0.1;
kph = 2;
ka = 1;
kb = 1;
kP = 1;

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

A = Gsc*(sind(latitude)*sind(delta) + cosd(latitude)*cosd(delta));

gamma = cos((timeofday - 12)*pi/12);
rho = cos((Sunrise - 12)*pi/12);
alpha = -((-beta*rho + log(-xs/(-1 + xs)))/beta);
I = A*(exp(beta*(gamma - alpha)))/(1+exp(beta*(gamma - alpha)));
circadian = (exp(beta*(gamma - alpha)))/(1+exp(beta*(gamma - alpha)));

% Indexing the different y values

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

% Growth parameters as functions of resource levels

Z = ka*(N1/(N1 + kN))*(C1/(C1+kC));%*(P1/(P1+kP));
Z2 = ka*(N2/(N2 + kN))*(C2/(C2+kC));%*(P2/(P2 + kP));

% Conversion of light into carbon (depends on population size) 

ZL = kb*(I/(I + kI))*(V1/(V1 + kV));
ZL2 = kb*(I/(I + kI))*(V2/(V2 + kV));

% Species 1:
dydt(1) = 2*a*(y(3)/(y(3) + k)*y(2)) - r*y(2)*Z;
dydt(2) = -p3*y(2) + rd*y(2)*Z;                     % Logistic growth, with growth being the difference between the amount of nitrogen and carbon, and the current popn size.
dydt(3) = rp*circadian*ZL - r*y(2)*Z - a*(1-circadian)*(y(3)/(y(3)+k)*y(2));
dydt(4) = 0; %V1*rph*Pext/(kph + Pext) - V1*r;

% Species 2:
dydt(5) = 2*a*(y(7)/(y(7) + k))*y(6) - r*y(5)*Z2;
dydt(6) = -p3*y(5) + rd*pv*y(5)*Z2;
dydt(7) = -p3*y(6) + rd*ph*y(5)*Z2;
dydt(8) = rp*ZL2 - r*y(5)*Z2 - a*y(6)*(y(7)/(y(7) + k));
dydt(9) = 0; %V2*rph*V2/(kph + V2) - V2*r;
dydt(10) = 0; %0.1 - V1*rph*Pext/(kph + Pext) - y(6)*rph*y(10)/(kph + y(10));

% At the moment, this gives faster growth at higher latitudes, because the
% intensity of sunlight has not been adjusted for.

end

