function [value, isterminal, direction] = eventfunction(t, y);
value = max(y-5);
isterminal = 1;
direction = 1;
end