ReadParams <- function(input) {
  D$beta <- input$beta
  D$run_n <- input$run_n
  D$time_points <- input$time_points
  D$I0 <- input$I0
  D$N <- input$N
  D$vacc <- floor(input$vacc*D$N)
  D$show_s <- input$show_s
  D$show_i <- input$show_i
  D$show_r <- input$show_r
  D$show_u <- input$show_u
  if (D$I0+D$vacc>D$N) {
    showModal(modalDialog(title="Error","Initial population exceeds unvaccinated population size."))
    D$err<-T
  }
}

DoRun <- function(N,time_points,vacc,I0,beta) {
  I <- R <- array(0,N)
  R[1:(vacc+I0)] <- 1
  SS <- II <- RR <- array(0,time_points)
  II[1] <- I0
  RR[1] <- 0
  SS[1] <- N-I0-vacc
  for (t in 2:time_points) {
    R <- R + I
    I <- I*0
    q <- rpois(1,beta*II[t-1])
    if (q) for (i in 1:q) {
      j <- sample(1:N,1)
      if (I[j]+R[j]<1) I[j]<-1
    }
    II[t] <- sum(I)
    RR[t] <- sum(R)-vacc
    SS[t] <- N-II[t]-RR[t]-vacc
  }
  return(cbind(SS,II,RR))
}

RunModel <- function() {
  D$res <- replicate(D$run_n,DoRun(D$N,D$time_points,D$vacc,D$I0,D$beta))
}

FinalX <- function(x) {
  d <- dim(D$res)
  mean(D$res[d[1],x,])
}

randCol <- function(lR,hR,lG,hG,lB,hB) {
    R <- sample(lR:hR,1)
    G <- sample(lG:hG,1)
    B <- sample(lB:hB,1)
    rgb(R/255,G/255,B/255)
}

DrawGraph <- function() {
  d <- dim(D$res)
  d.mean <- apply(D$res,c(1,2),mean)
  print(d.mean)
  plot(1:(d[1]),array(0,d[1]),type="n",xlab="run time",cex.lab=1.75,ylab="population",ylim=c(0,D$N))
  for (i in 1:(d[3])) {
    if (D$show_s) lines(1:(d[1]),D$res[,1,i],type="o",col=randCol(0,20,0,20,64,255))
    if (D$show_i) lines(1:(d[1]),D$res[,2,i],type="o",col=randCol(64,255,0,20,0,20))
    if (D$show_r) lines(1:(d[1]),D$res[,3,i],type="o",col=randCol(0,20,0,64,0,20))
  }
  if (D$show_u) {
    lines(1:(d[1]),d.mean[,1],type="l",col="#8888FF",lwd=3)
    lines(1:(d[1]),d.mean[,2],type="l",col="#FF8888",lwd=3)
    lines(1:(d[1]),d.mean[,3],type="l",col="#88FF88",lwd=3)
  }
  if (D$vacc>0) rect(0,D$N*(1-D$vacc)/100,D$time_points+1,D$N,col="#dddddd",lty="blank")
}

