function [dydt] = popnmodelheterotroph(t, y, latitude, Gsc)
%This models the population level growth of Anabaena, as a function of
%nitrogen, phosphate and light levels.


dydt = zeros(6,1);

% Parameters
rN = 5e-3;     % Rate of nitrogen consumption
rC = 30e-3;     % Rate of carbon consumption
rP = 0.5e-3;     % Rate of phosphate consumption
p = 0.003;        % Maximal external P uptake rate
nu = 0.3;
p3 = 1e-5;     % Mean incident sunlight intensity on earth
ka = 200;
kb = 1;
kN = 2.4;
kC = 15;
kP = 0.3;
kI = 0.1;
kV = 0.1;
rp = 6;
rd = 0.03;
pv = 0.85;
kPext = 0.5;     % Amount of phosphate for half maximal uptake rate
kNext = 0.5;

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

%N1 = y(1);
%V1 = y(2);
%C1 = y(3);
%P1 = y(4);

%N2 = y(1);
%V2 = y(2);
%H2 = y(3);
%C2 = y(4);
%P2 = y(5);
%Pext = y(6);

N3 = y(1);
V3 = y(2);
C3 = y(3);
P3 = y(4);
Pext = y(5);
Next = y(6);

% Producing the light rhythm and the circadian rhythm

    gamma = cos((timeofday - 12)*pi/12);
      rho = cos((Sunrise - 12)*pi/12);
    alpha = -((-beta*rho + log(-xs/(-1 + xs)))/beta);
    I = A*(exp(beta*(gamma - alpha)))/(1+exp(beta*(gamma - alpha)));
%circadian = (exp(beta*(gamma - alpha)))/(1+exp(beta*(gamma - alpha)));

% Growth parameters as functions of resource levels

%Z = ka*(N1/(N1 + kN))*(C1/(C1+kC))*(P1/(P1+kP));
%Z2 = ka*(N2/(N2 + kN))*(C2/(C2+kC));%*(P2/(P2 + kP));
Z3 = ka*(N3/(N3 + kN))*(C3/(C3+kC))*(P3/(P3 + kP));
% Conversion of light into carbon (depends on population size) 

%ZL = kb*(I/(I + kI))*(V1/(V1 + kV));
%ZL2 = kb*(I/(I + kI))*(V2/(V2 + kV));dydt(5) = 0.008 - 2*b*(Pext/(Pext + kPext))*V3;
ZL3 = kb*(I/(I + kI))*(V3/(V3 + kV));

rNN = 5e-3;
kNN = 0.4;
rCC = 60e-3;
kCC = 15;
rPP = 0.5e-3;
kPP = 0.3;

% Species 1:
%dydt(1) = a*(C1/(C1 + k))*V1 - rN*V1*Z - rNN*V1*(N1/(kNN + N1));                                    % N1
%dydt(2) = V1*(rd*Z -p3*V1);                                                                         % V1
%dydt(3) = rp*circadian*ZL - rC*V1*Z - a*V1*(1-circadian)*((C1/(C1+k))) - rCC*V1*(C1/(kCC + C1));    % C1
%dydt(4) = 2*b*(Pext/(Pext + kPext))*V1 - rP*V1*Z - rPP*V1*(P1/(kPP + P1));

% Species 2:
%dydt(1) = a*(C2/(C2 + k))*H2 - rN*V2 - rNN*(V2+H2)*(N2/(kNN + N2));                                  % N2
%dydt(2) = V2*(rd*pv*Z2 -p3*(V2+H2));                                                                 % V2
%dydt(3) = -p3*(H2 + V2)*H2 + rd*ph*V2*Z2;                                                            % H2
%dydt(4) = ZL2*rp - rC*V2*Z2 - a*H2*C2/(C2 + k) - rCC*(H2+V2)*(C2/(kCC + C2));                        % C2
%dydt(5) = 2*b*(Pext/(Pext + kPext))*V2 - rP*V2*Z2 - rPP*(H2+V2)*(P2/(kPP + P2));
%dydt(6) = 0.008 - 2*b*(Pext/(Pext + kPext))*V2; %-2*b*(Pext/(Pext + kPext))*V2;

% Species 3:
dydt(1) = nu*(Next/(Next + kNext))*V3 - rN*V3*Z3 - rNN*(V3)*(N3/(kNN + N3));                                  % N2
dydt(2) = V3*(rd*pv*Z3 -p3*(V3));                                                                 % V2                                                % H2
dydt(3) = ZL3*rp - rC*V3*Z3 - rCC*(V3)*(C3/(kCC + C3));                                           % C3
dydt(4) = 2*p*(Pext/(Pext + kPext))*V3 - rP*V3*Z3 - rPP*(V3)*(P3/(kPP + P3));
dydt(5) = 0.008 - 2*p*(Pext/(Pext + kPext))*V3;
dydt(6) = 0.4 - nu*(Next/(Next + kNext))*V3;

end

