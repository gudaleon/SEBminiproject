


DatafC <- data.frame(matrix(0, nrow=1001, ncol=15))
library(readr)
library(dplyr)

for (i in c(11:15)) {
fC <- paste("~/Course_Materials/SEBminiproject/RdataAnalysis/AnabaenaOutputHigh/fClev", i, ".csv", sep = "")


fClev <- read_csv(fC, col_names = FALSE, comment = ";", trim_ws = FALSE)
fClev <- as.data.frame(t(fClev))
fClev <- as.data.frame(fClev[,1])
DatafC[,i] <- fClev
colnames(DatafC)[i] <- paste("fClevel", i, sep = "")
}
