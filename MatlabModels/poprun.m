function [t,y] = poprun(tmax, y0, latitude)
%This runs population dynamics of the cyanobacteria. tmax is the desired
%end time of the simulation (an integer number of days). y0 is a vector of three values: the starting
%amount of nitrogen, the starting popn size, and the starting amount of
%carbon.
t = 1:1:tmax;
[t,y] = ode45(@(t,y) popnmodelworkinghetr(t,y, latitude), t, y0);
end

