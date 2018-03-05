function [dydt] = Anabaenapopn(t, y)
%This models the population level growth of Anabaena, as a function of
%nitrogen, phosphate and light levels.

r = 0:pi/24:365*pi;
sunlight = (((sin(r./365)+1).*sin(r).^2)/2);

dydt = zeros(


end

