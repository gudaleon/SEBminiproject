function [dydt] = temporalgrow(t, y, A)
%%This simulates the growth of a group of cells from one cell division until
%the next.

% Parameter Defintions
         nvp = temporalcyanobacterium.nvp;                      % Number of variables we are modelling
         
% World parameters
       extfN = temporalcyanobacterium.ExtracellularfN;          % Amount of extracellular fixed nitrogen
        extP = temporalcyanobacterium.ExtracellularP;           % Amount of extracellular fixed phosphate
       extfC = temporalcyanobacterium.ExtracellularfC;          % Amount of extracellular fixed carbon
          LI = 1;                                               % Light intensity
       
% Cell intrinsic parameters
           n = temporalcyanobacterium.fNrequirement;            % Amount of fixed nitrogen used for growth per unit volume per unit time
           c = temporalcyanobacterium.fCrequirement;            % Amount of fixed carbon used for growth per unit volume per unit time
           p = temporalcyanobacterium.Prequirement;             % Amount of fixed phosphate used for growth per unit volume per unit time
           R = temporalcyanobacterium.GrowthRate;               % Baseline growth rate of the cyanobacterium
          fs = temporalcyanobacterium.fNStorageRate;            % Constant of conversion from fN to stored N.
        fCfN = 0.3;                                             % Maximal rate of nitrogen fixation
       kfCfN = 10;                                              % 
        OxPH = 950;                                             % Constant for oxygen production by photosynthesis
        OxRE = 20;                                              % Constant for oxygen consumption by respiration
        CaPH = 250;
        CaRE = 5;
          
    %Kinetic parameters
               kfC = 1;                                        % Conc. of fixed carbon for half maximal growth
               kfN = 0.3;                                       % Conc. of fixed nitrogen for half maximal growth               
                kP = 0.1;                                       % Conc. of fixed phosphate for half maximal growth
                rR = 5.3;                                       % Maximum rate of respiration
               kRC = 0.03;                                      % Carbon concentration at which respiration would run at half maximal rate
              kROx = 0.07;                                      % Oxygen concentration at which respiration would run at half maximal rate
                rP = 0.3;                                       % Maximum rate of Photosynthesis

% Diffusion parameters
    D_leakfN = temporalcyanobacterium.fNleak;                   % Diffusion of fixed nitrogen from within cells to the extracellular environment
     D_leakP = temporalcyanobacterium.Pleak;                    % Diffusion of phosphate from within cells to the extracellular environment
    D_leakfC = temporalcyanobacterium.fCleak;                   % Diffusion of fixed carbon from within cells to the extracellular environment
     D_impfN = temporalcyanobacterium.fNimport;                 % Diffusion of fixed nitrogen from outside the cells to within the cells
      D_impP = temporalcyanobacterium.Pimport;                  % Diffusion of phosphate from outside the cells to within the cells
     D_impfC = temporalcyanobacterium.fCimport;                 % Diffusion of fixed carbon from outside the cells to within the cells  

% Pre-defining a vector of zeros for dydt
dydt = zeros((nvp*length(A))+1,1);
iLux = nvp*length(A) + 1;


for i = 1:length(A)
    %Specifying the different indices:
    isN = (i-1)*nvp + 1;                    % Stored nitrogen of cell 'i'
    isC = (i-1)*nvp + 2;                    % Stored carbon of cell 'i'
    iOx = (i-1)*nvp + 3;                    % Free oxygen of cell 'i'
    ifN = (i-1)*nvp + 4;                    % Fixed nitrogen in cell 'i'
     iP = (i-1)*nvp + 5;                    % Phosphate of cell 'i'
    ifC = (i-1)*nvp + 6;                    % Fixed carbon of cell 'i'
     iV = (i-1)*nvp + 7;                    % Volume of cell 'i'
   
     
    %Concentrations:
    cfC = y(ifC)/y(iV);
    csC = y(isC)/y(iV); 
    cfN = y(ifN)/y(iV);
    csN = y(isN)/y(iV);
    cP = y(iP)/y(iV);
    cOx = y(iOx)/y(iV);

    % Storage and mobilisation
    fNsN = fs*cfN - csN;                                              % Liberation/storage of nitrogen: Mass Action 
    fCsC = (fs+0.7)*cfC - csC;                                       

    GR = A(i).GrowthPara*(R*cfC/(kfC + cfC))*(R*cfN/(kfN + cfN))*(R*cP/(kP + cP));     
    Ar = (9/16)*(pi^5/3)*(y(iV))^2/3;

% Nitrogen
             fN_in = Ar*D_impfN*extfN;
            fN_out = -Ar*D_leakfN*cfN;
% Phosphate
              P_in = Ar*D_impP*extP;
             P_out = -Ar*D_leakP*cP;
% Carbon
             fC_in = Ar*D_impfC*extfC;
            fC_out = -Ar*D_leakfC*cfC;
            
% Key cellular processes
photosynth = y(iLux)^2*rP/(kP + y(iLux)^2);
respir = (cfC*rR/(kRC + cfC))*(cOx*rR/(kROx + cOx));
N_fix = (fCfN)/(kfCfN + (10*y(iOx))^6);

% Rates of change
      
    dydt(isN) = fNsN;
    dydt(isC) = fCsC;
    dydt(iOx) = OxPH*photosynth - OxRE*respir;
    dydt(ifN) = fN_in + fN_out + N_fix - n*GR - fNsN;                 
     dydt(iP) = P_in + P_out - p*GR; 
    dydt(ifC) = fC_in + fC_out + CaPH*photosynth - CaRE*respir - c*GR - fCsC;
     dydt(iV) = GR;  
        
end
dydt(iLux) = LI*sin(t/3);
end

