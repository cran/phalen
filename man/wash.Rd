\name{wash}
\alias{wash}
\alias{wash.showall}

\title{Wash Color Palette}
\description{Color Palette for R.}
\usage{wash(color, grade)}

\arguments{
  \item{color}{Name of the color or color vector to be returned.  Run \code{wash.showall()} or see details for a complete list of accepted \code{color} arguments.}
  \item{grade}{A positive numeric value.  For \code{grade} between \code{0} and \code{1}, a single color of gradient \code{grade} will be returned.  For \code{grade} between \code{1} and \code{61}, a character vector of N equidistant grandients will be returned.}
}
\details{
Use \code{wash.showall()} to see the list of colors available and to return 15 of the 61 color gradients.  Below is a list of all colors:

\code{"grd1"} green to red, vibrant

\code{"grd2"} green to red, pale

\code{"blu1"} blue

\code{"blu2"} dark blue

\code{"grn1"} lime green

\code{"grn2"} green

\code{"ylw"} yellow

\code{"org"} orange

\code{"red1"} orange to red

\code{"red2"} pink to red

\code{"prp1"} purple

\code{"prp2"} dark purple

\code{"cyn"} cyan

\code{"grb"} grey blue

\code{"gry"} grey

}
\value{
A color or vector of colors.
}
\seealso{
\code{\link{washout}}}
\examples{
  # show all colors
  wash.showall()
  
  # ---------------------------------------------
  # Chose a single color: 
  # ---------------------------------------------
  # Specify the color then specify a gradient 0-1.  
  # Here is purple2 at 30%
  washcol = wash('prp2',0.3)
  plot(1,1,col = washcol,cex = 21,pch=16,axes = FALSE,xlab = "",ylab = "")
  
  # purple2 at 100%
  washcol = wash('prp2',1)
  plot(1,1,col = washcol,cex = 21,pch=16,axes = FALSE,xlab = "",ylab = "")
  
  
  # ---------------------------------------------
  # Chose a vector of colors: 
  # ---------------------------------------------
  # Specify the color then specify the number of 
  # gradients (1-61) to include in the vector. Here 
  # are 5 shades of blue1. 
  washcol = wash("blu1",5)
  plot(seq.int(1,5),rep(1,5),col = washcol,pch=15,cex = 10
       ,axes = FALSE,xlim = c(0.5,5.5),xlab = "",ylab = "")
  
  # chose 5 different colors
  washcol = c(wash("blu1",1),
              wash("grn2",1),
              wash("ylw",1),
              wash("org",1),
              wash("red2",1))
  plot(seq.int(1,5),rep(1,5),col = washcol,pch=15,cex = 10
       ,axes = FALSE,xlim = c(0.5,5.5),xlab = "",ylab = "")
  
  # 61 shades of greenred1 (for heat maps)
  washcol = wash("grd1",61)
  plot(seq.int(1,61),rep(1,61),col = washcol,pch=15,cex = 21
       ,xlim= c(-4,54),axes = FALSE,xlab = "",ylab = "")
  
  
  # ---------------------------------------------
  # Expand a color vector to match data
  # ---------------------------------------------
  
  # plot readmission by age, no color
  data(ipadmits)
  attach(ipadmits)
  ipadmits.summary = data.frame("AvgReadmission" = tapply(ipadmits$isReadmission
                                                          ,ipadmits$Age
                                                          ,mean)
                               ,"AvgCost" = tapply(ipadmits$cost
                                                  ,ipadmits$Age
                                                  ,mean))
  
  plot(ipadmits.summary$AvgReadmission
       ,xlab = "Age",ylab = "AvgReadmission")
  
  # get vector of 9 greenred1 colors then expand color vector 
  # to match readmission data with color gradient increasing by 
  # value of avg readmission
  washcol = wash("grd1",9)
  washoutcol = washout(ipadmits.summary$AvgReadmission,washcol,method = "value")
  plot(ipadmits.summary$AvgReadmission,col=washoutcol
       ,pch=16,xlab = "Age",ylab = "AvgReadmission")
  
  # increase gradient by the index of the vector Age of value
  washoutcol = washout(ipadmits.summary[,1],washcol,method = "index")
  plot(ipadmits.summary$AvgReadmission,col=washoutcol
       ,pch=16,xlab = "Age",ylab = "AvgReadmission")
  
  # increase gradient by average cost
  washoutcol = washout(ipadmits.summary$AvgCost[1:60]
                      ,washcol, method = "value")
  plot(ipadmits.summary$AvgReadmission[1:60], col=washoutcol
       , pch=16,xlab = "Age", ylab = "AvgReadmission")
  detach(ipadmits)
}
\keyword{ color }
\keyword{ washout }
\keyword{ colors }
\keyword{ palette }
