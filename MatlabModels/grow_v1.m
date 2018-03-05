function [dydt] = grow(t,y,A)
%This simulates the growth of a group of cells from one cell division until
%the next.

%Parameter Defintions
   nvp = cyanobacterium.nvp;                % Number of variables we are modelling
 extfN = cyanobacterium.ExtracellularfN;    % Amount of extracellular fixed nitrogen
     g = cyanobacterium.fNrequirement;      % Amount of fixed nitrogen required for growth per unit length
     R = cyanobacterium.GrowthRate;         % Baseline growth rate of the cyanobacterium
    fg = cyanobacterium.NDeprivedGRfraction;% Proportion of the maximal growth rate when running off stored nitrogen
    fs = cyanobacterium.fNStorageRate;      % Constant of conversion from fN to stored N.
  fsLr = cyanobacterium.fsLiberationRate;   % Rate constant for liberation of nitrogen reserves
     D = cyanobacterium.InterCellfNDiff;    % Diffusion coefficient between cells
  area = cyanobacterium.Area;               % Relates exposed SA of a single cell to a cell in the mix
D_leak = cyanobacterium.fNleak;             % Diffusion from within cells to the extracellular environment
D_imp  = cyanobacterium.fNimport;           % Diffusion from outside the cells to within the cells
   DpR = cyanobacterium.InterCellProteinDiff;   % HetN and PatS Diffusion coefficient between cells
PrLoss = cyanobacterium.ProteinLoss;            % Loss of HetN due to leakage and degradation
   ihb = cyanobacterium.InhibitionConst;
   hetfNprod = cyanobacterium.hetNprdctnRate; % The rate of production of fixed nitrogen by heterocysts
   HetNProd = cyanobacterium.hetNprdctnRate;
   PatSProd = cyanobacterium.PatSprdctnRate;
 

% Pre-defining a vector of zeros for dydt
dydt = zeros(nvp*length(A),1);

for i = 1:length(A)
    %Specifying the different indices:
    isN = (i-1)*nvp + 1;                    % Stored nitrogen of cell 'i'
     iC = (i-1)*nvp + 2;
    ipS = (i-1)*nvp + 3;
    ihN = (i-1)*nvp + 4;
    ifN = (i-1)*nvp + 5;                    % Fixed nitrogen in cell 'i'
     iL = (i-1)*nvp + 6;                    % Length of cell 'i'
   
  %iLsN = (i-2)*nvp + 1;                    % Stored nitrogen of cell 'i-1'
   %iLC = (i-2)*nvp + 2;
   iLpS = (i-2)*nvp + 3;
   iLhN = (i-2)*nvp + 4;
   iLfN = (i-2)*nvp + 5;                    % Fixed nitrogen of cell 'i-1'
    iLL = (i-2)*nvp + 5;                    % Length of cell 'i-1'
   
  %iRsN = i*nvp + 1;                        % Stored nitrogen of cell 'i+1'
   %iRC = i*nvp + 2;
   iRpS = i*nvp + 3;
   iRhN = i*nvp + 4;
   iRfN = i*nvp + 5;                        % Fixed nitrogen of cell 'i+1'
    iRL = i*nvp + 6;                        % Length of cell 'i+1'
    
%FixedVariables...
fNsN = fs*y(ifN) - y(isN); % Note that these are absolute amounts, not concentrations - the amount going into storage does not depend on length.   
fNProd = A(i).DifferentiationFinished*hetfNprod;
HetNProdn = A(i).DifferentiationFinished*HetNProd;
% Cell positions: (for speed, the order could be changed here, so that it
% will come across the most common scenario (in the mix) first. It may also
% be worth considering whether to swap the nesting of the 'if' clauses.
   %Lone cell
        if length(A) == 1  
            fN_in = D_imp*y(iL)*extfN;
            fN_out = - 2*area*D_leak*y(ifN)/y(iL) - D_leak*y(ifN);
            PatS_in = 0;
            HetN_in = 0;
            PatS_out = - PrLoss*y(ipS);
            HetN_out = - PrLoss*y(ihN);
        elseif i == 1 && length(A) > 1
            fN_in = D*y(iRfN)/y(iRL) + D_imp*y(iL)*extfN;
            fN_out = - D*y(ifN)/iL - D_leak*y(ifN) - area*D_leak*y(ifN)/y(iL);
            PatS_in = DpR*y(iRpS)/y(iRL);
            HetN_in = DpR*y(iRhN)/y(iRL);
            PatS_out = - PrLoss*y(ipS) - DpR*y(ipS)/y(iL);
            HetN_out = - PrLoss*y(ihN) - DpR*y(ihN)/y(iL);
        elseif i == length(A) && length(A) > 1
            fN_in = D*y(iLfN)/y(iLL)+ D_imp*y(iL)*extfN;
            fN_out = - D*y(ifN)/iL - D_leak*y(ifN) - area*D_leak*y(ifN)/y(iL);
            PatS_in = DpR*y(iLpS)/y(iLL);
            HetN_in = DpR*y(iLhN)/y(iLL);
            PatS_out = - PrLoss*y(ipS)- DpR*y(ipS)/y(iL);
            HetN_out = - PrLoss*y(ihN)- DpR*y(ihN)/y(iL);
        else
            fN_in = D*y(iRfN)/y(iRL) + D*y(iLfN)/y(iLL)+ D_imp*y(iL)*extfN;
            fN_out = - 2*D*y(ifN)/iL - D_leak*y(ifN);
            PatS_in = DpR*y(iLpS)/y(iLL) + DpR*y(iRpS)/y(iRL);
            HetN_in = DpR*y(iLhN)/y(iLL) + DpR*y(iRhN)/y(iRL);
            PatS_out = - PrLoss*y(ipS) - 2*DpR*y(ipS)/y(iL);
            HetN_out = - PrLoss*y(ihN) - 2*DpR*y(ihN)/y(iL);
        end
            if A(i).DifferentiationFinished == 0;  % You should be able to get rid of this if loop with some better equations for each thing (especially nitrogen storage/liberation)!
                if y(ifN) > g
                    dydt(isN) = fNsN;
                    dydt(iC) = - ihb*(y(ipS) + y(ihN))*y(iC);
                    dydt(ipS) = PatS_in + PatS_out + y(iC)*PatSProd;
                    dydt(ihN) = HetN_in + HetN_out + HetNProdn;
                    dydt(ifN) = fN_in + fN_out - g*R - fNsN + fNProd;                           %fixed nitrogen
                    dydt(iL) = R;                                                       %length
                elseif y(ifN) <= g && y(isN) > g
                    dydt(isN) = - fsLr*y(isN);  
                    dydt(iC) = - ihb*(y(ipS) + y(ihN))*y(iC);
                    dydt(ifN) = fN_in + fN_out - g*min(fg*R*y(ifN), R) + fsLr*y(isN) + fNProd;  
                    dydt(ipS) = PatS_in + PatS_out + y(iC)*PatSProd;
                    dydt(ihN) = HetN_in + HetN_out + HetNProdn;
                    dydt(iL) = min(fg*R*y(ifN)/y(iL), R);                               % Under low nitrogen, growth rate depends on concentration of fixed nitrogen
                elseif y(ifN) <=g && y(isN) <= g
                    dydt(ifN) = fN_in + fN_out - g*min(fg*R*y(ifN), R) + fsLr*y(isN) + fNProd;  
                    dydt(isN) = - fsLr*y(isN);
                    dydt(iL) = min(fg*R*y(ifN)/y(iL), R);                               % Under low nitrogen, growth rate depends on concentration of fixed nitrogen
                    dydt(ipS) = PatS_in + PatS_out + y(iC)*PatSProd;
                    dydt(ihN) = HetN_in + HetN_out + HetNProdn;
                    if length(A) == 1 || i == 1 && length(A) > 1 && y(ipS) >= y(iRpS) || i == length(A) && length(A) > 1 && y(ipS) >= y(iLpS) || y(ipS) >= y(iRpS) && y(ipS) >= y(iLpS);
                        dydt(iC) = (101 - y(iC))/101;
                    else
                        dydt(iC) = (101 - ihb*(y(ipS) + y(ihN))*y(iC))/101;
                    end
                end
            elseif A(i).DifferentiationFinished == 1;
                if y(ifN) > g
                    dydt(isN) = fNsN;
                    dydt(iC) = - ihb*(y(ipS) + y(ihN))*y(iC);
                    dydt(ipS) = PatS_in + PatS_out + y(iC)*PatSProd;
                    dydt(ihN) = HetN_in + HetN_out + HetNProdn;
                    dydt(ifN) = fN_in + fN_out - g*R - fNsN + fNProd;                           %fixed nitrogen
                    dydt(iL) = 0;                                                       %length
                elseif y(ifN) <= g && y(isN) > g
                    dydt(isN) = - fsLr*y(isN);  
                    dydt(iC) = - ihb*(y(ipS) + y(ihN))*y(iC);
                    dydt(ifN) = fN_in + fN_out - g*min(fg*R*y(ifN), R) + fsLr*y(isN) + fNProd;  
                    dydt(ipS) = PatS_in + PatS_out + y(iC)*PatSProd;
                    dydt(ihN) = HetN_in + HetN_out + HetNProdn;
                    dydt(iL) = 0;                          % Under low nitrogen, growth rate depends on concentration of fixed nitrogen
                elseif y(ifN) <=g && y(isN) <= g
                    dydt(ifN) = fN_in + fN_out - g*min(fg*R*y(ifN), R) + fsLr*y(isN) + fNProd;  
                    dydt(isN) = - fsLr*y(isN);
                    dydt(iL) = 0;                             % Under low nitrogen, growth rate depends on concentration of fixed nitrogen
                    dydt(ipS) = PatS_in + PatS_out + y(iC)*PatSProd;
                    dydt(ihN) = HetN_in + HetN_out + HetNProdn;
                    if length(A) == 1 || i == 1 && length(A) > 1 && y(ipS) >= y(iRpS) || i == length(A) && length(A) > 1 && y(ipS) >= y(iLpS) || y(ipS) >= y(iRpS) && y(ipS) >= y(iLpS);
                        dydt(iC) = (101 - y(iC))/101;
                    else
                        dydt(iC) = (101 - ihb*(y(ipS) + y(ihN))*y(iC))/101;
                    end
                end
    end
end


