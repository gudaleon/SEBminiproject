function [value, isterminal, direction] = eventfunction(t, y);
nvp = 2;
dims = size(y);
subset =(1:dims(1)/nvp).*nvp;
value = max(y(subset)-5); %The 5 is representing the maximum length
isterminal = 1;
direction = 1;
end