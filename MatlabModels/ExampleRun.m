% Example code
 
% Note: it is of fundamental importance to define Lux and ts as output
% parameters, otherwise you will end up with negative light levels!
Lux = 0;
ts = 0;
[A, rec, Lux, ts, dvc, y] = rgf(James,3,Lux,ts);