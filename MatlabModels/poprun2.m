function [t,y] = poprun2(tmax, y0, latitude, Gsc, N_influx, P_influx)
%This runs population dynamics of the cyanobacteria. tmax is the desired
%end time of the simulation (an integer number of days). y0 is a vector of three values: the starting
%amount of nitrogen, the starting popn size, and the starting amount of
%carbon.
t = 1:1:tmax;
[t,y] = ode45(@(t,y) popnmodelheterotroph_test(t,y, latitude, Gsc, N_influx, P_influx), t, y0);
end

