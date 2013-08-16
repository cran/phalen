

\name{basher}
\alias{basher}

\title{Basher Penalty}
\description{Growth and decay penalties for numeric vectors.}
\usage{
basher(X, A, K)
}

\arguments{
  \item{X}{A numeric vector.}
  \item{A}{The value at which the penalty starts.}
  \item{K}{The asymptotic ceiling or floor of penalized vector \code{X}.}
}
\details{
To create a growth penalty, where values greater than \code{A} are penalized, \code{K} must be greater than \code{A}.  The growth penalty is \code{K(1-exp(-r(X-M))))} for all values of \code{X} greater than \code{A}. 

To create a decay penalty, where values less than \code{A} are penalized, \code{K} must be less than \code{A}. The decay penalty is \code{K(1+exp(r(X-M)))} for all values of \code{X} less than \code{A}.
}
\value{
\code{basher} returns an object of class "\code{basher}."

\item{y }{The numeric vector \code{X} with penalities applied.}
\item{A }{The value at which the penalty starts.}
\item{K }{The asymptotic ceiling or floor of penalized vector \code{X} (i.e., \code{y}).}
\item{r }{The growth or decay rate of the penalty.}
\item{M }{An extra parameter set so that \code{y} = \code{X} at \code{A}.}
\item{penalty }{The type of penalty applied.}
}

\author{Robert P. Bronaugh}

\examples{
  # get the inpatient cost per day, sorted
  data(ipadmits)
  attach(ipadmits)
  ipc = sort(ipadmits$cost)
  plot(ipc,type = "l",col = wash("gry",0.8),lwd=3)
  
  # apply penalty starting 2000. Penalized value not to exceed 4500
  ipc.bash = basher(X = ipc, A = 2000, K = 4500)
  lines(ipc.bash$y,col = wash("blu1",1),lwd = 3)
  plot(ipc,ipc,type = "l",col = wash("gry",0.8),lwd=3)
  lines(ipc,ipc.bash$y,col = wash("blu1",1),lwd = 3)
  
  # apply lower penalty ending at 1500.  Penalized value floor = 500
  ipc.bash = basher(X = ipc, A = 1500, K = 500)
  plot(ipc,type = "l",col = wash("gry",0.8),lwd=3)
  lines(ipc.bash$y,col = wash("blu1",1),lwd = 3)
  plot(ipc,ipc,type = "l",col = wash("gry",0.8),lwd=3)
  lines(ipc,ipc.bash$y,col = wash("blu1",1),lwd = 3)
  
  # combine above ceiling and floor penalties
  ipc.bash = basher(X = ipc, A = 2000, K = 4500)
  ipc.bash = basher(X = ipc.bash$y, A = 1500, K = 500)
  
  plot(ipc,type = "l",col = wash("gry",0.8),lwd=3)
  lines(ipc.bash$y,col = wash("blu1",1),lwd = 3)
  plot(ipc,ipc,type = "l",col = wash("gry",0.8),lwd=3)
  lines(ipc,ipc.bash$y,col = wash("blu1",1),lwd = 3)
  detach(ipadmits)
}
\keyword{ penalty }
\keyword{ growth }
\keyword{ decay }