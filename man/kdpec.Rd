\name{kdpec}
\alias{kdpec}

\title{K-Dimensional Partitioned Episodic Clustering
}
\description{Overlapping or sudo-overlapping observation clustering within k-dimensional partitions.}
\usage{
kdpec(id, kdim, startdate, enddate, 
      slack = 0, restartindex = FALSE)
}
\arguments{
  \item{id}{A vector or data.frame representing a unique identifier or key.}
  \item{kdim}{A vector or data.frame representing a "k-dimensional" index across which clusters cannot be formed.}
  \item{startdate}{A date vector of each observation's start date.}
  \item{enddate}{A date vector of each observation's end date.}
  \item{slack}{a positive numeric value representing the gap in days over which a cluster can be formed.  the default is \code{0}.}
  \item{restartindex}{If \code{TRUE}, the squential cluster IDs will restart at \code{1} within each k-dimensional partition.}}
\value{
\code{kdpec} returns a data.frame with the column or group of columns used to uniquely identify each observation along with the following:

\item{kdimidx}{K-Dimensional Index. A sequential ID indexing each k-dimensional set.}
\item{episode}{A sequential ID indexing each episodic cluster.}
}

\author{Robert P. Bronaugh}

\examples{
\dontrun{
  # merge a patient's claims for a specific diagnosis together:
  # use kdim to prevent episode clustering across patient and diagnosis
  # (i.e.,) the combination of PatientID and Diagnosis become a partition
  # across which episodic clusters cannot be formed). 
  # restartindex = TRUE starts the episode index over at 1 for each k-dimensional partition
  data(epclaims)
  attach(epclaims)
  require(sqldf)
  kd = kdpec(id = epclaims$ClaimNumber,kdim = cbind(epclaims$PatientID,epclaims$Diagnosis)
            ,startdate = epclaims$ServiceStart,enddate = epclaims$ServiceEnd
            ,restartindex=TRUE)
  
  # print the id, k-dimensional partition index (kdimidx), and the episodes
  print(kd)
  
  # restartindex = FALSE 
  kd = kdpec(epclaims$ClaimNumber,cbind(epclaims$PatientID,epclaims$Diagnosis),
             epclaims$ServiceStart,epclaims$ServiceEnd,restartindex=FALSE)
  print(kd)
  
  # merge episode indexes with original data 
  ep.2 = sqldf("SELECT  ep.PatientID
               ,ep.ClaimNumber
               ,ep.Diagnosis
               ,ep.ServiceStart
               ,ep.ServiceEnd
               ,kd.kdimidx
               ,kd.episode
               FROM    epclaims ep
               INNER JOIN kd
               ON ep.ClaimNumber = kd.id")
  
  
  # plot time spans of original records
  washcol = wash("gry",0.8)
  for (i in 1:nrow(epclaims)) {
    if (i ==1) {
      plot(c(epclaims$ServiceStart[i],epclaims$ServiceEnd[i]),rep(i,2)
           ,type="l", col = washcol, lwd = 3
           ,xlim = c(min(epclaims$ServiceStart)-3
                     ,max(epclaims$ServiceStart)+3)
           ,ylim = c(0,15)
           ,xlab = "length of service"
           ,ylab = "claim record index")
    } else if (i < 6) {
      lines(c(epclaims$ServiceStart[i],epclaims$ServiceEnd[i])
            ,rep(i,2),col = washcol, lwd = 3) 
    } else if ( i < 10) {
      lines(c(epclaims$ServiceStart[i],epclaims$ServiceEnd[i])
            ,rep(i,2),col = washcol, lwd = 3) 
    } else if (i == 10) {
      lines(c(epclaims$ServiceStart[i],epclaims$ServiceEnd[i])
            ,rep(i,2),col = washcol, lwd = 3) 
    } else {
      lines(c(epclaims$ServiceStart[i],epclaims$ServiceEnd[i])
            ,rep(i,2),col = washcol, lwd = 3) 
    }
  }
  
  # plot time spans of original records.  Color by assigned k-dim index
  washcol = c(wash("blu1",1),wash("grn2",1),wash("org",1),wash("red1",1))
  for (i in 1:nrow(ep.2)) {
    if (i ==1) { 
      plot(c(ep.2$ServiceStart[i],ep.2$ServiceEnd[i]),rep(i,2)
           ,type="l", col = washcol[ep.2$kdimidx[i]], lwd = 3
           ,xlim = c(min(ep.2$ServiceStart)-3,max(ep.2$ServiceStart)+3)
           ,ylim = c(0,15)
           ,xlab = "length of service"
           ,ylab = "claim record index")
    } else if (i < 6) {
      lines(c(ep.2$ServiceStart[i],ep.2$ServiceEnd[i]),rep(i,2)
            ,col = washcol[ep.2$kdimidx[i]], lwd = 3) 
    } else if ( i < 10) {
      lines(c(ep.2$ServiceStart[i],ep.2$ServiceEnd[i]),rep(i,2)
            ,col = washcol[ep.2$kdimidx[i]], lwd = 3) 
    } else if (i == 10) {
      lines(c(ep.2$ServiceStart[i],ep.2$ServiceEnd[i]),rep(i,2)
            ,col = washcol[ep.2$kdimidx[i]], lwd = 3) 
    } else {
      lines(c(ep.2$ServiceStart[i],ep.2$ServiceEnd[i]),rep(i,2)
            ,col = washcol[ep.2$kdimidx[i]], lwd = 3) 
    }
  }
  
  # merge records to get the full length of each episode
  ep.episodes = data.frame("kdimidx" = tapply(ep.2$kdimidx,ep.2$episode,min),
                           "episodeStart" = as.Date(tapply(ep.2$ServiceStart
                              ,ep.2$episode,min),origin = "1970-01-01"),
                           "episodeEnd" = as.Date(tapply(ep.2$ServiceEnd
                              ,ep.2$episode,max),origin = "1970-01-01"))
  
  # plot the length of service of each episode.  kdimidx, not claim 
  # records, are on the y axis colors represent each kdimidx
  washcol = c(wash("blu1",1),wash("grn2",1),wash("org",1),wash("red1",1))
  i = 1
  for (i in 1:nrow(ep.episodes)) {
    if (i ==1) {
      plot(c(ep.episodes$episodeStart[i],ep.episodes$episodeEnd[i])
            ,rep(ep.episodes$kdimidx[i],2)
           ,type="l", col = washcol[ep.episodes$kdimidx[i]], lwd = 3
           ,xlim = c(min(ep.2$ServiceStart)-3,max(ep.2$ServiceStart)+3)
           ,ylim = c(0,4)
           ,xlab = "length of episode"
           ,ylab = "k-dimensional index")
    } else if (i < 6) {
      lines(c(ep.episodes$episodeStart[i],ep.episodes$episodeEnd[i])
            ,rep(ep.episodes$kdimidx[i],2)
            ,col = washcol[ep.episodes$kdimidx[i]], lwd = 3) 
    } else if ( i < 10) {
      lines(c(ep.episodes$episodeStart[i],ep.episodes$episodeEnd[i])
            ,rep(ep.episodes$kdimidx[i],2)
            ,col = washcol[ep.episodes$kdimidx[i]], lwd = 3) 
    } else if (i == 10) {
      lines(c(ep.episodes$episodeStart[i],ep.episodes$episodeEnd[i])
            ,rep(ep.episodes$kdimidx[i],2)
            ,col = washcol[ep.episodes$kdimidx[i]], lwd = 3) 
    } else {
      lines(c(ep.episodes$episodeStart[i],ep.episodes$episodeEnd[i])
            ,rep(ep.episodes$kdimidx[i],2)
            ,col = washcol[ep.episodes$kdimidx[i]], lwd = 3) 
    }
  }
  detach(epclaims)
}
  
}
