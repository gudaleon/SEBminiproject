function [dfNdt] = fNdiffusion(t,fN,x)
%The diffusion rate for an individual cell
dfNdt = zeros(x,1);
D = 0.3;
Dext_in = 0.2;
Din_ext = 0.1;
for i = 1:x
    if i == 1 && x > 1
        dfNdt = D*fN(i+1)/y(i+1) - D*fN(i)/y(i) + Dext_in*y(i)*fNext - fN(i)*Din_ext; %Currently omitted Gi for simplicity
    elseif i == x && x > 1
        dfNdt = D*fN(i-1)/y(i-1) - D*fN(i)/y(i) + Dext_in*y(i)*fNext - fN(i)*Din_ext; %Currently omitted Gi for simplicity
    elseif x ~= 1
        dfNdt = D*fN(i+1)/y(i+1) + D*fN(i-1)/y(i-1) - D*fN(i)/y(i) + Dext_in*y(i)*fNext - fN(i)*Din_ext; %Currently omitted Gi for simplicity
    else
        dfNdt = - D*fN(i)/y(i) + Dext_in*y(i)*fNext - fN(i)*Din_ext;
    end
end
end

