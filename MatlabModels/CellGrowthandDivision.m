% Running Anabaena:
% This code works, but be wary that it leads to a discontinuity between
% columns of the output matrix, and the individual cell lengths, because
% when a cell divides, everything gets shifted to make room for the new
% cell. After each division the process restarts from the same time point,
% but one cell will have been split into two.

y0 = 2.5;
divisions = 9;
fullmatrix = zeros(1,10);
clock=0;
TE=0;

for n = 1:divisions;    
    t = [TE:0.1:1000];
    options = odeset('Events', @eventfunction);
    x = length(y0); 
    [t, y, TE, VE] = ode45(@(t,y, TE, VE) Anabaena(t,y,x), t, y0, options);
    
    dividers = find(VE >= 5);
    for i = 1:length(dividers)
        divider = dividers(i);
        newstart = zeros(1, length(y0) + 1);
        q = normrnd(0,0.3);
        newstart(divider) = 2.5 + q; %assigns new lengths to the daughter cells
        newstart(divider + 1) = 2.5 - q; %assigns new lengths to the daughter cells
        othercellsd1 = VE(divider+1:end);
        othercellsu1 = VE(1:divider-1);
        othercellsd2 = [zeros(1, max(0, numel(newstart) - numel(othercellsd1))), othercellsd1];
        othercellsu1(numel(newstart)) = 0;
        y0 = newstart + othercellsd2 + othercellsu1;
        steps = size(y);
        ymatrix = zeros(steps(1), divisions + 1);
        ymatrix(1:steps(1),1:steps(2)) = y;
        fullmatrix = [fullmatrix; ymatrix];
        clock = [clock; t];
    end
end

%%

y0 = 2.5;
fN0 = 1;
divisions = 9;
fullmatrix = zeros(1,10);
clock=0;
TE=0;

for n = 1:divisions;    
    t = [TE:0.1:1000];
    options = odeset('Events', @eventfunction);
    x = length(y0); 
    ode1 = Anabaena(t, y, x);
    ode2 = fNdiffusion(t, fN, x);
    odes = [ode1; ode2];
    [t, y, TE, VE] = ode45(@(t,y, TE, VE) Anabaena(t,y,x), t, y0, options);
    
    dividers = find(VE >= 5);
    for i = 1:length(dividers)
        divider = dividers(i);
        newstart = zeros(1, length(y0) + 1);
        q = normrnd(0,0.3);
        newstart(divider) = 2.5 + q; %assigns new lengths to the daughter cells
        newstart(divider + 1) = 2.5 - q; %assigns new lengths to the daughter cells
        othercellsd1 = VE(divider+1:end);
        othercellsu1 = VE(1:divider-1);
        othercellsd2 = [zeros(1, max(0, numel(newstart) - numel(othercellsd1))), othercellsd1];
        othercellsu1(numel(newstart)) = 0;
        y0 = newstart + othercellsd2 + othercellsu1;
        steps = size(y);
        ymatrix = zeros(steps(1), divisions + 1);
        ymatrix(1:steps(1),1:steps(2)) = y;
        fullmatrix = [fullmatrix; ymatrix];
        clock = [clock; t];
    end
end
    