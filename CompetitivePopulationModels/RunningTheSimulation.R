source("FunctionsWhichGenerateandPlottheModel.R")
library(readr)
#library(printr)

LakeSPhosphate <- read_csv("../MatlabModels/LakeSPhosphate.csv",col_names=FALSE)
LakeSNitrogen <- read_csv("../MatlabModels/LakeSNitrogen.csv",col_names=FALSE)
LakeSLight <- read_csv("../MatlabModels/LakeSLight.csv",col_names=FALSE)
LakeSLight<-LakeSLight^3-60

Birthratespatial <- 0.79*(LakeSPhosphate/(LakeSPhosphate+4))*(LakeSNitrogen/(LakeSNitrogen+4))*(LakeSLight/(LakeSLight+2.5))
Birthratetemporal <- 2*(LakeSPhosphate/(LakeSPhosphate+11.5))*(LakeSNitrogen/(LakeSNitrogen+10))*(LakeSLight/(LakeSLight+3.98))
Birthrateheterotroph <- 0.75*(LakeSPhosphate/(LakeSPhosphate+8))*(LakeSNitrogen/(LakeSNitrogen+0.5))*(LakeSLight/(LakeSLight+4.03))

LikelihoodMap <- list()
LikelihoodMap[[1]] <- data.matrix(Birthratespatial[1:100,1:100], rownames.force = NA )
colnames(LikelihoodMap[[1]]) <- NULL
LikelihoodMap[[2]] <- data.matrix(Birthratetemporal[1:100,1:100], rownames.force = NA )
colnames(LikelihoodMap[[2]]) <- NULL
LikelihoodMap[[3]] <- data.matrix(Birthrateheterotroph[1:100,1:100], rownames.force = NA )
colnames(LikelihoodMap[[3]]) <- NULL
LikelihoodMap[[4]] <- matrix(0.01, nrow = 100, ncol = 100)
LikelihoodMap[[5]] <- matrix(0.01, nrow = 100, ncol = 100)
LikelihoodMap[[6]] <- matrix(0.01, nrow = 100, ncol = 100)


#randomising the starting matrix 
RandomMatrix <- matrix(runif(100*100, min = 0, max = 1),100,100)
StartingMatrix <- matrix(0, nrow = 100, ncol = 100)
StartingMatrix[RandomMatrix<0.15] <- 1
StartingMatrix[RandomMatrix<0.1] <- 2
StartingMatrix[RandomMatrix<0.05] <- 3

#uncomment to plot 
##melted_cormat <- melt(StartingMatrix)
##ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=as.factor(value))) + geom_tile()


Model <- modelsimulator(StartingMatrix, LikelihoodMap, 100)

write.csv(Model$finalmatrix, file="FinalResult.txt")
write.csv(Model$Updated, file="Allthesteps.txt")
