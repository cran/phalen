\name{qqrank}
\alias{qqrank}
\title{Load-Deviance Ranking}
\description{Rank by size and deviance from the hypothesized mean.}
\usage{qqrank(X, INDEX, alternative = c("two.sided", "less", "greater"), 
       absrank = TRUE, N = NA, b = NA, plotpenalty = TRUE, 
       allowed.error = 0.005)}

\arguments{
  \item{X}{A numeric vector.}
  \item{INDEX}{A factor of length \code{X}.}
  \item{alternative}{The alternative hypothesis.  Accepts \code{"two.sided"}, \code{"less"}, or \code{"greater"}.}
  \item{absrank}{If \code{TRUE}, \code{INDEX} means greater than or less than the population mean will produce a positive \code{qqscore}.  If \code{FALSE}, \code{INDEX} means greater than the population mean will have a positive \code{qqscore} and \code{INDEX} means less than the population mean will have a negative \code{qqscore}. The default is \code{TRUE}.}
  \item{N}{The number of observations below which a growth penalty is applied. \code{N} is passed to \code{x1} argument of \code{glpenalty}.}
  \item{b}{A positive numeric value representing the growth rate of the \code{glpenalty}.}
  \item{plotpenalty}{If \code{TRUE}, the \code{glpenalty} is plotted.  The default is \code{TRUE}.}
  \item{allowed.error}{The allowed difference between \code{glpenalty} and \code{1} at \code{N}.  The default is \code{0.005}.}
}
\details{
\code{qqrank} ranks by size and deviance from the hypothesized mean using either the Binomial Test or Welch's t-Test.  Restated, \code{qqrank} is a function of a size penalty, test statistic or variant thereof, and p-value. 
}
\value{
\item{qqrankmatrix}{A data frame containing the size, mean, standard deviation, and qqrank of each \code{INDEX}.}
\item{test.used}{The statistical test used to measure deviance from the mean.}
\item{pop.mean}{The mean of \code{X}.}
\item{pop.sd}{The standard deviation of \code{X}.}
}

\author{
Robert P. Bronaugh
}

\seealso{
\code{\link{glpenalty}}
\code{\link[stats]{t.test}}
\code{\link[stats]{binom.test}}}

\examples{
  # which hospital has the "worst" readmissions? (note: the average
  # readmission rate is 17.13%
  data(ipadmits)
  attach(ipadmits)
  ip.ag = data.frame('sum' = tapply(ipadmits$isReadmission,ipadmits$HospID,sum),
                     'avg' = tapply(ipadmits$isReadmission,ipadmits$HospID,mean))
  
  # hospital 9 has the most readmissions (1,094), but the percent of readmissions
  # is low at 14%, less than the population average. 
  ip.ag[order(-ip.ag$sum),][1,]
  
  # hostpital 80 has the highest percentage of readmissions 87.5%, but only
  # 7 readmissions over all. 
  ip.ag[order(-ip.ag$avg),][1,]
  
  # using qqrank and penalizing samples less than N = 250 at a growth
  # rate of b = 0.05, Hospital 39 has 1606 readmissions with a readmission
  # percent of 38%. 
  qqr = qqrank(ipadmits$isReadmission,ipadmits$HospID
               ,alternative = "greater",N = 250, b = 0.05)
  round(qqr$rankmatrix,2)
  
  # relax sample penalty and rank on both sides of the mean
  # Hospital 21 has the "best" readmission track record.
  qqr = qqrank(ipadmits$isReadmission,ipadmits$HospID
               ,alternative = "two.sided",absrank = FALSE,N = 30, b = 0.1)
  round(qqr$rankmatrix,2)
  detach(ipadmits)
  }