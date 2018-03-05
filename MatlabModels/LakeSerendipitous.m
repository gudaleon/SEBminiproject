syms f(x,y)
f(x,y) = real(atan(x+1*y)) * sin(x)+1;
z = ezsurf(f,12)