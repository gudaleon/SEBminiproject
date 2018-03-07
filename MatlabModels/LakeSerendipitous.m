%% Nitrogen Levels

syms f(x,y)
f(x,y) = 4 + real(atan(x+1*y)) * sin(x)+1 + sin(1*x) + 2*sin(0.5*y) + 0.25*sin(4*y+3);
z = ezsurf(f,100);
N = z.ZData;

%% Phosphate levels

syms f(x,y)
f(x,y) = abs(real(atan(x+1*y)) * sin(x)+1 + sin(1*x) + 2*sin(0.5*y) + 0.25*sin(4*y+3) + 0.3*sin(y)*y*x + 9);
q = ezsurf(f,100);
P = q.ZData;

%% lIGHT LEVELS

syms f(x,y)
f(x,y) = 3+ 0.005*x*real(atan(x+1*y))*sin(x+1)+1;
p = ezsurf(f,100);
L = p.Zdata;

%% Getting a birth probability

Birthrate = zeros(100);

% Spatial Cells

for i = 1:100
    for j = 1:100
        Birthratespatial(i,j) = 0.7*(P(i,j)/(7 + P(i,J))*(N(i,J)/(N(i,j) + 4)*(L(i,j)/(L(i,j) + 4));
        Birthratetemporal(i,j) = 0.75*(P(i,j)/(9 + P(i,J))*(N(i,J)/(N(i,j) + 7)*(L(i,j)/(L(i,j) + 3.98));
        Birthrateheterotroph(i,j) = 0.75*(P(i,j)/(9 + P(i,J))*(N(i,J)/(N(i,j) + 7)*(L(i,j)/(L(i,j) + 3.98));

        











































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































