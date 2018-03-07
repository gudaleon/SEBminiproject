growthrate = zeros(100,1);

for i = 0:1:299
    y0 = [i/100 1 100 100 100 0];
    [t,y] = poprun(96, y0, 52, i);
    growthrate(i+1) = max(y(:,2))/max(t);
end
