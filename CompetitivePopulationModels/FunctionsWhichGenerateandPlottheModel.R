library(reshape2)
library(ggplot2)
library(caTools) 

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
  #p <- ggplot(data =  melt(data.matrix(lakeS,  rownames.force = NA)),aes(x=Var1, y=Var2, fill=as.factor(value))) + geom_tile() + theme(legend.position="none")

  ggplot(data = Stuff, aes(x=Var1, y=Var2, fill=color)) + geom_tile() 

  
  #p + ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=as.factor(value))) + geom_tile()  +
    #scale_fill_manual(values=c(t_col("white", perc=100),t_col("#999999", perc=50), t_col("#E69F00", perc=50), t_col("#56B4E9", perc=50)))  + theme(legend.position="none")
  }