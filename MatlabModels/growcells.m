function [t,y,TE,VE] = growcells(ts, A, y0)
%%Running the growth until a cell division
t = ts:ts+1000;
options = odeset('Events', @divisionevent2);
[t, y, TE, VE] = ode45(@(t,y, TE, VE) grow(t,y,A), t, y0, options);
end

