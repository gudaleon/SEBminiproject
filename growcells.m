function [y] = growcells(A, y0, nvp)
%%Running the growth until a cell division
t = [0:0.1:1000];
options = odeset('Events', @eventfunction);
[t, y, TE, VE] = ode45(@(t,y, TE, VE) grow(t,y,A,nvp), t, y0, options);
end

