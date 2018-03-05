function [growth] = grow(y,t,A)
%This simulates the growth of a group of cells from one cell division until
%the next.
no.variable.properties = 1
dydt = zeros(no.variable.properties*length(A),1)
for i = 1:length(A)
    for n = 1:no.variable.properties
        y(i + (n-1)*no.variable.properties) = 


end

