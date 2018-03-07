function [dydt] = popnmodelworking2(t, y, latitude)
%This models the population level growth of Anabaena, as a function of
%nitrogen, phosphate and light levels.


dydt = zeros(5,1);

% Parameters
rN = 5e-3;     % Rate of nitrogen consumption
rC = 60e-3;     % Rate of carbon consumption
rP = 0.4e-3;     % Rate of phosphate consumption
a = 0.004;
b = 0.001;        % Maximal external P uptake rate
p3 = 1e-5;
Gsc = 1000;     % Mean incident sunlight intensity on earth
k = 10;
ka = 100;
kb = 1;
kN = 1.8;
kC = 15;
kP = 0.3;
kI = 0.1;
kV = 0.1;
rp = 2.4;
rd = 0.03;
pv = 0.85;
ph = 1-pv;
kPext = 0.5;     % Amount of phosphate for half maximal uptake rate


% Time parameters
beta = 70;
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

% Calculating the intensity of the sunlight as a function of the day (!)
  
A = Gsc*(sind(latitude)*sind(delta) + cosd(latitude)*cosd(delta));

% Indexing the different y values

N1 = y(1);
V1 = y(2);
C1 = y(3);
P1 = y(4);

%N2 = y(5);
%V2 = y(6);
%H2 = y(7);
%C2 = y(8);
%P2 = y(9);
Pext = y(5);

% Producing the light rhythm and the circadian rhythm

    gamma = cos((timeofday - 12)*pi/12);
      rho = cos((Sunrise - 12)*pi/12);
    alpha = -((-beta*rho + log(-xs/(-1 + xs)))/beta);
        I = A*(exp(beta*(gamma - alpha)))/(1+exp(beta*(gamma - alpha)));
circadian = (exp(beta*(gamma - alpha)))/(1+exp(beta*(gamma - alpha)));

% Growth parameters as functions of resource levels

Z = ka*(N1/(N1 + kN))*(C1/(C1+kC))*(P1/(P1+kP));
%Z2 = ka*(N2/(N2 + kN))*(C2/(C2+kC));%*(P2/(P2 + kP));

% Conversion of light into carbon (depends on population size) 

ZL = kb*(I/(I + kI))*(V1/(V1 + kV));
%ZL2 = kb*(I/(I + kI))*(V2/(V2 + kV));

rNN = 1.9e-3;
kNN = 0.6;
rCC = 0.5e-3;
kCC = 1.2;
rPP = 0.1e-3;
kPP = 0.3;

% Species 1:
dydt(1) = a*(C1/(C1 + k))*V1 - rN*V1*Z - rNN*V1*(N1/(kNN + N1));                                    % N1
dydt(2) = V1*(rd*Z -p3*V1);                                                                         % V1
dydt(3) = rp*circadian*ZL - rC*V1*Z - a*V1*(1-circadian)*((C1/(C1+k))) - rCC*V1*(C1/(kCC + C1));    % C1
dydt(4) = 2*b*(Pext/(Pext + kPext))*V1 - rP*V1*Z - rPP*V1*(P1/(kPP + P1));

% Species 2:
%dydt(5) = 2*a*(C2/(C2 + k))*H2 - rN*V2;                                  % N2
%dydt(6) = V2*(rd*pv*Z2 -p3*(V2+H2));                                     % V2
%dydt(7) = -p3*(H2 + V2)*H2 + rd*ph*V2*Z2;                                % H2
%dydt(8) = ZL2*rp - rC*V2*Z2 - a*H2*C2/(C2 + k);                          % C2
%dydt(9) = 2*b*(Pext/(Pext + kPext))*V2 - rP*V2*Z2;
dydt(5) = 0.008 - 2*b*(Pext/(Pext + kPext))*V1; %-2*b*(Pext/(Pext + kPext))*V2;


end

