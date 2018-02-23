classdef cyanobacterium
    % defining the properties of a single cyanobacterial cell.
    properties
        Identifier;
        FixedNitrogen; 
        Length; 
        Position;
        Lengthlimit;
        Heterocyst;
    end
    methods (Static)
        function cyanobacterium = construct(I, fN, L, P, LL)
            cyanobacterium.Identifier = I;
            cyanobacterium.FixedNitrogen = fN;
            cyanobacterium.Length = L;
            cyanobacterium.Position = P;
            cyanobacterium.Lengthlimit = LL;
        end
        function cyanobacterium = div(cyanobacterium)
                cyanobacterium.Identifier = [cyanobacterium.Identifier, 0];
                cyanobacterium.Length = cyanobacterium.Length/2;
                cyanobacterium.FixedNitrogen = cyanobacterium.FixedNitrogen/2;
        end
        function cyanobacterium = push(cyanobacterium)
            cyanobacterium.Position = cyanobacterium.Position + 1;
        end
        function differentiate = differentiate(cyanobacterium)
            cyanobacterium.Heterocyst = TRUE;
        end
    end
end
