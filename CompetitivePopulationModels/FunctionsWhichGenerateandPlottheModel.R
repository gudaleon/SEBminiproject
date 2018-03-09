library(reshape2)
library(ggplot2)
library(caTools) 
library(pixmap)
library(colorspace) 
library(dplyr)
library(data.table)

matrixsummation2 <- function(m){
  result <- array(sapply(seq_along(m), function(i) {
      ind <- which(col(m) == col(m)[i] & abs(row(m)[i] - row(m)) == 1 | 
                 row(m) == row(m)[i] & abs(col(m)[i] - col(m)) == 1)
      sum(m[ind])
  }), dim(m))
return(result)
}

matrixsummation <- function(A){ 
  dimensions <- dim(A)
  A1 <- data.frame(rep(0,dimensions[1]), A[1:dimensions[1],1:(dimensions[2]-1)])
  A2 <- data.frame(A[1:dimensions[1],2:dimensions[2]], rep(0,dimensions[1]))
  A3 <- t(data.frame(rep(0,dimensions[2]), t(A[1:(dimensions[1]-1),1:dimensions[2]])))
  A4 <- t(data.frame(t(A[2:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]) ))
  A5 <-  t(data.frame(rep(0,dimensions[2]), t(A1[1:(dimensions[1]-1),1:dimensions[2]])))
  A6 <-  t(data.frame(t(A2[2:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]) ))
  result <- data.matrix(A1+A2+A3+A4 +A5+A6)
  colnames(result) <-NULL
  return(result)
}
matrixcreator <-function(){
  lakeS <- read.csv(file="../MatlabModels/mylake.txt", heaFALSE) 

  
  LikelihoodMap <- list()
  LikelihoodMap[[1]] <- data.matrix((lakeS +  matrix(0.5, nrow=12, ncol=12))/10, rownames.force = NA)
  colnames(LikelihoodMap[[1]]) <- NULL
  LikelihoodMap[[2]] <- data.matrix((lakeS +  matrix(0.5, nrow=12, ncol=12))/10, rownames.force = NA )
  colnames(LikelihoodMap[[2]]) <- NULL
  LikelihoodMap[[3]] <- data.matrix((lakeS +  matrix(0.5, nrow=12, ncol=12))/9, rownames.force = NA )
  colnames(LikelihoodMap[[3]]) <- NULL
  LikelihoodMap[[4]] <- matrix(0.01, nrow = 12, ncol = 12)
  LikelihoodMap[[5]] <- matrix(0.01, nrow = 12, ncol = 12)
  LikelihoodMap[[6]] <- matrix(0.01, nrow = 12, ncol = 12)
  
  LikelihoodMap <- list()
  LikelihoodMap[[1]] <- matrix(0.5, nrow = 1000, ncol = 1000)
  LikelihoodMap[[2]] <- matrix(0.5, nrow = 1000, ncol = 1000)
  LikelihoodMap[[3]] <- matrix(0.6, nrow = 1000, ncol = 1000)
  LikelihoodMap[[4]] <- matrix(0.01, nrow = 1000, ncol = 1000)
  LikelihoodMap[[5]] <- matrix(0.01, nrow = 1000, ncol = 1000)
  LikelihoodMap[[6]] <- matrix(0.01, nrow = 1000, ncol = 1000)
  
  StartingMatrix <- matrix(0, nrow = 1000, ncol = 1000)
  StartingMatrix[1:100,1] <- 1 
  StartingMatrix[1:100,500] <- 2
  StartingMatrix[1:100,100] <- 3
}


modelsimulator <- function(StartingMatrix, LikelihoodMap, NumberofTrials){ 
  #Startingmatrix is the matrix of the initial colonies in map.
  #LikelihoodMap is 6 distinct matrices first 3 contain probaility of birth of an individual from population 1:3 
    #the next three contain probability of death of an individual from populations 1:3 
    #its a list data structure with the birth and death rates 
  #initialising current matrix 
  CurrentMatrix = StartingMatrix
  dimensions <- dim(StartingMatrix)
  Ones <- matrix(1, dimensions[1], dimensions[2])
  
  Updated <- list()
  Updated[[1]] <- CurrentMatrix
  
    for(i in c(1:NumberofTrials)){
      print(i)
      FreeSpots <- (CurrentMatrix==0)
      PopulationA <- (CurrentMatrix==1)
      PopulationB <- (CurrentMatrix==2)
      PopulationC <- (CurrentMatrix==3)
      
      #Birth Step      
      LikelihoodofPopA <- matrixsummation(PopulationA*LikelihoodMap[[1]])*FreeSpots
      LikelihoodofPopB <- matrixsummation(PopulationB*LikelihoodMap[[2]])*FreeSpots
      LikelihoodofPopC <- matrixsummation(PopulationC*LikelihoodMap[[3]])*FreeSpots
      
      
      Normaliser <- matrixsummation(Ones)
      
      LikelihoodofPopA <- LikelihoodofPopA/Normaliser
      LikelihoodofPopB <- LikelihoodofPopB/Normaliser
      LikelihoodofPopC <- LikelihoodofPopC/Normaliser
      
      RandomNumbers <- matrix(runif(dimensions[1]*dimensions[2], min = 0, max = 1),dimensions[1],dimensions[2])
      
      CurrentMatrix[RandomNumbers < LikelihoodofPopA + LikelihoodofPopB + LikelihoodofPopC] <- 3     
      CurrentMatrix[RandomNumbers < LikelihoodofPopA + LikelihoodofPopB] <- 2      
      CurrentMatrix[RandomNumbers < LikelihoodofPopA] <- 1 
      
      #Death Step
      LikelihoodofDeath <- PopulationA*LikelihoodMap[[4]] + PopulationB*LikelihoodMap[[5]] + PopulationC*LikelihoodMap[[6]]
      RandomNumbers <- matrix(runif(dimensions[1]*dimensions[2], min = 0, max = 1),dimensions[1],dimensions[2])
      CurrentMatrix[ RandomNumbers < LikelihoodofDeath]<-0 
      
      #print(CurrentMatrix)
      #This bit can be commented out to increase efficiency but stops the output of the video
      melted <- melt(CurrentMatrix)
      melted$Var0 <- i
      Updated[[i+1]] <- CurrentMatrix
    }
  
  return <-  list("finalmatrix"=CurrentMatrix, "Updated"=Updated)

  return(return)
}

finalstepmodelplotter<- function(Model){
  
  colfunc <- colorRampPalette(c("#f1bb7b","#000000"))
  pal1 <- colfunc(50)
  colfunc <- colorRampPalette(c("#a2ddd5","#225d56"))
  pal2 <- colfunc(50)
  colfunc <- colorRampPalette(c("#eea091","#6e2012"))
  pal3 <- colfunc(50)
  colfunc <- colorRampPalette(c("#adaed2","#2d2f53"))
  pal4 <- colfunc(50)
  
  for(i in c(1:100)){
  CurrentMatrix <- Model$Updated[[i]]
  melted_cormat <- melt(matrixsummation(Model$Updated[[i]]==1)+(Model$Updated[[i]]==1))
  colnames(melted_cormat) <- c('firstindex', 'secondindex', 'color')
  Stuff <- cbind(melted_cormat, melt(data.matrix(LakeSPhosphate[1:100,1:100],  rownames.force = NA)))
  Stuff$colorchoice <- "color"
  Stuff$colorchoice <- pal4[4*Stuff$color+1]
  #Stuff[Stuff$color==0,c('colorchoice')] <- pal1[ceiling(4*(Stuff[Stuff$color==0,c('value')]-9))]
  #Stuff[Stuff$color==1,c('colorchoice')] <- pal2[ceiling(4*(Stuff[Stuff$color==1,c('value')]-9))]
  #Stuff[Stuff$color==2,c('colorchoice')] <- pal3[ceiling(4*(Stuff[Stuff$color==2,c('value')]-9))]
  #Stuff[Stuff$color==3,c('colorchoice')] <- pal4[ceiling(4*(Stuff[Stuff$color==3,c('value')]-9))]
  
  x[[i]]<-pixmapIndexed(data=c(1:(100*100)), nrow=100, ncol=100, col=Stuff$colorchoice,cellres=1)
  
  png(paste0('plot',format(i/100, nsmall=3),'.png'))
  plot(x[[i]])
  dev.off()}


  
  }