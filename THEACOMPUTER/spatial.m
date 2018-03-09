spatial1 = readtable('spatial_out_1.txt')
spatial2 = readtable('spatial_out_2.txt')
spatial3 = readtable('spatial_out_3.txt')
spatial4 = readtable('spatial_out_4.txt')
spatial5 = readtable('spatial_out_5.txt')
spatial6 = readtable('spatial_out_6.txt')
spatial7 = readtable('spatial_out_7.txt')
spatial8 = readtable('spatial_out_8.txt')
spatial9 = readtable('spatial_out_9.txt')
spatial10 = readtable('spatial_out_10.txt')
spatial11 = readtable('spatial_out_11.txt')
spatial12 = readtable('spatial_out_12.txt')

spatial1.Properties.VariableNames = {'time', 'Ci1', 'Ngas1', 'Ogas1', 'Cfix1', 'Nfix1', 'ATP1'}
spatial2.Properties.VariableNames = {'time', 'Ci2', 'Ngas2', 'Ogas2', 'Cfix2', 'Nfix2', 'ATP2'}
spatial3.Properties.VariableNames = {'time', 'Ci3', 'Ngas3', 'Ogas3', 'Cfix3', 'Nfix3', 'ATP3'}
spatial4.Properties.VariableNames = {'time', 'Ci4', 'Ngas4', 'Ogas4', 'Cfix4', 'Nfix4', 'ATP4'}
spatial5.Properties.VariableNames = {'time', 'Ci5', 'Ngas5', 'Ogas5', 'Cfix5', 'Nfix5', 'ATP5'}
spatial6.Properties.VariableNames = {'time', 'Ci6', 'Ngas6', 'Ogas6', 'Cfix6', 'Nfix6', 'ATP6'}
spatial7.Properties.VariableNames = {'time', 'Ci7', 'Ngas7', 'Ogas7', 'Cfix7', 'Nfix7', 'ATP7'}
spatial8.Properties.VariableNames = {'time', 'Ci8', 'Ngas8', 'Ogas8', 'Cfix8', 'Nfix8', 'ATP8'}
spatial9.Properties.VariableNames = {'time', 'Ci9', 'Ngas9', 'Ogas9', 'Cfix9', 'Nfix9', 'ATP9'}
spatial10.Properties.VariableNames = {'time', 'Ci10', 'Ngas10', 'Ogas10', 'Cfix10', 'Nfix10', 'ATP10'}
spatial11.Properties.VariableNames = {'time', 'Ci11', 'Ngas11', 'Ogas11', 'Cfix11', 'Nfix11', 'ATP11'}
spatial12.Properties.VariableNames = {'time', 'Ci12', 'Ngas12', 'Ogas12', 'Cfix12', 'Nfix12', 'ATP12'} 

%spatial_all = [spatial2, spatial3(:,[2:7]), spatial4(:,[2:7]), spatial5(:,[2:7]), spatial6(:,[2:7]), spatial7(:,[2:7]), spatial8(:,[2:7]), spatial9(:,[2:7]), spatial10(:,[2:7]), spatial11(:,[2:7]), spatial12(:,[2:7])]

spatial_Ci = table2array([spatial1(:,2), spatial2(:,2), spatial3(:,2), spatial4(:,2), spatial5(:,2), spatial6(:,2), spatial7(:,2), spatial8(:,2), spatial9(:,2), spatial10(:,2), spatial11(:,2), spatial12(:,2)])
spatial_Ngas = table2array([spatial1(:,3), spatial2(:,3), spatial3(:,3), spatial4(:,3), spatial5(:,3), spatial6(:,3), spatial7(:,3), spatial8(:,3), spatial9(:,3), spatial10(:,3), spatial11(:,3), spatial12(:,3)])
spatial_Ogas = table2array([spatial1(:,4), spatial2(:,4), spatial3(:,4), spatial4(:,4), spatial5(:,4), spatial6(:,4), spatial7(:,4), spatial8(:,4), spatial9(:,4), spatial10(:,4), spatial11(:,4), spatial12(:,4)])
spatial_Cfix = table2array([spatial1(:,5), spatial2(:,5), spatial3(:,5), spatial4(:,5), spatial5(:,5), spatial6(:,5), spatial7(:,5), spatial8(:,5), spatial9(:,5), spatial10(:,5), spatial11(:,5), spatial12(:,5)])
spatial_Nfix = table2array([spatial1(:,6), spatial2(:,6), spatial3(:,6), spatial4(:,6), spatial5(:,6), spatial6(:,6), spatial7(:,6), spatial8(:,6), spatial9(:,6), spatial10(:,6), spatial11(:,6), spatial12(:,6)])
spatial_ATP = table2array([spatial1(:,7), spatial2(:,7), spatial3(:,7), spatial4(:,7), spatial5(:,7), spatial6(:,7), spatial7(:,7), spatial8(:,7), spatial9(:,7), spatial10(:,7), spatial11(:,7), spatial12(:,7)])
ylab = ['r',
    's',
    'r', 
    's', 
    'r']
clf 

%surf(spatial_Ci)
%surf(spatial_Ngas)
%surf(spatial_Ogas)
surf(spatial_Cfix)
%surf(spatial_Nfix)
%surf(spatial_ATP)
%shading flat
shading interp
colormap parula
xticklabels('manual')
xticks([1:12])
xticklabels([1:12]) 
xlabel('cell')
yticks([1 235 433 667 865])
yticklabels(ylab)
ylabel('sun')
zlabel('fixed C')

 
