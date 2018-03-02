function [value, isterminal, direction] = divisionevent2(~, y)
g = cyanobacterium.fNrequirement;
fs = cyanobacterium.fNStorageRate;
nvp = cyanobacterium.nvp;
dims = size(y);
subsetL =(1:dims(1)/nvp).*nvp; %Length columns
subsetC =(1:dims(1)/nvp).*nvp - 6; %hetR columns
divisionformula = max(y(subsetL))-cyanobacterium.Lengthlimit; % Equals zero when cell divides
differentiationformula = max(y(subsetC))-cyanobacterium.HetRlimit; %Note - this will fail if the initial value of the differentiation formula is <0
value = [divisionformula, differentiationformula]; 
isterminal = [1 1];
direction = [0 0];
end