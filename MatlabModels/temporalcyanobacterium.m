classdef temporalcyanobacterium
    % defining the properties of a single cyanobacterial cell.
    properties
        %Discrete Variables: Do not count these in nvp
        Identifier;                 % Boolean
        Position;                   % Integer > 0, start at 1
        %Continuous Variables
        StoredNitrogen;
        StoredCarbon;
        Oxygen;
        FixedNitrogen;
        Phosphate;
        FixedCarbon;
        Volume;
        GP;
    end
    properties (Constant)
        GrowthRate = 1;             % Baseline growth rate of the cyanobacterium
        Volumelimit = 5;            % Length at which cells divide
        ExtracellularfN = 0.05;     % Amount of extracellular fixed nitrogen
        ExtracellularfC = 0.05;
        ExtracellularP = 0.03;
        fNrequirement = 0.05;       % Amount of fixed nitrogen required for growth
        Prequirement = 0.03;        % Amount of phosphate required for growth
        fCrequirement = 0.07;       % Amount of fixed carbon required for growth
        nvp = 7;                    % The number of continuous variable to be modelled with ODEs
        fNStorageRate = 0.3;        % Constant of conversion of fN to sN.
        fNleak = 0.0029;            % Constant of fN leakage from cells
        fNimport = 0.29;            % Constant of fN import into cells
        fCleak = 0.0029;            % Constant of fC leakage from cells
        fCimport = 0.05;             % Constant of fC import into cells
        Pleak = 0.0029;             % Constant of P leakage from cells
        Pimport = 0.03;              % Constant of P import into cells
        ProteinLoss = 5;            % Constant of patS and hetN to the environment or by degradation
        fNPrdctnRate = 0.5;         % Rate of production of fN by heterocysts
        fsLiberationRate = 0.3;     % Rate of mobilisation of fN stores
        Area = 0.3;                 % Average Proportion of surface area that the cell 'end' represents (cells are cylinders)
    end
    methods (Static) 
        function temporalcyanobacterium = construct(I, P, sN, fN, Ph, sC, fC, Ox, V, GP)
            temporalcyanobacterium.Identifier = I; 
            temporalcyanobacterium.Position = P;
            temporalcyanobacterium.StoredNitrogen = sN; 
            temporalcyanobacterium.FixedNitrogen = fN;
            temporalcyanobacterium.Phosphate = Ph;
            temporalcyanobacterium.StoredCarbon = sC;
            temporalcyanobacterium.FixedCarbon = fC;
            temporalcyanobacterium.Oxygen = Ox;
            temporalcyanobacterium.Volume = V;
            temporalcyanobacterium.GrowthPara = GP;
        end
        function temporalcyanobacterium = div(temporalcyanobacterium)
                temporalcyanobacterium.Identifier = [temporalcyanobacterium.Identifier, 0];
                temporalcyanobacterium.Oxygen = temporalcyanobacterium.Oxygen/2;
                temporalcyanobacterium.FixedNitrogen = temporalcyanobacterium.FixedNitrogen/2;
                temporalcyanobacterium.StoredNitrogen = temporalcyanobacterium.StoredNitrogen/2;
                temporalcyanobacterium.Phosphate = temporalcyanobacterium.Phosphate/2;
                temporalcyanobacterium.StoredCarbon = temporalcyanobacterium.StoredCarbon/2;
                temporalcyanobacterium.FixedCarbon = temporalcyanobacterium.FixedCarbon/2;
                temporalcyanobacterium.Volume = temporalcyanobacterium.Volume/2;
                
        end
         function temporalcyanobacterium = push(temporalcyanobacterium)
            temporalcyanobacterium.Position = temporalcyanobacterium.Position + 1;
        end
    end
end
