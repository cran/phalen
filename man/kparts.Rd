\name{kparts}
\alias{kparts}
\alias{plot.kparts}

\title{K-Partitions Clustering}
\description{Unsupervised vector partitioning.}
\usage{
kparts(x, y, parts, maxiter = 50, trials = 3, 
       nblind = FALSE, trialprint = TRUE, iterprint = FALSE)
}

\arguments{
  \item{x}{The numeric vector to be partitioned.}
  \item{y}{The numeric response variable vector used to partition vector \code{x}.}
  \item{parts}{The desired number of partitions.}
  \item{maxiter}{The maximum number of iterations allowed for each \code{trial}.  If convergence does not occur, the \code{trail} will stop after the specified number of iterations is reached. The default is \code{50} iterations.}
  \item{trials}{The number of times the algorithm is run with new, randomly assigned partitions.  The default number of \code{trials} is \code{3}.}
  \item{nblind}{If \code{TRUE}, the algorithm will ignore the sum of squares within each unique value of \code{x}. The default is \code{FALSE}.}
  \item{trialprint}{If \code{TRUE}, the \code{trial} number and the sum of squares will print while the algorithm is running.  The default is \code{TRUE}.}
  \item{iterprint}{If \code{TRUE}, the iteration number and sum of squares will print while the algorithm is running.  The default is \code{FALSE}.}
}
\details{
\code{kparts} finds the best contiguous partitions for \code{x} by minimizing the sum of squares of \code{y}.  

The sum of squares for a unique value of \code{x} cannot be partitioned, which has the effect of weighting unique values of \code{x} by the number observations at those values.  Using \code{nblind = "FALSE"} cause \code{kparts} to ignore the number of observations and treat all \code{x} values as equally weighted.

\code{kparts} can take a long time to process datasets with large numbers of unique \code{x} values.  To gain efficiency, pre-processing vector \code{x} by binning is recommended.  
}


\value{
\item{partitions}{A data frame naming the index of the partition and the range \code{x} over which the partition extends.}
\item{data}{ A data frame containing the partition index (parts), the unique values of \code{x}, the average of \code{y} and the range of the partition.}}
\author{Robert P. Bronaugh}
\note{In later versions, \code{kparts} will be updated to allow for a matrix of data as \code{y} input.}

\examples{
  # plot readmission rates against age. 
  data(ipadmits)
  attach(ipadmits)
  ipadmits.summary = data.frame("AvgReadmission" = tapply(ipadmits$isReadmission
                                                          ,ipadmits$Age
                                                          ,mean)
                                ,"AvgCost" = tapply(ipadmits$cost
                                                    ,ipadmits$Age
                                                    ,mean))
  plot(ipadmits.summary$AvgReadmission,xlab = "Age",ylab = "AvgReadmission")
  
  
  # find the best partitions of age against readmission rate. 
  # run kparts with 4 trials with 5 partitions
  kp = kparts(x = ipadmits$Age,y = ipadmits$isReadmission,parts = 5,trials = 4)
  # list value range for each partition
  kp$partitions
  plot(kp)
  # run with 7 partitions and ignore number of samples per age
  # when computing error
  kp = kparts(ipadmits$Age,ipadmits$isReadmission,parts = 7,trials = 5,nblind = TRUE)
  kp$partitions
  plot(kp)
  detach(ipadmits)
}

\keyword{ unsupervised }
\keyword{ clustering }
