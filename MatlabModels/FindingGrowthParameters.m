growthrate = zeros(100,1);

for i = 1:1:100
    y0 = [10 10 10 10 i/100 0];
    [t,y] = poprun2(100, y0, 52, 1000);
    growthrate(i) = max(y(:,2))/max(t);
end
