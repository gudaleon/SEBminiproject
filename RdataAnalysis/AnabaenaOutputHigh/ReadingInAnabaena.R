
GrandBudapest <- c("#009B77","#DD4124", "#D65076", "#45B8AC", "#EFC050", "#5B5EA6", "#9B2335", "#DFCFBE", "#55B4B0", "#E15D44", "#7FCDCD", "#BC243C", "#C3447A" )

t_col <- function(color, percent = 50, name = NULL) {
  
  #	  color = color name
  #	percent = % transparency
  #	   name = an optional name for the color
  
  ## Get RGB values for named color
  rgb.val <- col2rgb(color)
  
  ## Make new color using input color as base and alpha set by transparency
  t.col <- rgb(rgb.val[1], rgb.val[2], rgb.val[3],
               max = 255,
               alpha = (100-percent)*255/100,
               names = name)
  
  ## Save the color
  invisible(t.col)
  
}
GrandBudapest <- c("#009B77","#DD4124", "#D65076", "#45B8AC", "#EFC050", "#5B5EA6", "#9B2335", "#DFCFBE", "#55B4B0", "#E15D44", "#7FCDCD", "#BC243C", "#C3447A" )
per=80
TransparentGrandBudapest<-c( t_col("#009B77",per), t_col("#DD4124",per),  t_col("#D65076",per), t_col("#45B8AC",per), t_col("#EFC050",per), t_col("#5B5EA6",per), t_col("#9B2335",per), t_col("#DFCFBE",per), t_col("#55B4B0",per), t_col("#E15D44",per), t_col("#7FCDCD",per), t_col("#BC243C",per), t_col("#C3447A",per ))
result <- c()
DatafC <- data.frame(matrix(0, nrow=1001, ncol=3))
DatafN <- data.frame(matrix(0, nrow=1001, ncol=3))
DataHetero <- data.frame(matrix(0, nrow=1001, ncol=3))
DataLength <- data.frame(matrix(0, nrow=1001, ncol=3))
DataTime <- data.frame(matrix(0, nrow=1001, ncol=3))
DataPropn <- data.frame(matrix(0, nrow=1001, ncol=3))

library(readr)
library(dplyr)

Processing <- function(Name,i, extension='.csv'){
  path <- paste("~/Course_Materials/SEBminiproject/RdataAnalysis/AnabaenaOutputNormal/",Name, i, ".csv", sep = "")
  dataframe <- read_csv(path, col_names = FALSE, comment = ";", trim_ws = FALSE)
  dataframe[1,] <-  as.double(dataframe[1,])
  dataframe <- data.frame(t(dataframe))
  rownames(dataframe) <-c(1:nrow(dataframe))
  colnames(dataframe) <- c('Amount')
  if (Name!=time){
  dataframe$Quantity <- Name
  dataframe$Cell <- i}
}




AllCellsInfo <- data.frame(matrix(0, nrow=1, ncol=4))

colnames(AllCellsInfo) <- c("Amount",  "Quantity" ,"Cell"  , "Time")

for (i in c(1:35)) {

#Initalize list
CellAttributes <- list()
time <- Processing('time',i,'.csv')
for ( Name in c('fClev','fNlev','heterocysts','length','prhcy')){
  if(Name == 'prhcy'){ CellAttributes[[paste0(Name,i)]] <- Processing(Name, i, '.cvs') 
  CellAttributes[[paste0(Name,i)]] <- cbind( CellAttributes[[paste0(Name,i)]],time)
  } else { CellAttributes[[paste0(Name,i)]]   <-  Processing(Name, i, '.csv') 
  CellAttributes[[paste0(Name,i)]] <- cbind( CellAttributes[[paste0(Name,i)]],time)
  }
  colnames(CellAttributes[[paste0(Name,i)]]) <- c("Amount",  "Quantity" ,"Cell"  , "Time")
  AllCellsInfo <- rbind(AllCellsInfo, CellAttributes[[paste0(Name,i)]])
}

}


AllCellsInfo$Nitrogen <- 0

AllCellsInfo[AllCellsInfo$Cell %in% c(1:5),c('Nitrogen')] <- 0

AllCellsInfo[AllCellsInfo$Cell %in% c(6:10),c('Nitrogen')] <- 1
AllCellsInfo[AllCellsInfo$Cell %in% c(11:15),c('Nitrogen')] <- 2
AllCellsInfo[AllCellsInfo$Cell %in% c(16:20),c('Nitrogen')] <- 3
AllCellsInfo[AllCellsInfo$Cell %in% c(21:25),c('Nitrogen')] <- 4
AllCellsInfo[AllCellsInfo$Cell %in% c(26:30),c('Nitrogen')] <- 5
AllCellsInfo[AllCellsInfo$Cell %in% c(31:35),c('Nitrogen')] <- 6

#Averages
AllCellsInfo <-AllCellsInfo2

AllCellsInfo <- AllCellsInfo[AllCellsInfo$Quantity == 'prhcy',] 
P<- AllCellsInfo
LinearRegressionFunctions <- list()
for (i in c(0:6)) {Data <- AllCellsInfo[(AllCellsInfo$Nitrogen==i),c('Time', 'Amount')]
        Data$Amount <- as.double(Data$Amount)
        Data$Time <- as.double(Data$Time)
        LinearRegressionFunctions[[i+1]] <- lm(Amount~Time, data=Data)  }  

forplotting <- c(1:14)
forplotting <- as.factor(c(1:14))
FirstPlot <- ggplot(P, aes(x=Time, y=Amount, group=Cell, color=levels(forplotting)[Nitrogen+1])) + geom_line(data=P[P$Nitrogen<7, ]) + scale_color_manual(breaks =as.factor(c(1:14)), values=c(TransparentGrandBudapest[c(1:6)], GrandBudapest[7]))
FirstPlot


Plot = list()

P$Nitrogen <- P$Nitrogen+7
P <- rbind(P, AllCellsInfo)
Plot[[1]] <-  FirstPlot + geom_hline(aes(yintercept=LinearRegressionFunctions[[1]]$coefficients[1], color=forplotting[7]))

for(i in c(1:6)){ Plot[[i+1]] <- Plot[[i]] +  geom_abline(aes(slope=LinearRegressionFunctions[[i]]$coefficients[2] ,intercept=LinearRegressionFunctions[[i]]$coefficients[1], color=forplotting[i+1] )) }

