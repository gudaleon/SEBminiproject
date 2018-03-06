library(reshape2)
library(ggplot2)
library(caTools) 
library(pixelmap)
library("colorspace") 
library("dplyr")

matrixsummation <- function(m){
  result <- array(sapply(seq_along(m), function(i) {
      ind <- which(col(m) == col(m)[i] & abs(row(m)[i] - row(m)) == 1 | 
                 row(m) == row(m)[i] & abs(col(m)[i] - col(m)) == 1)
      sum(m[ind])
  }), dim(m))
return(result)
}

matrixcreator <-function(){
  lakeS <- read.csv(file="../MatlabModels/mylake.txt", head=FALSE) 

  
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
  LikelihoodMap[[1]] <- matrix(0.1, nrow = 10, ncol = 10)
  LikelihoodMap[[2]] <- matrix(0.1, nrow = 10, ncol = 10)
  LikelihoodMap[[3]] <- matrix(0.1, nrow = 10, ncol = 10)
  LikelihoodMap[[4]] <- matrix(0.01, nrow = 10, ncol = 10)
  LikelihoodMap[[5]] <- matrix(0.01, nrow = 10, ncol = 10)
  LikelihoodMap[[6]] <- matrix(0.01, nrow = 10, ncol = 10)
  
  StartingMatrix <- matrix(0, nrow = 12, ncol = 12)
  StartingMatrix[1:2,1] <- 1 
  StartingMatrix[1:2,5] <- 2
  StartingMatrix[1:2,10] <- 3
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
  
  melted <- melt(CurrentMatrix)
  melted$Var0 <- 0
  Updated <- melted
  
    for(i in c(1:NumberofTrials)){

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
      
      print(CurrentMatrix)
      #This bit can be commented out to increase efficiency but stops the output of the video
      melted <- melt(CurrentMatrix)
      melted$Var0 <- i
      Updated <- rbind(Updated, melted)
    }
  
  return <-  list("finalmatrix"=CurrentMatrix, "Updated"=Updated)

  return(return)
}

finalstepmodelplotter<- function(Model){
  
  CurrentMatrix <- Model$finalmatrix
  melted_cormat <- melt(CurrentMatrix)
  colnames(melted_cormat) <- c(firstindex, secondindex, color)
  Stuff <- cbind(melted_cormat, melt(data.matrix(lakeS,  rownames.force = NA)))
  pal1 <- choose_palette()
  pal2 <- choose_palette()
  pal3 <- choose_palette()
  pal4 <- choose_palette()
  Stuff$colorchoice <- "color"
  Stuff[Stuff$color==0,c('colorchoice')] <- pal1(n=50)[ceiling(10*(Stuff[Stuff$color==0,c('value')]+2))]
  Stuff[Stuff$color==1,c('colorchoice')] <- pal2(n=50)[ceiling(10*(Stuff[Stuff$color==1,c('value')]+2))]
  Stuff[Stuff$color==2,c('colorchoice')] <- pal3(n=50)[ceiling(10*(Stuff[Stuff$color==2,c('value')]+2))]
  Stuff[Stuff$color==3,c('colorchoice')] <- pal4(n=50)[ceiling(10*(Stuff[Stuff$color==3,c('value')]+2))]
  
  x<-pixmapIndexed(data=c(1:144), nrow=12, ncol=12, col=Stuff$colorchoice)

  x<- pixmapIndexed(data=c(1:144), nrow=12, ncol=12, col= pal1(n=50)[ceiling(10*(Stuff[,c('value')]+2))] )
  
  }