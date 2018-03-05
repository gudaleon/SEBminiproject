function [dydt] = AnabaenafN(t, y, fN, x)
%This models the growth and differentiation of the Anabaena cells   
dydt = zeros(x,1);

fNext = 1;
    for i = 1:x
        if y(i) > 0
            dydt(i) = y(i)*(5.1 - y(i));
        else
        end
    end
end
