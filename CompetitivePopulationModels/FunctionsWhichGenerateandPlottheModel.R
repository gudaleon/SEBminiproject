library(reshape2)
library(ggplot2)

matrixsummation <- function(m){
  result <- array(sapply(seq_along(m), function(i) {
      ind <- which(col(m) == col(m)[i] & abs(row(m)[i] - row(m)) == 1 | 
                 row(m) == row(m)[i] & abs(col(m)[i] - col(m)) == 1)
      sum(m[ind])
  }), dim(m))
return(result)
}

matrixcreator <-function(){
  LikelihoodMap <- list()
  LikelihoodMap[[1]] <- matrix(0.2, nrow = 10, ncol = 10)
  LikelihoodMap[[2]] <- matrix(0.1, nrow = 10, ncol = 10)
  LikelihoodMap[[3]] <- matrix(0.1, nrow = 10, ncol = 10)
  LikelihoodMap[[4]] <- matrix(0.01, nrow = 10, ncol = 10)
  LikelihoodMap[[5]] <- matrix(0.01, nrow = 10, ncol = 10)
  LikelihoodMap[[6]] <- matrix(0.01, nrow = 10, ncol = 10)
  
  StartingMatrix <- matrix(0, nrow = 10, ncol = 10)
  StartingMatrix[1,1] <- 1 
  StartingMatrix[1,2] <- 2
  StartingMatrix[1,3] <- 3
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
      }
  
  return(CurrentMatrix)
}

modelplotter<- function(){ 
  melted_cormat <- melt(CurrentMatrix)
  ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + geom_tile() }