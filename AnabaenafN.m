function [dydt] = AnabaenafN(t, y, fN, x)
%This models the growth and differentiation of the Anabaena cells   
dydt = zeros(x,1);
dfNdt = zeros(x,1);
D = 0.3;
Dext_in = 0.2;
Din_ext = 0.1;
fNext = 1;
    for i = 1:x
        if y(i) > 0
            dydt(i) = y(i)*(5.1 - y(i));
            dfNdt = D*fN(i-1)/y(i-1) + D*fN(i+1)/y(i+1) - 2*D*fN(i)/y(i) + Dext_in*y(i)*fNext - fN(i)*Din_ext; %Currently omitted Gi for simplicity
        else
        end
    end
end
