for(i in c(0:99)){
  
  Z[4*i+1, 2] <- sum(Model$Updated[[i+1]]==0)
  Z[4*i+1, 3] <- 0
  
  Z[4*i+2, 2] <-sum(Model$Updated[[i+1]]==1)
  Z[4*i+2, 3] <- 1
  
  Z[4*i+3, 2]<-sum(Model$Updated[[i+1]]==2)
  Z[4*i+3, 3]<- 2
  
  Z[4*i+4, 2]<- sum(Model$Updated[[i+1]]==3)
  Z[4*i+4, 3]<- 3
  
}
                                                                                                                                                                                                                                                                                                                                                                                           
#convert *.png -delay 3 -loop 0 binom.gif
matrixsummation2 <- function(A){ 
  dimensions <- dim(A)
  A1 <- data.frame(rep(0,dimensions[1]), A[1:dimensions[1],1:(dimensions[2]-1)])
  A2 <- data.frame(A[1:dimensions[1],2:dimensions[2]], rep(0,dimensions[1]))
  A3 <- t(data.frame(rep(0,dimensions[2]), t(A[1:(dimensions[1]-1),1:dimensions[2]])))
  A4 <- t(data.frame(t(A[2:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]) ))
  A5 <-  t(data.frame(rep(0,dimensions[2]), t(A1[1:(dimensions[1]-1),1:dimensions[2]])))
  A6 <-  t(data.frame(t(A2[2:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]) ))
  B1 <- data.frame(rep(0,dimensions[1]), rep(0,dimensions[1]),  A[1:dimensions[1],1:(dimensions[2]-2)])
  B2 <- data.frame(A[1:dimensions[1],3:dimensions[2]], rep(0,dimensions[1]),rep(0,dimensions[1]))
  B3 <- t(data.frame(rep(0,dimensions[2]),rep(0,dimensions[2]), t(A[1:(dimensions[1]-2),1:dimensions[2]])))
  B4 <- t(data.frame(t(A[3:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]),rep(0,dimensions[2]) ))
  B5 <-  t(data.frame(rep(0,dimensions[2]), rep(0,dimensions[2]), t(B1[1:(dimensions[1]-2),1:dimensions[2]])))
  B6 <-  t(data.frame(rep(0,dimensions[2]), rep(0,dimensions[2]), t(B2[1:(dimensions[1]-2),1:dimensions[2]])))
  B7 <-  t(data.frame(t(B2[3:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]),rep(0,dimensions[2]) ))
  B8 <-  t(data.frame(t(B1[3:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]),rep(0,dimensions[2]) ))
  B9 <-  t(data.frame(rep(0,dimensions[2]),  t(B1[1:(dimensions[1]-1),1:dimensions[2]])))
  B10 <-  t(data.frame(rep(0,dimensions[2]),  t(B2[1:(dimensions[1]-1),1:dimensions[2]])))
  B11 <-  t(data.frame(t(A2[3:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]),rep(0,dimensions[2]) ))
  B12 <-  t(data.frame(t(A1[3:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]),rep(0,dimensions[2]) ))
  
  B13 <-  t(data.frame(rep(0,dimensions[2]), rep(0,dimensions[2]), t(A1[1:(dimensions[1]-2),1:dimensions[2]])))
  
  B14 <-  t(data.frame(rep(0,dimensions[2]), rep(0,dimensions[2]), t(A2[1:(dimensions[1]-2),1:dimensions[2]])))
  B15 <-  t(data.frame(t(B2[3:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2])))
  B16 <-  t(data.frame(t(B1[3:dimensions[1],1:dimensions[2]]),rep(0,dimensions[2]) ))
  
  result <- data.matrix(A1+A2+A3+A4 +A5+A6 +B1 + B2 +  B3 + B4 + B5 + B6 + B7+ B8+ B9+ B10+ B11+B12+ B13 +B14+B15+B16)
  colnames(result) <-NULL
  return(result)
}