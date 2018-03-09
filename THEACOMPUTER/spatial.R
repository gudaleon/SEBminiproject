spatial1 <- read.table('spatial_out_1.txt')
colnames(spatial1) <- c('time','Ci.1', 'Ngas.1', 'Ogas.1', 'Cfix.1', 'Nfix.1', 'ATP.1')

spatial2 <- read.table('spatial_out_2.txt')
colnames(spatial2) <- c('time','Ci.2', 'Ngas.2', 'Ogas.2', 'Cfix.2', 'Nfix.2', 'ATP.2')

spatial3 <- read.table('spatial_out_3.txt')
colnames(spatial3) <- c('time','Ci.3', 'Ngas.3', 'Ogas.3', 'Cfix.3', 'Nfix.3', 'ATP.3')

spatial4 <- read.table('spatial_out_4.txt')
colnames(spatial4) <- c('time','Ci.4', 'Ngas.4', 'Ogas.4', 'Cfix.4', 'Nfix.4', 'ATP.4')

spatial5 <- read.table('spatial_out_5.txt')
colnames(spatial5) <- c('time','Ci.5', 'Ngas.5', 'Ogas.5', 'Cfix.5', 'Nfix.5', 'ATP.5')

spatial6 <- read.table('spatial_out_6.txt')
colnames(spatial6) <- c('time','Ci.6', 'Ngas.6', 'Ogas.6', 'Cfix.6', 'Nfix.6', 'ATP.6')

spatial7 <- read.table('spatial_out_7.txt')
colnames(spatial7) <- c('time','Ci.7', 'Ngas.7', 'Ogas.7', 'Cfix.7', 'Nfix.7', 'ATP.7')

spatial8 <- read.table('spatial_out_8.txt')
colnames(spatial8) <- c('time','Ci.8', 'Ngas.8', 'Ogas.8', 'Cfix.8', 'Nfix.8', 'ATP.8')

spatial9 <- read.table('spatial_out_9.txt')
colnames(spatial9) <- c('time','Ci.9', 'Ngas.9', 'Ogas.9', 'Cfix.9', 'Nfix.9', 'ATP.9')

spatial10 <- read.table('spatial_out_10.txt')
colnames(spatial10) <- c('time','Ci.10', 'Ngas.10', 'Ogas.10', 'Cfix.10', 'Nfix.10', 'ATP.10')

spatial11 <- read.table('spatial_out_11.txt')
colnames(spatial11) <- c('time','Ci.11', 'Ngas.11', 'Ogas.11', 'Cfix.11', 'Nfix.11', 'ATP.11')

spatial12 <- read.table('spatial_out_12.txt')
colnames(spatial12) <- c('time','Ci.12', 'Ngas.12', 'Ogas.12', 'Cfix.12', 'Nfix.12', 'ATP.12')
spatial12
spatial_all <- cbind(spatial2, spatial3[,2:7], spatial4[,2:7], spatial5[,2:7], spatial6[,2:7], spatial7[,2:7], spatial8[,2:7], spatial9[,2:7], spatial10[,2:7], spatial11[,2:7], spatial12[,2:7])
#spatial_all <- cbind(spatial1, spatial2[,2:7], spatial3[,2:7], spatial4[,2:7], spatial5[,2:7], spatial6[,2:7], spatial7[,2:7], spatial8[,2:7], spatial9[,2:7], spatial10[,2:7], spatial11[,2:7], spatial12[,2:7])

spatial_all

plot3d(x, y=, z=time)
