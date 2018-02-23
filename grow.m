function [dydt] = grow(y,t,A,nvp)
%This simulates the growth of a group of cells from one cell division until
%the next.
dydt = zeros(nvp*length(A),1);
for i = 1:length(A)
    dydt((i-1)*nvp + 1) = 0.5;
    dydt((i-1)*nvp + 2) = 0.3;
end
%defining initial conditions
end

