function [A, divisionclock, y, t] = rgf(A, generations)
%Running the growth until a cell division
%note: the number of variable properties (nvp) must be defined twice: here, and
%in the event function. A defines the first cell.
nvp = cyanobacterium.nvp;
divisionclock = zeros(1,generations);
for p = 1:generations
    %defining the initial conditions i.e. mapping from cells to growth vector,
    %for growth
    clear y0 dividers dims yend subset cell n i y TE
    y0 = zeros(1,nvp*length(A));
    for i = 1:length(A) 
        y0((i-1)*(nvp)+1) = A(i).StoredNitrogen;
        y0((i-1)*(nvp)+2) = A(i).StoredCarbon;
        y0((i-1)*(nvp)+3) = A(i).HetR;
        y0((i-1)*(nvp)+4) = A(i).PatS;
        y0((i-1)*(nvp)+5) = A(i).HetN;
        y0((i-1)*(nvp)+6) = A(i).FixedNitrogen;
        y0((i-1)*(nvp)+7) = A(i).Phosphate;
        y0((i-1)*(nvp)+8) = A(i).FixedCarbon;
        y0((i-1)*(nvp)+9) = A(i).Length; %It is important to always make length the last variable assigned, for the event function
    end

    %Running the growth to get an output:
    [t,y,TE] = growcells(A,y0);

    %mapping back the properties from the growth vector to the cells, for division
    dims = size(y);
    yend = y(dims(1),:); 
    for i = 1:length(yend)/nvp
        A(i).StoredNitrogen = yend(i*nvp - 8);
        A(i).StoredCarbon = yend(i*nvp - 7);
        A(i).HetR = yend(i*nvp - 6);
        A(i).PatS = yend(i*nvp - 5);
        A(i).HetN = yend(i*nvp - 4);
        A(i).FixedNitrogen = yend(i*nvp -3); %you would add in another at i*nvp - 2 etc. as needed
        A(i).Phosphate = yend(i*nvp -2);
        A(i).FixedCarbon = yend(i*nvp - 1);
        A(i).Length = yend(i*nvp); 
    end
    subset =(1:dims(2)/nvp).*nvp;
    dividers = find(yend(subset) >= 5);
    subsethR =subset - 6;
    differentiaters = find(yend(subsethR) >= cyanobacterium.HetRlimit);
    
    for n = 1:length(dividers)
        cell = dividers(n) + n-1;
        A = division(A,cell);
    end
    for q = 1:length(differentiaters)
      cell_2 = differentiaters(q);
        A = differentiation(A, cell_2);
    end 
       
    %Deciding which cells to divide, and dividing them
    
  
    divisionclock = TE;
    
end
[A.DifferentiationFinished]
[A.HetR]
[A.PatS]
end
    
