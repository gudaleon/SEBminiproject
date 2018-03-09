temporal1 <- read.table('temporal1.txt')
time <- temporal1[,1]
colnames(temporal1) <- c('time','Ci', 'Ngas', 'Ogas', 'Cfix', 'Nfix', 'ATP')

temporal2 <- read.table('temporal2.txt')
time <- temporal2[,1]
colnames(temporal2) <- c('time','Ci', 'Ngas', 'Ogas', 'Cfix', 'Nfix', 'ATP')

temporal3 <- read.table('temporal3.txt')
time <- temporal3[,1]
colnames(temporal3) <- c('time','Ci', 'Ngas', 'Ogas', 'Cfix', 'Nfix', 'ATP')

temporal4 <- read.table('temporal4.txt')
time <- temporal4[,1]
colnames(temporal4) <- c('time','Ci', 'Ngas', 'Ogas', 'Cfix', 'Nfix', 'ATP')

temporal5 <- read.table('temporal5.txt')
time <- temporal5[,1]
colnames(temporal5) <- c('time','Ci', 'Ngas', 'Ogas', 'Cfix', 'Nfix', 'ATP')

temporal_all <- cbind(temporal1, temporal2, temporal3, temporal4, temporal5)
temporal_all <- temporal_all[, -c(8, 15, 22, 29)]  
temporal_all

Ci_ave <- temporal_all$Ci + temporal_all$Ci.1 + temporal_all$Ci.2 + temporal_all$Ci.3 + temporal_all$Ci.4
Ci_ave <- Ci_ave/5

Ngas_ave <- temporal_all$Ngas + temporal_all$Ngas.1 + temporal_all$Ngas.2 + temporal_all$Ngas.3 + temporal_all$Ngas.4
Ngas_ave <- Ngas_ave/5

Ogas_ave <- temporal_all$Ogas + temporal_all$Ogas.1 + temporal_all$Ogas.2 + temporal_all$Ogas.3 + temporal_all$Ogas.4
Ogas_ave <- Ogas_ave/5

Cfix_ave <- temporal_all$Cfix + temporal_all$Cfix.1 + temporal_all$Cfix.2 + temporal_all$Cfix.3 + temporal_all$Cfix.4
Cfix_ave <- Cfix_ave/5

Nfix_ave <- temporal_all$Nfix + temporal_all$Nfix.1 + temporal_all$Nfix.2 + temporal_all$Nfix.3 + temporal_all$Nfix.4
Nfix_ave <- Nfix_ave/5

ATP_ave <- temporal_all$ATP + temporal_all$ATP.1 + temporal_all$ATP.2 + temporal_all$ATP.3 + temporal_all$ATP.4
ATP_ave <- ATP_ave/5

temporal_all <- cbind(temporal_all, Ci_ave, Ngas_ave, Ogas_ave, Cfix_ave, Nfix_ave, ATP_ave)

molecules = c('Ci', 'Ngas', 'Ogas', 'Cfix', 'Nfix', 'ATP')

library(ggplot2)
ggplot(data = temporal_all, aes(x = time)) + 
  geom_rect(aes(xmin=4680, xmax=8640, ymin=0, ymax=170), fill="grey", alpha=0.01) +
  geom_rect(aes(xmin=13320, xmax=17280, ymin=0, ymax=170), fill="grey", alpha=0.01) +
  geom_line(aes(y=Ci_ave), size = 1.7, color = 'blue', alpha = 1) + 
  geom_line(aes(y=Ngas_ave), size = 1.7, color = 'magenta', alpha = 1) + 
  geom_line(aes(y=Ogas_ave), size = 1.7, color = 'cyan', alpha = 1) + 
  geom_line(aes(y=Cfix_ave), size = 1.7, color = 'green', alpha = 1) + 
  geom_line(aes(y=Nfix_ave), size = 1.7, color = 'red', alpha = 1) + 
  geom_line(aes(y=ATP_ave), size = 1.7, color = 'orange', alpha = 1) + 
  geom_line(aes(y=Ci), color = 'blue', alpha = 0.2) + 
  geom_line(aes(y=Ngas), color = 'magenta', alpha = 0.2) + 
  geom_line(aes(y=Ogas), color = 'cyan', alpha = 0.2) + 
  geom_line(aes(y=Cfix), color = 'green', alpha = 0.2) + 
  geom_line(aes(y=Nfix), color = 'red', alpha = 0.2) + 
  geom_line(aes(y=ATP), color = 'orange', alpha = 0.2) +  
  geom_line(aes(y=Ci.1), color = 'blue', alpha = 0.2) + 
  geom_line(aes(y=Ngas.1), color = 'magenta', alpha = 0.2) + 
  geom_line(aes(y=Ogas.1), color = 'cyan', alpha = 0.2) + 
  geom_line(aes(y=Cfix.1), color = 'green', alpha = 0.2) + 
  geom_line(aes(y=Nfix.1), color = 'red', alpha = 0.2) + 
  geom_line(aes(y=ATP.1), color = 'orange', alpha = 0.2) + 
  geom_line(aes(y=Ci.2), color = 'blue', alpha = 0.2) + 
  geom_line(aes(y=Ngas.2), color = 'magenta', alpha = 0.2) + 
  geom_line(aes(y=Ogas.2), color = 'cyan', alpha = 0.2) + 
  geom_line(aes(y=Cfix.2), color = 'green', alpha = 0.2) + 
  geom_line(aes(y=Nfix.2), color = 'red', alpha = 0.2) + 
  geom_line(aes(y=ATP.2), color = 'orange', alpha = 0.2) + 
  geom_line(aes(y=Ci.3), color = 'blue', alpha = 0.2) + 
  geom_line(aes(y=Ngas.3), color = 'magenta', alpha = 0.2) + 
  geom_line(aes(y=Ogas.3), color = 'cyan', alpha = 0.2) + 
  geom_line(aes(y=Cfix.3), color = 'green', alpha = 0.2) + 
  geom_line(aes(y=Nfix.3), color = 'red', alpha = 0.2) + 
  geom_line(aes(y=ATP.3), color = 'orange', alpha = 0.2) + 
  geom_line(aes(y=Ci.4), color = 'blue', alpha = 0.2) + 
  geom_line(aes(y=Ngas.4), color = 'magenta', alpha = 0.2) + 
  geom_line(aes(y=Ogas.4), color = 'cyan', alpha = 0.2) + 
  geom_line(aes(y=Cfix.4), color = 'green', alpha = 0.2) + 
  geom_line(aes(y=Nfix.4), color = 'red', alpha = 0.2) + 
  geom_line(aes(y=ATP.4), color = 'orange', alpha = 0.2) + 
  xlab('time (s)') +
  ylab('Cytoplasmic molecules') +
  theme_minimal() + 
  theme(axis.title=element_text(size=16, colour = 'grey30'), axis.text=element_text(size=10))


  
ggplot(avg, aes(x=Gene, y=mean)) + 
  geom_point() + 
  geom_line() + 
  geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.1) +
  geom_line(data = ge, aes(x=Gene, y=Exp, group=Sample, colour="#000099"),
            show_guide = FALSE)
              




library(ggplot2)
ggplot(data = temporal, aes(time)) + 
  geom_smooth(aes(y=Ci), color = 'blue', level = 0.1) + 
  geom_smooth(aes(y=Ngas), color = 'pink', level = 0.1) + 
  geom_smooth(aes(y=Ogas), color = 'cyan', level = 0.1) + 
  geom_smooth(aes(y=Cfix), color = 'green', level = 0.1) + 
  geom_smooth(aes(y=Nfix), color = 'red', level = 0.1) + 
  geom_smooth(aes(y=ATP), color = 'orange', level = 0.1) + 
  theme_minimal() +
  scale_color_discrete(name = "Species", labels = c('Ci', 'Ngas', 'Ogas', 'Cfix', 'Nfix', 'ATP'))
