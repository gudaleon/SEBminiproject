function [t,y,TE,VE] = growcellstemporal(ts, A, y0)
%%Running the growth until a cell division
t = ts:ts+1000;
options = odeset('Events', @divisionevent2temporal);
[t, y, TE, VE] = ode45(@(t,y, TE, VE) temporalgrow(t,y,A), t, y0, options);
end

