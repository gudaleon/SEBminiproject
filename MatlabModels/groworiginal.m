function [dydt] = grow(t,y,A)
%This simulates the growth of a group of cells from one cell division until
%the next.

%Parameter Defintions
    nvp = cyanobacterium.nvp;                    % Number of variables we are modelling
  extfN = cyanobacterium.ExtracellularfN;        % Amount of extracellular fixed nitrogen
      g = cyanobacterium.fNrequirement;          % Amount of fixed nitrogen required for growth per unit length
      R = cyanobacterium.GrowthRate;             % Baseline growth rate of the cyanobacterium
     fg = cyanobacterium.NDeprivedGRfraction;    % Proportion of the maximal growth rate when running off stored nitrogen
     fs = cyanobacterium.fNStorageRate;          % Constant of conversion from fN to stored N.
      D = cyanobacterium.InterCellfNDiff;        % fN Diffusion coefficient between cells
   area = 0.4;                                   % Relates exposed SA of a single cell to a cell in the mix
 D_leak = cyanobacterium.fNleak;                 % Diffusion from within cells to the extracellular environment
 D_imp  = cyanobacterium.fNimport;               % Diffusion from outside the cells to within the cells
 

% Pre-defining a vector of zeros for dydt
dydt = zeros(nvp*length(A),1);

for i = 1:length(A)
    %Specifying the different indices:
    isN = (i-1)*nvp + 1;                    % Stored nitrogen of cell 'i'
    ifN = (i-1)*nvp + 2;                    % Fixed nitrogen in cell 'i'
     iL = (i-1)*nvp + 3;                    % Length of cell 'i'
   iLsN = (i-2)*nvp + 1;                    % Stored nitrogen of cell 'i-1'
   iLfN = (i-2)*nvp + 2;                    % Fixed nitrogen of cell 'i-1'
    iLL = (i-2)*nvp + 3;                    % Length of cell 'i-1'
   iRsN = i*nvp + 1;                        % Stored nitrogen of cell 'i+1'
   iRfN = i*nvp + 2;                        % Fixed nitrogen of cell 'i+1'
    iRL = i*nvp + 3;                        % Length of cell 'i+1'
    
% Cell positions: (for speed, the order could be changed here, so that it
% will come across the most common scenario (in the mix) first. It may also
% be worth considering whether to swap the nesting of the 'if' clauses.
    if A(i).DifferentiationStarted == 0;
   %Lone cell
        if length(A) == 1
            fN_imp = D_imp*y(iL)*extfN;
            fN_out = - 2*area*D_leak*y(ifN)/y(iL) - D_leak*y(ifN);
        elseif i == 1 && length(A) > 1
            fN_imp = D*y(iRfN)/y(iRL) + D_imp*y(iL)*extfN;
            fN_out = - D*y(ifN)/iL - D_leak*y(ifN) - area*D_leak*y(ifN)/y(iL);
        elseif i == length(A) && length(A) > 1
            fN_imp = D*y(iLfN)/y(iLL)+ D_imp*y(iL)*extfN;
            fN_out = - D*y(ifN)/iL - D_leak*y(ifN) - area*D_leak*y(ifN)/y(iL);
        else
            fN_imp = D*y(iRfN)/y(iRL) + D*y(iLfN)/y(iLL)+ D_imp*y(iL)*extfN;
            fN_out = - 2*D*y(ifN)/iL - D_leak*y(ifN);
        end

            if y(ifN) > g
                dydt(ifN) = fN_imp + fN_out - g*R;          %fixed nitrogen
                 dydt(iL) = R;                              %length
                dydt(isN) = fs*g*R; 
            elseif y(ifN) <= g && y(isN) > g
                dydt(ifN) = fN_out;                         %fixed nitrogen, in this case, all imported nitrogen goes directly to growth (the model cuts out the middle man of stored nitrogen...)
                 dydt(iL) = min(fN_imp/g + fg*R, R);        %Note fN_imp/g represents the proportion of the minimal amount of nitrogen needed that influent nitrogen represents.
                dydt(isN) = fs*(fN_imp) - (g*R - fN_imp);
            elseif y(ifN) <=g && y(isN) <= g
                dydt(ifN) = fN_out;
                 dydt(iL) = min(fN_imp/g, R);
                dydt(isN) = fs*(fN_imp) - (g*R - fN_imp);
            end
    elseif A(i).DifferentiationStarted == 1;
        dydt(ifN) = fN_imp + fN_out - g*R;          %fixed nitrogen
        dydt(iL) = 0;                              %length
        dydt(isN) = fs*g*R; 
end

