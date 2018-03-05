classdef cyanobacterium
    % defining the properties of a single cyanobacterial cell.
    properties
        % Time: do not count this in nv
        %Discrete Variables
        Identifier;     %Boolean
        Position;       %Integer > 0, start at 1
        DifferentiationFinished;     %Boolean
        %Continuous Variables
        StoredNitrogen;
        StoredCarbon;
        HetR;               % level of HetR
        PatS;               % Level of PatS
        HetN;               % Level of HetN
        Oxygen;
        FixedNitrogen;
        Phosphate;
        FixedCarbon;
        Length;
        GP;
    end
    properties (Constant)
        GrowthRate = 1;             % Baseline growth rate of the cyanobacterium
        Lengthlimit = 5;            % Length at which cells divide
        ExtracellularfN = 0.05;     % Amount of extracellular fixed nitrogen
        ExtracellularfC = 0.05;
        ExtracellularP = 0.03;
        fNrequirement = 0.05;       % Amount of fixed nitrogen required for growth
        Prequirement = 0.03;        % Amount of phosphate required for growth
        fCrequirement = 0.07;       % Amount of fixed carbon required for growth
        nvp = 10;                    % The number of continuous variable to be modelled with ODEs
        fNStorageRate = 0.3;        % Constant of conversion of fN to sN.
        InterCellfNDiff = 0.154;    % Constant of diffusion of fN between vegetative cells
        InterCellfCDiff = 0.1;
        InterCellPDiff = 0.1;
        InterCellOxDiff = 0.1;
        fNleak = 0.0029;            % Constant of fN leakage from cells
        fNimport = 0.29;            % Constant of fN import into cells
        fCleak = 0.0029;            % Constant of fC leakage from cells
        fCimport = 0.05;             % Constant of fC import into cells
        Pleak = 0.0029;             % Constant of P leakage from cells
        Pimport = 0.03;              % Constant of P import into cells
        InterCellProteinDiff = 20;  % Constant of patS and hetN movement between cells
        ProteinLoss = 5;            % Constant of patS and hetN to the environment or by degradation
        fNPrdctnRate = 0.5;         % Rate of production of fN by heterocysts
        PatSprdctnRate = 10;        % Rate of production of patS by heterocysts
        HetNprdctnRate = 5e3;       % Rate of production of hetN by heterocysts
        fsLiberationRate = 0.3;     % Rate of mobilisation of fN stores
        HetRlimit = 1.5;
        Area = 0.3;                 % Average Proportion of surface area that the cell 'end' represents (cells are cylinders)
    end
    methods (Static) 
        function cyanobacterium = construct(I, P, DF, GP, sN, sC, hR, pS, hN, Ox, fN, Ph, fC, L)
            % Note, sN must start at a greater value than L*0.5*g*fs
            cyanobacterium.Identifier = I; 
            cyanobacterium.Position = P;
            cyanobacterium.DifferentiationFinished = DF; 
            cyanobacterium.GrowthPara = GP;
            cyanobacterium.StoredNitrogen = sN; 
            cyanobacterium.StoredCarbon = sC;
            cyanobacterium.HetR = hR;
            cyanobacterium.PatS = pS;
            cyanobacterium.HetN = hN;
            cyanobacterium.Oxygen = Ox;
            cyanobacterium.FixedNitrogen = fN;
            cyanobacterium.Phosphate = Ph;
            cyanobacterium.FixedCarbon = fC;
            cyanobacterium.Length = L;

        end
        function cyanobacterium = div(cyanobacterium)
                cyanobacterium.Identifier = [cyanobacterium.Identifier, 0];
                cyanobacterium.Length = cyanobacterium.Length/2;
                cyanobacterium.FixedNitrogen = cyanobacterium.FixedNitrogen/2;
                cyanobacterium.StoredNitrogen = cyanobacterium.StoredNitrogen/2;
                cyanobacterium.Phosphate = cyanobacterium.Phosphate/2;
                cyanobacterium.StoredCarbon = cyanobacterium.StoredCarbon/2;
                cyanobacterium.FixedCarbon = cyanobacterium.FixedCarbon/2;
                cyanobacterium.Oxygen = cyanobacterium.Oxygen/2;
                cyanobacterium.PatS = cyanobacterium.PatS/2;
                cyanobacterium.HetN = cyanobacterium.HetN/2;
                cyanobacterium.HetR = cyanobacterium.HetR/2; 
        end
        function cyanobacterium = push(cyanobacterium)
            cyanobacterium.Position = cyanobacterium.Position + 1;
        end
        function cyanobacterium = differentiate(cyanobacterium)
            cyanobacterium.DifferentiationFinished = 1;
            cyanobacterium.HetR = cyanobacterium.HetR - 0.1;            % Fudge to prevent the event function being immediately satisfied.
        end
    end
end
