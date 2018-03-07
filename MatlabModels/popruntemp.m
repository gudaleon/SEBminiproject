function [t,y] = popruntemp(tmax, y0, latitude, Gsc)
%This runs population dynamics of the cyanobacteria. tmax is the desired
%end time of the simulation (an integer number of days). y0 is a vector of three values: the starting
%amount of nitrogen, the starting popn size, and the starting amount of
%carbon.
t = 1:1:tmax;
[t,y] = ode45(@(t,y) popnmodelworking2(t,y, latitude, Gsc), t, y0);
end

