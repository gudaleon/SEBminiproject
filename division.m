function A = division(A, Pos)
ID = A(Pos).Identifier;
for n = length(A):-1:Pos
    A(n+1) = A(n);
    A(n+1) = cyanobacterium.push(A(n+1));
end
A(Pos) = cyanobacterium.div(A(Pos));

%Properties of the new cell that are different from the parent
A(Pos + 1) = A(Pos);
A(Pos + 1).Identifier = [ID 1];
A(Pos + 1).Position = A(Pos).Position + 1;



    