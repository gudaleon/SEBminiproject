function [dydt] = grow(t,y,A)
%This simulates the growth of a group of cells from one cell division until
%the next.

%Parameter Defintions
         nvp = cyanobacterium.nvp;                      % Number of variables we are modelling
       extfN = cyanobacterium.ExtracellularfN;          % Amount of extracellular fixed nitrogen
        extP = cyanobacterium.ExtracellularP;
       extfC = cyanobacterium.ExtracellularfC;
           n = cyanobacterium.fNrequirement;            % Amount of fixed nitrogen required for growth per unit length
           c = cyanobacterium.fCrequirement;
           p = cyanobacterium.Prequirement;
           R = cyanobacterium.GrowthRate;               % Baseline growth rate of the cyanobacterium
          fs = cyanobacterium.fNStorageRate;            % Constant of conversion from fN to stored N.
         DfN = cyanobacterium.InterCellfNDiff;          % Diffusion coefficient of nitrogen between cells
         DP = cyanobacterium.InterCellPDiff;
         DfC = cyanobacterium.InterCellfCDiff;
        area = cyanobacterium.Area;                     % Relates exposed SA of a single cell to a cell in the mix
    D_leakfN = cyanobacterium.fNleak;                   % Diffusion from within cells to the extracellular environment
    D_leakP = cyanobacterium.Pleak;
    D_leakfC = cyanobacterium.fCleak;
     D_impfN = cyanobacterium.fNimport;                 % Diffusion from outside the cells to within the cells
      D_impP = cyanobacterium.Pimport;                  % 
     D_impfC = cyanobacterium.fCimport;                 % 
         DpR = cyanobacterium.InterCellProteinDiff;     % HetN and PatS Diffusion coefficient between cells
      PrLoss = cyanobacterium.ProteinLoss;              % Loss of HetN due to leakage and degradation
    PatSProd = 0;
    HetNProd = cyanobacterium.HetNprdctnRate;
    Consump = 0.7;                                      % Constant for rate of carbon consumption
 

% Pre-defining a vector of zeros for dydt
dydt = zeros(nvp*length(A),1);

for i = 1:length(A)
    %Specifying the different indices:
    isN = (i-1)*nvp + 1;                    % Stored nitrogen of cell 'i'
    isC = (i-1)*nvp + 2;
    ihR = (i-1)*nvp + 3;
    ipS = (i-1)*nvp + 4;
    ihN = (i-1)*nvp + 5;
    ifN = (i-1)*nvp + 6;                    % Fixed nitrogen in cell 'i'
     iP = (i-1)*nvp + 7;
    ifC = (i-1)*nvp + 8;
     iL = (i-1)*nvp + 9;                    % Length of cell 'i'
   
  %iLsN = (i-2)*nvp + 1;                    % Stored nitrogen of cell 'i-1'
  %iLsc = (i-2)*nvp + 2;
  %iLhR = (i-2)*nvp + 3;
   iLpS = (i-2)*nvp + 4;
   iLhN = (i-2)*nvp + 5;
   iLfN = (i-2)*nvp + 6;                    % Fixed nitrogen of cell 'i-1'
    iLP = (i-2)*nvp + 7;
   iLfC = (i-2)*nvp + 8;
    iLL = (i-2)*nvp + 9;                    % Length of cell 'i-1'
   
  %iRsN = i*nvp + 1;                        % Stored nitrogen of cell 'i+1'
  %iRsc = i*nvp + 2;
  %iRhR = i*nvp + 3;
   iRpS = i*nvp + 4;
   iRhN = i*nvp + 5;
   iRfN = i*nvp + 6;                        % Fixed nitrogen of cell 'i+1'
    iRP = i*nvp + 7;
   iRfC = i*nvp + 8;
    iRL = i*nvp + 9;                        % Length of cell 'i+1'
    
% Kinetic Parameters
  fNsN = fs*y(ifN) - y(isN);                                      % Liberation/storage of nitrogen: Mass Action 
  fCsC = fs*y(ifC) - y(isC);                % 
 KmipS = 0.3;
   kfC = 1;                                                       % Amount of fixed carbon for half maximal growth
   kfN = 0.3;                                                     %
    kP = 0.1;
   kpS = 1;
   ksN = 0.03;
   khR = 10;
%Differences Between heterocysts and non-heterocysts:

Veg = 1-A(i).DifferentiationFinished;  % A value of '1' for all vegetative cells

GR = (A(i).GrowthPara*(R*y(ifC)/(kfC + y(ifC)))*(R*y(ifN)/(kfN + y(ifN)))*(R*y(iP)/(kP + y(iP))))*Veg;
Cconsump = A(i).DifferentiationFinished*y(ifC)*Consump/(kfC + y(ifC));
Nprod = 0.3*Cconsump;

% Cell positions: (for speed, the order could be changed here, so that it
% will come across the most common scenario (in the mix) first. It may also
% be worth considering whether to swap the nesting of the 'if' clauses.
   %Lone cell
        if i > 1 && i < length(A);
            % Nitrogen
             fN_in = DfN*y(iRfN)/y(iRL) + DfN*y(iLfN)/y(iLL)+ D_impfN*y(iL)*extfN;
            fN_out = - 2*DfN*y(ifN)/y(iL) - D_leakfN*y(ifN);
            %Phosphate
              P_in = DP*y(iRP)/y(iRL) + DP*y(iLP)/y(iLL)+ D_impP*y(iL)*extP;
             P_out = - 2*DP*y(iP)/y(iL) - D_leakP*y(iP);
             % Carbon
             fC_in = DfC*y(iRfC)/y(iRL) + DfN*y(iLfC)/y(iLL)+ D_impfC*y(iL)*extfC;
            fC_out = - 2*DfC*y(ifC)/y(iL) - D_leakfC*y(ifC);
            % Proteins
           PatS_in = DpR*y(iLpS)/y(iLL) + DpR*y(iRpS)/y(iRL);
           HetN_in = DpR*y(iLhN)/y(iLL) + DpR*y(iRhN)/y(iRL);
          PatS_out = - PrLoss*y(ipS) - 2*DpR*y(ipS)/y(iL);
          HetN_out = - PrLoss*y(ihN) - 2*DpR*y(ihN)/y(iL);
          
        elseif length(A) == 1  
            % Nitrogen
             fN_in = D_impfN*y(iL)*extfN;
            fN_out = - 2*area*D_leakfN*y(ifN)/y(iL) - D_leakfN*y(ifN);
            % Phosphate
              P_in = D_impP*y(iL)*extP;
             P_out = - 2*area*D_leakP*y(iP)/y(iL) - D_leakP*y(iP);
            % Carbon
             fC_in = D_impfC*y(iL)*extfC;
            fC_out = - 2*area*D_leakfC*y(ifC)/y(iL) - D_leakfC*y(ifC);
            % Proteins
           PatS_in = 0;
           HetN_in = 0;
          PatS_out = - PrLoss*y(ipS);
          HetN_out = - PrLoss*y(ihN);
          
        elseif i == 1 && length(A) > 1
            % Nitrogen
             fN_in = DfN*y(iRfN)/y(iRL) + D_impfN*y(iL)*extfN;
            fN_out = - DfN*y(ifN)/y(iL) - D_leakfN*y(ifN) - area*D_leakfN*y(ifN)/y(iL);
            % Phosphate
              P_in = DP*y(iRP)/y(iRL) + D_impP*y(iL)*extP;
             P_out = - DP*y(iP)/y(iL) - D_leakP*y(iP) - area*D_leakP*y(iP)/y(iL);
            % Carbon
             fC_in = DfC*y(iRfC)/y(iRL) + D_impfC*y(iL)*extfC;
            fC_out = - DfC*y(ifC)/y(iL) - D_leakfC*y(ifC) - area*D_leakfC*y(ifC)/y(iL);
            % Proteins
           PatS_in = DpR*y(iRpS)/y(iRL);
           HetN_in = DpR*y(iRhN)/y(iRL);
          PatS_out = - PrLoss*y(ipS) - DpR*y(ipS)/y(iL);
          HetN_out = - PrLoss*y(ihN) - DpR*y(ihN)/y(iL);
          
        elseif i == length(A) && length(A) > 1
            % Nitrogen
             fN_in = DfN*y(iLfN)/y(iLL)+ D_impfN*y(iL)*extfN;
            fN_out = - DfN*y(ifN)/y(iL) - D_leakfN*y(ifN) - area*D_leakfN*y(ifN)/y(iL);
            % Phosphate
              P_in = DP*y(iLP)/y(iLL)+ D_impP*y(iL)*extP;
             P_out = - DP*y(iP)/y(iL) - D_leakP*y(iP) - area*D_leakP*y(iP)/y(iL);
            % Carbon
             fC_in = DfC*y(iLfC)/y(iLL)+ D_impfC*y(iL)*extfC;
            fC_out = - DfC*y(ifC)/y(iL) - D_leakfC*y(ifC) - area*D_leakfC*y(ifC)/y(iL);
            % Proteins
           PatS_in = DpR*y(iLpS)/y(iLL);
           HetN_in = DpR*y(iLhN)/y(iLL);
          PatS_out = - 5*PrLoss*y(ipS)- DpR*y(ipS)/y(iL);
          HetN_out = - PrLoss*y(ihN)- DpR*y(ihN)/y(iL);
        
        end
    HetR_out = y(ihR)*PrLoss*0.2;
    if y(isN) < 0.05
        dhR = 50*(0.05 - y(isN))/(0.7 + (0.05 - y(isN))) ;
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
        
    dydt(isN) = fNsN;
    dydt(isC) = fCsC;
    dydt(ihR) = Veg*dhR - HetR_out;
    dydt(ipS) = PatS_in + PatS_out + y(ihR)*PatSProd;
    dydt(ihN) = 5*HetN_in + 5*HetN_out + (1-Veg)*(HetNProd)*y(ihR)/(0.1 + y(ihN));
    dydt(ifN) = fN_in + fN_out - n*GR - fNsN + Nprod;                      
     dydt(iP) = P_in + P_out - p*GR; 
    dydt(ifC) = fC_in + fC_out - c*GR - Cconsump;
     dydt(iL) = GR;                                                          
end
end



