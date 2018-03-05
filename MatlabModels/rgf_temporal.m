function [A,rec, Lux, ts, dvc, y, t, fNlev, splitclock, lengthtot] = rgf_temporal(A, generations, Lux, ts)
%Running the growth until a cell division
%note: the number of variable properties (nvp) must be defined twice: here, and
%in the event function. A defines the first cell.
nvp = temporalcyanobacterium.nvp;
nxp = 1;                                % Number of added, changing, external parameters                               % Initial value of the light level
dvc = zeros(1,generations+1);
lengthtot = zeros(1,generations+1);
fNlev = zeros(1,generations+1);
fNlev(1) = mean([A.StoredNitrogen]);
lengthtot(1) = length(A);
splitclock = zeros(1, generations+1);
rec = [];
for p = 1:generations
    %defining the initial conditions i.e. mapping from cells to growth vector,
    %for growth
    clear y0 dividers dims yend subset cell n i y TE
    y0 = zeros(1, nvp*length(A)+nxp);
    y0(nvp*length(A)+1) = Lux;
    for i = 1:length(A) 
        y0((i-1)*(nvp)+1) = A(i).StoredNitrogen;
        y0((i-1)*(nvp)+2) = A(i).StoredCarbon;
        y0((i-1)*(nvp)+3) = A(i).Oxygen;
        y0((i-1)*(nvp)+4) = A(i).FixedNitrogen;
        y0((i-1)*(nvp)+5) = A(i).Phosphate;
        y0((i-1)*(nvp)+6) = A(i).FixedCarbon;
        y0((i-1)*(nvp)+7) = A(i).Volume; 
    end
    %Running the growth to get an output:
    
    [t,y,TE] = growcellstemporal(ts, A,y0);

    %mapping back the properties from the growth vector to the cells, for division
    dims = size(y);
    yend = y(dims(1),:); 
    Lux = yend(length(yend));
    
    for i = 1:(length(yend)-nxp)/nvp
        A(i).StoredNitrogen = yend(i*nvp - 6);
        A(i).StoredCarbon = yend(i*nvp - 5);
        A(i).Oxygen = yend(i*nvp - 4);
        A(i).FixedNitrogen = yend(i*nvp -3); %you would add in another at i*nvp - 2 etc. as needed
        A(i).Phosphate = yend(i*nvp -2);
        A(i).FixedCarbon = yend(i*nvp - 1);
        A(i).Volume = yend(i*nvp); 
    end
    subset =(1:dims(2)/nvp).*nvp;
    dividers = find(yend(subset) >= 5);
    
    for n = 1:length(dividers)
        cell = dividers(n) + n-1;
        A = divisiontemporal(A,cell);
    end
       
    % Schism event:
    splitlength = normrnd(50, 10);
    if length(A) > splitlength
        x = round(normrnd(length(A)/2, 5));
        A = A(1:x);
        splitclock(p+1) = dvc(p) + TE;
    end
    
    dvc(p+1) = dvc(p)+TE;
    ts = dvc(p);
    lengthtot(p+1) = length(A);
    fNlev(p+1) = sum([A.StoredNitrogen]);
    rec = [rec;y(:,3)];
end
end
    
