function [value, isterminal, direction] = divisionevent(~, y)
nvp = cyanobacterium.nvp;
dims = size(y);
subset =(1:dims(1)/nvp).*nvp;
value = max(y(subset)-cyanobacterium.Lengthlimit); 
isterminal = 1;
direction = 1;
end