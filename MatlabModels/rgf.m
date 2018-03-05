function [A, rec, Lux, ts, dvc, y, t, hcy, prhcy, fNlev, spltc, lngtt] = rgf(A, generations, Lux, ts)
%Running the growth until a cell division
%note: the number of variable properties (nvp) must be defined twice: here, and
%in the event function. A defines the first cell.
nvp = cyanobacterium.nvp;
nxp = 1;
dvc = zeros(1,generations+1);   % Time of cell division or differntiation
hcy = zeros(1,generations+1);   % Number of heterocysts
prhcy = zeros(1,generations+1); % Proportion of cells that are heterocysts
lngtt = zeros(1,generations+1);
fNlev = zeros(1,generations+1);
fNlev(1) = mean([A.StoredNitrogen]);
lngtt(1) = length(A);
spltc = zeros(1, generations+1);
rec = [];
for p = 1:generations
    %defining the initial conditions i.e. mapping from cells to growth vector,
    %for growth
    clear y0 dividers dims yend subset cell n i y TE
    y0 = zeros(1,nvp*length(A) + 1);
    y0(nvp*length(A)+1) = Lux;
    for i = 1:length(A) 
        y0((i-1)*(nvp)+1) = A(i).StoredNitrogen;
        y0((i-1)*(nvp)+2) = A(i).StoredCarbon;
        y0((i-1)*(nvp)+3) = A(i).HetR;
        y0((i-1)*(nvp)+4) = A(i).PatS;
        y0((i-1)*(nvp)+5) = A(i).HetN;
        y0((i-1)*(nvp)+6) = A(i).Oxygen;
        y0((i-1)*(nvp)+7) = A(i).FixedNitrogen;
        y0((i-1)*(nvp)+8) = A(i).Phosphate;
        y0((i-1)*(nvp)+9) = A(i).FixedCarbon;
        y0((i-1)*(nvp)+10) = A(i).Length; %It is important to always make length the last variable assigned, for the event function
    end

    %Running the growth to get an output:
    [t,y,TE] = growcells(ts, A,y0);

    %mapping back the properties from the growth vector to the cells, for division
    dims = size(y);
    yend = y(dims(1),:); 
    Lux = yend(length(yend));
    
    for i = 1:(length(yend)-nxp)/nvp
        A(i).StoredNitrogen = yend(i*nvp - 9);
        A(i).StoredCarbon = yend(i*nvp - 8);
        A(i).HetR = yend(i*nvp - 7);
        A(i).PatS = yend(i*nvp - 6);
        A(i).HetN = yend(i*nvp - 5);
        A(i).Oxygen = yend(i*nvp - 4);
        A(i).FixedNitrogen = yend(i*nvp -3); %you would add in another at i*nvp - 2 etc. as needed
        A(i).Phosphate = yend(i*nvp -2);
        A(i).FixedCarbon = yend(i*nvp - 1);
        A(i).Length = yend(i*nvp); 
    end
    subset =(1:(dims(2)-nxp)/nvp).*nvp;
    dividers = find(yend(subset) >= 5);
    subsethR =subset - 7;                     % If adding parameters redefine hetR position
    differentiaters = find(yend(subsethR) >= cyanobacterium.HetRlimit);
    
    for n = 1:length(dividers)
        cell = dividers(n) + n-1;
        A = division(A,cell);
    end
    for q = 1:length(differentiaters)
      cell_2 = differentiaters(q);
        A = differentiation(A, cell_2);
    end 
       
    % Schism event:
    splitlength = normrnd(50, 10);
    if length(A) > splitlength
        x = round(normrnd(length(A)/2, 5));
        A = A(1:x);
        spltc(p+1) = dvc(p) + TE;
    end
    
    dvc(p+1) = dvc(p)+TE;
    hcy(p+1) = length(find([A.DifferentiationFinished]));
    prhcy(p+1) = length(find([A.DifferentiationFinished]))/length(A);
    lngtt(p+1) = length(A);
    fNlev(p+1) = sum([A.StoredNitrogen]); 
    rec = [rec;y(:,length(yend))];
    ts = dvc(p+1);
    
end
end
    
