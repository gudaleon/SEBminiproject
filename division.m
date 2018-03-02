function A = division(A, Pos)
ID = A(Pos).Identifier;
for n = length(A):-1:Pos
    A(n+1) = A(n);
    A(n+1) = cyanobacterium.push(A(n+1));
end
A(Pos) = cyanobacterium.div(A(Pos));

%Properties of the new cell that are different from the parent
s = normrnd(0,0.2);
A(Pos + 1) = A(Pos);
A(Pos + 1).Identifier = [ID 1];
A(Pos + 1).Position = A(Pos).Position + 1;
A(Pos + 1).GrowthPara = 1 - s;
A(Pos).GrowthPara = 1 + s;




    