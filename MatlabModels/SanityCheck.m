James = cyanobacterium.construct(0, 1, 0, 1, 1, 1, 0, 0, 0, 0.2, 1, 1, 1, 2.5)
Lux = 0
ts = 0
for i=1:2
 [B, rec, Lux, ts]=rgf(B, 1, Lux, ts)
end 