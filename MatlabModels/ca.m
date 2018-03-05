classdef ca
    properties
        M = [];
        survive = [2 3];
        birth = [3];
    end %properties
    
    methods
        function obj = ca(n);
            obj.M = round(rand(n));
        end
        function disp(obj)
            disp(obj.M);
        end
        function obj = step(obj);
        end
    end %methods
end
