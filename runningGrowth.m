%Running the growth until a cell division
%note: the number of variable properties must be defined twice: here, and
%in the event function.

%Defining the number of dependent variables per cell
nvp = 2;
%A = cyanobacterium.construct([0], 4, 3, 1, 5);
%defining the initial conditions i.e. mapping from cells to growth vector,
%for growth
clear y0 dividers dims yend subset cell n i y 
for i = 1:length(A)
    y0((i-1)*(nvp)+1) = A(i).FixedNitrogen;
    y0((i-1)*(nvp)+2) = A(i).Length; %It is important to always make length the last variable assigned, for the event function
end
y = growcells(A,y0,nvp);

%mapping back the properties from the growth vector to the cells, for division
dims = size(y);
yend = y(dims(1),:); 
for i = 1:length(yend)/nvp
    A(i).FixedNitrogen = yend(i*nvp -1); %you would add in another at i*nvp - 2 etc. as needed
    A(i).Length = yend(i*nvp); 
end

%Deciding which cells to divide, and dividing them
subset =(1:dims(2)/nvp).*nvp;
dividers = find(yend(subset) >= 5);
for n = 1:length(dividers)
    cell = dividers(n) + n-1;
    A = division(A,cell);
end



