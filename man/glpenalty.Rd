\name{glpenalty}
\alias{glpenalty}
\title{Generalized Logistic Penalty}
\description{Flexible generalized logistic function.}
\usage{
glpenalty(X, x0 = NA, x1 = NA, p = NA, b = NA, type = NA, 
          plotpenalty = TRUE, allowed.error = 0.005, invert = FALSE)
}

\arguments{
  \item{X}{A numeric vector.}
  \item{x0}{\emph{optional}: The value(s) where \code{glpentalty} is within the \code{allowed.error} of \code{0}.}
  \item{x1}{\emph{optional}: The value(s) where \code{glpenalty} is within the \code{allowed.error} of \code{1}.}
  \item{p}{\emph{optional}: A percent of \code{X} over which the penalty is applied.  \code{p} must be between \code{0} and \code{1} for single sided \code{glpenalty} and between \code{0} and \code{0.5} for double sided \code{glpenalty}.}
  \item{b}{\emph{optional}: A positive valued rate at which \code{glpenalty} grows or decays.}
  \item{type}{\emph{optional}: A character value accepting \code{"growth"}, \code{"decay"}, or \code{"both"}}
  \item{plotpenalty}{If \code{TRUE}, the \code{glpenalty} is plotted.  The default is \code{TRUE}.}
  \item{allowed.error}{The allowed difference between \code{glpenalty} and \code{0} or \code{1} at \code{x0} or \code{x1} respectively. The default is \code{0.005}.}
  \item{invert}{If \code{TRUE}, the \code{glpenalty} is inverted.  The default is \code{FALSE}.}
}
\details{
The \emph{parameter arguments} (i.e., the arguements required to parametrize \code{glpenalty}) are \code{x0}, \code{x1}, \code{p}, \code{b}, and \code{side}.  Only certian combinations of these parameter arguments are required.  If more than the needed number of \emph{parameter arguments} are given, then \code{glpenalty} will use only the first two supplied.  The following combinations of parameter arguments are accepted:

1. \code{{x0,x1}}:  The function will grow (if \code{x0 < x1}) or decay (if \code{x0 > x1}) between the supplied values.  For both growth and decay, supply 2 values to both \code{x0 and x1} where \code{x0[1] }\code{< }\code{x1[1] }\code{< }\code{x1[2] }\code{< }\code{x0[2]}.

2. \code{{x1,b,side}}:  The function will grow or decay starting at \code{x1} and at rate \code{b}.

3. \code{{p,b,side}}:  The function will grow or decay starting at \code{p} percent of the vector \code{X} and at rate \code{b}.
}
\value{Returns the numeric penalty vector.}

\examples{
  # create a vector of numbers
  x = seq.int(1,100)
  
  
  # specify x near 0 (x0) and x near 1 (x1), growth is computed
  glpenalty(x,x0 = 20,x1 = 50)
  
  #How the plot might look when numbers aren't consecutive
  glpenalty(sort(sample(x,40)),x0 = 20,x1 = 50)
  
  # decay when x near 0 (x0) is greater than x near 1 (x1)
  glpenalty(x,x0 = 50,x1 = 20)
  
  # adjust shrink allowed.error at x0 and x1.  Smaller allowed.error
  # makes for "steeper" rates of growth or decay.
  glpenalty(x,x0 = 50,x1 = 20,allowed.error = 0.0001)
  
  # combine growth and decay by specifying 2 x0 and 2 x1
  # growth from 10 to 35 and decay from 50 to 90.
  glpenalty(x,x0 = c(10,90),x1 = c(35,50))
  # invert 
  glpenalty(x,x0 = c(10,90),x1 = c(35,50),invert=TRUE)
  
  # specify x1 and growth rate.
  glpenalty(x,x1 = 30,b = 0.4, type = "growth")
  glpenalty(x,x1 = 20,b = 0.5, type = "decay")
  glpenalty(x,x1 = 30,b = 0.3, type = "both")
  

  # specify percent of vector to be penalized
  # and growth rate.
  
  glpenalty(x,p = 0.6,b = 0.4, type = "growth")
  glpenalty(x,p = 0.6,b = 0.5, type = "decay")
  glpenalty(x,p = 0.4,b = 0.3, type = "both")
}
