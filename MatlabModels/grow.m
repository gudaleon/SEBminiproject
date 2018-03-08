
function [dydt] = grow(t,y,A)
%This simulates the growth of a group of cells from one cell division or differentiation until
%the next.

% Parameter Defintions
         nvp = cyanobacterium.nvp;                      % Number of variables we are modelling

% World parameters
       extfN = cyanobacterium.ExtracellularfN;          % Amount of extracellular fixed nitrogen
        extP = cyanobacterium.ExtracellularP;
       extfC = cyanobacterium.ExtracellularfC;
          LI = 1;
       
% Cell intrinsic parameters
           n = cyanobacterium.fNrequirement;            % Amount of fixed nitrogen required for growth per unit length
           c = cyanobacterium.fCrequirement;
           p = cyanobacterium.Prequirement;
           R = cyanobacterium.GrowthRate;               % Baseline growth rate of the cyanobacterium
          fs = cyanobacterium.fNStorageRate;            % Constant of conversion from fN to stored N.
        fCfN = 0.3;                                     % The carbon cost for nitrogen fixation
       kfCfN = 10;                                      % Concentration of carbon for half maximum nitrogen fixation
        OxPH = 950;                                     % Constant for oxygen production by photosynthesis
        OxRE = 20;                                      % Constant for oxygen consumption by respiration
        CaPH = 250;
        CaRE = 5;
        
% Kinetic parameters
   kfC = 1;                                             % Conc. of fixed carbon for half maximal growth
   kfN = 0.3;                                           % Conc. of fixed nitrogen for half maximal growth                                                
    kP = 0.1;                                           % Conc. of phosphate for half maximal growth
    rR = 5.3;
   kRC = 0.03;
  kROx = 0.07;
    rP = 0.3;
    
% Diffusion parameters
        
    D_leakfN = cyanobacterium.fNleak;                   % Diffusion from within cells to the extracellular environment
    D_leakP = cyanobacterium.Pleak;
    D_leakfC = cyanobacterium.fCleak;
     D_impfN = cyanobacterium.fNimport;                 % Diffusion from outside the cells to within the cells
      D_impP = cyanobacterium.Pimport;                   
     D_impfC = cyanobacterium.fCimport;                 
     
     % Of which Anabaena specific:
         DfN = cyanobacterium.InterCellfNDiff;          % Diffusion coefficient of nitrogen between cells
          DP = cyanobacterium.InterCellPDiff;
         DfC = cyanobacterium.InterCellfCDiff;
         DOx = cyanobacterium.InterCellOxDiff;
        area = cyanobacterium.Area;                     % Relates exposed SA of a single cell to a cell in the mix
         DpR = cyanobacterium.InterCellProteinDiff;     % HetN and PatS Diffusion coefficient between cells
      PrLoss = cyanobacterium.ProteinLoss;              % Loss of HetN due to leakage and degradation
    PatSProd = 0;
    HetNProd = cyanobacterium.HetNprdctnRate;
   HetOxDiff = 0.3;                                     % Oxygen diffusion in and out of heterocysts is 'HetOxDiff' of the amount between vegetative cells.
 

% Pre-defining a vector of zeros for dydt
dydt = zeros(nvp*length(A)+1,1);
iLux = nvp*length(A) + 1;

for i = 1:length(A)
    %Specifying the different indices:
    isN = (i-1)*nvp + 1;                    % Stored nitrogen of cell 'i'
    isC = (i-1)*nvp + 2;                    % Stored carbon of cell 'i'
    ihR = (i-1)*nvp + 3;
    ipS = (i-1)*nvp + 4;
    ihN = (i-1)*nvp + 5;
    iOx = (i-1)*nvp + 6;                    % Free oxygen of cell 'i'
    ifN = (i-1)*nvp + 7;                    % Fixed nitrogen in cell 'i'
     iP = (i-1)*nvp + 8;                    % Phosphate of cell 'i'
    ifC = (i-1)*nvp + 9;
     iL = (i-1)*nvp + 10;                   % Length of cell 'i'
   
  %iLsN = (i-2)*nvp + 1;                    % Stored nitrogen of cell 'i-1'
  %iLsc = (i-2)*nvp + 2;
  %iLhR = (i-2)*nvp + 3;
   iLpS = (i-2)*nvp + 4;
   iLhN = (i-2)*nvp + 5;
   iLfN = (i-2)*nvp + 6;                    % Fixed nitrogen of cell 'i-1'
   iLOx = (i-2)*nvp + 7;
    iLP = (i-2)*nvp + 8;
   iLfC = (i-2)*nvp + 9;
    iLL = (i-2)*nvp + 10;                    % Length of cell 'i-1'
   
  %iRsN = i*nvp + 1;                        % Stored nitrogen of cell 'i+1'
  %iRsc = i*nvp + 2;
  %iRhR = i*nvp + 3;
   iRpS = i*nvp + 4;
   iRhN = i*nvp + 5;
   iRfN = i*nvp + 6;                        % Fixed nitrogen of cell 'i+1'
   iROx = i*nvp + 7;
    iRP = i*nvp + 8;
   iRfC = i*nvp + 9;
    iRL = i*nvp + 10;                        % Length of cell 'i+1'
    
% Concentrations
cfC = y(ifC)/y(iL);                        
csC = y(isC)/y(iL); 
cfN = y(ifN)/y(iL);
csN = y(isN)/y(iL);
 cP = y(iP)/y(iL);
cOx = y(iOx)/y(iL);

% Storage and mobilisation

    fNsN = fs*cfN - csN;                                              % Liberation/storage of nitrogen: Mass Action 
    fCsC = (fs+0.7)*cfC - csC;                                       


%Differences Between heterocysts and non-heterocysts:

Veg = 1-A(i).DifferentiationFinished;  % A value of '1' for all vegetative cells
GR = (A(i).GrowthPara*(R*cfC/(kfC + cfC))*(R*cfN/(kfN + cfN))*(R*cP/(kP + cP)))*Veg;


   % Cell in the filament
        if i > 1 && i < length(A);
                    cLfC = y(iLfC)/y(iLL);                     % The 3 represents a 'fudge factor'
                    %cLsC = y(iLsC)/y(iLL); 
                    cLfN = y(iLfN)/y(iLL);
                    %cLsN = y(iLsN)/y(iLL);
                     cLP = (iLP)/y(iLL);
                    cLOx = (iLOx)/y(iLL);

                    cRfC = y(iRfC)/y(iRL);                     % The 3 represents a 'fudge factor'
                    %cRsC = y(iRsC)/y(iRL); 
                    cRfN = y(iRfN)/y(iRL);
                    %cRsN = y(iRsN)/y(iRL);
                     cRP = y(iRP)/y(iRL);
                    cROx = y(iROx)/y(iRL);

% Different diffusion for different cell positions
            % Nitrogen
             fN_in = DfN*cRfN + DfN*cLfN+ D_impfN*y(iL)*extfN;
            fN_out = - 2*DfN*cfN - D_leakfN*y(ifN);
            %Phosphate
              P_in = DP*cRP + DP*cLP+ D_impP*y(iL)*extP;
             P_out = - 2*DP*cP - D_leakP*y(iP);
             % Carbon
             fC_in = DfC*cRfC + DfC*cLfC+ D_impfC*y(iL)*extfC;
            fC_out = - 2*DfC*cfC - D_leakfC*y(ifC);
            % Oxygen
             Ox_in = DOx*cROx + DOx*cLOx;
            Ox_out = - 2*DOx*cOx;
            % Proteins
           PatS_in = DpR*y(iLpS)/y(iLL) + DpR*y(iRpS)/y(iRL);
           HetN_in = DpR*y(iLhN)/y(iLL) + DpR*y(iRhN)/y(iRL);
          PatS_out = - PrLoss*y(ipS) - 2*DpR*y(ipS)/y(iL);
          HetN_out = - PrLoss*y(ihN) - 2*DpR*y(ihN)/y(iL);
      
    %Lone cell
        elseif length(A) == 1  
            % Nitrogen
             fN_in = D_impfN*y(iL)*extfN;
            fN_out = - 2*area*D_leakfN*cfN - D_leakfN*y(ifN);
            % Phosphate
              P_in = D_impP*y(iL)*extP;
             P_out = - 2*area*D_leakP*cP - D_leakP*y(iP); %The loss through leak is proportional to concentration * length = amount
            % Carbon
             fC_in = D_impfC*y(iL)*extfC;
            fC_out = - 2*area*D_leakfC*cfC - D_leakfC*y(ifC);
            % Oxygen
            Ox_in = 0;
            Ox_out = 0;
            % Proteins
           PatS_in = 0;
           HetN_in = 0;
          PatS_out = - PrLoss*y(ipS);
          HetN_out = - PrLoss*y(ihN);
          
    % Cell on LH end      
        elseif i == 1 && length(A) > 1
            
                    cRfC = y(iRfC)/y(iRL);                     % The 3 represents a 'fudge factor'
                    %cRsC = 3*y(iRsC)/y(iRL); 
                    cRfN = y(iRfN)/y(iRL);
                    %cRsN = 3*y(iRsN)/y(iRL);
                     cRP = y(iRP)/y(iRL);
                    cROx = y(iROx)/y(iRL);
            % Nitrogen
             fN_in = DfN*cRfN + D_impfN*y(iL)*extfN;
            fN_out = - DfN*cfN - D_leakfN*y(ifN) - area*D_leakfN*cfN;
            % Phosphate
              P_in = DP*cRP + D_impP*y(iL)*extP;
             P_out = - DP*cP - D_leakP*y(iP) - area*D_leakP*cP;
            % Carbon
             fC_in = DfC*cRfC + D_impfC*y(iL)*extfC;
            fC_out = - DfC*cfC - D_leakfC*y(ifC) - area*D_leakfC*cfC;
            % Oxygen
              Ox_in = DOx*cROx;
            Ox_out = - DOx*cOx;
            % Proteins
           PatS_in = DpR*y(iRpS)/y(iRL);
           HetN_in = DpR*y(iRhN)/y(iRL);
          PatS_out = - PrLoss*y(ipS) - DpR*y(ipS)/y(iL);
          HetN_out = - PrLoss*y(ihN) - DpR*y(ihN)/y(iL);
          
      % Cell on RH end    
        elseif i == length(A) && length(A) > 1
                    cLfC = y(iLfC)/y(iLL);                     % The 3 represents a 'fudge factor'
                    %cLsC = 3*y(iLsC)/y(iLL); 
                    cLfN = y(iLfN)/y(iLL);
                    %cLsN = 3*y(iLsN)/y(iLL);
                     cLP = y(iLP)/y(iLL);
                    cLOx = y(iLOx)/y(iLL);
            % Nitrogen
             fN_in = DfN*cLfN+ D_impfN*y(iL)*extfN;
            fN_out = - DfN*cfN - D_leakfN*y(ifN) - area*D_leakfN*cfN;
            % Phosphate
              P_in = DP*cLP+ D_impP*y(iL)*extP;
             P_out = - DP*cP - D_leakP*y(iP) - area*D_leakP*cP;
            % Carbon
             fC_in = DfC*cLfC+ D_impfC*y(iL)*extfC;
            fC_out = - DfC*cfC - D_leakfC*y(ifC) - area*D_leakfC*cfC;
            % Oxygen
             Ox_in = DOx*cLOx;
            Ox_out = -DOx*cOx;
            % Proteins
           PatS_in = DpR*y(iLpS)/y(iLL);
           HetN_in = DpR*y(iLhN)/y(iLL);
          PatS_out = - 5*PrLoss*y(ipS)- DpR*y(ipS)/y(iL);
          HetN_out = - 5*PrLoss*y(ihN)- DpR*y(ihN)/y(iL);
        end
        
    HetR_out = y(ihR)*PrLoss*0.2; % Altering the rate of hetR degradation is the simplest way to change heterocyst spacing.
    
    if y(isN) < 0.35
        dhR = 10*(0.35 - y(isN))/(0.7 + (0.35 - y(isN))) ;
    else
        dhR = 0;
    end
    
    if y(ihR) > 0.5;
        PatSProd = 0.5;
    end
    
    if y(ipS) > 0.2;
        dhR = 0;
    end
    
    if y(ihN) > 0.2
        dhR = 0;
    end
   
% Key cellular processes
photosynth = y(iLux)^2*rP/(kP + y(iLux)^2);
respir = (cfC*rR/(kRC + cfC))*(cOx*rR/(kROx + cOx));
N_fix = (fCfN)/(kfCfN + (10*y(iOx))^6);
   
    dydt(isN) = fNsN;
    dydt(isC) = fCsC;
    dydt(ihR) = Veg*dhR - HetR_out;
    dydt(ipS) = PatS_in + PatS_out + y(ihR)*PatSProd;
    dydt(ihN) = 30*(HetN_in + HetN_out) + (1-Veg)*(HetNProd)*y(ihR)/(0.1 + y(ihN)); % The 5 represents how much faster hetN diffuses compared to patS. 
    dydt(iOx) = Veg*(Ox_in + Ox_out + OxPH*photosynth - OxRE*respir) + (1-Veg)*(HetOxDiff*(Ox_in + Ox_out) - OxRE*respir);
    dydt(ifN) = fN_in + fN_out - n*GR - fNsN + (1-Veg)*N_fix;                      
     dydt(iP) = P_in + P_out - p*GR; 
    dydt(ifC) = fC_in + fC_out - c*GR + Veg*(CaPH*photosynth - CaRE*respir) + (1-Veg)*(-CaRE*respir) - fCsC;
     dydt(iL) = GR;                                                          
end
dydt(iLux) = LI*sin(t/3);
end



