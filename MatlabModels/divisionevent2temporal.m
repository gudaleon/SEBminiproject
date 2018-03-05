function [value, isterminal, direction] = divisionevent2temporal(~, y)
nvp = temporalcyanobacterium.nvp;
dims = size(y)-1;
subsetV =(1:dims(1)/nvp).*nvp; %Volume columns
divisionformula = max(y(subsetV))-temporalcyanobacterium.Volumelimit; % Equals zero when cell divides
value = divisionformula; 
isterminal = 1;
direction = 0;
end