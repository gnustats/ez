\name{ezBoot}
\alias{ezBoot}
\title{Compute bootstrap resampled predictions}
\description{
This function is used to compute bootstrap resampled predictions for each cell in a specified experimental design, using either cell means or mixed effects modelling to obtain predictions. The results can be visualized using \code{\link{ezPlot2}}.
}
\usage{
ezBoot(
    data
    , dv
    , wid
    , within = NULL
    , between = NULL
    , resample_within = TRUE
    , iterations = 1e3
    , lmer = FALSE
    , lmer_family = gaussian
    , parallel = FALSE
    , alarm = FALSE
)
}
\arguments{
\item{data}{
Data frame containing the data to be analyzed.
}
\item{dv}{
Name of the column in \code{data} that contains the dependent variable. Values in this column must be numeric.
}
\item{wid}{
Name of the column in \code{data} that contains the variable specifying the case/Ss identifier.
}
\item{within}{
Names of columns in \code{data} that contain predictor variables that are manipulated (or observed) within-Ss. If a single value, may be specified by name alone; if multiple values, must be specified as a .() list.
}
\item{between}{
Names of columns in \code{data} that contain predictor variables that are manipulated (or observed) between-Ss. If a single value, may be specified by name alone; if multiple values, must be specified as a .() list.
}
\item{resample_within}{
Logical value specifying whether to resample within each cell of the design within each wid unit. If there is only one observation per such cells, then this should be set to FALSE to avoid useless computation.
}
\item{iterations}{
Numeric value specifying the number of bootstrap iterations to complete.
}
\item{lmer}{
Logical. If TRUE, predictions are obtained via mixed effects modelling; if FALSE predictions are obtained via cell means.
}
\item{lmer_family}{
When obtaining predictions via mixed effects modelling (i.e. when \code{lmer=TRUE}), you must specify the residuals family. While the bootstrap is in theory non-parametric, it may be more powerful if you specify a family that might reasonably expected to match your data. For example, if the data are binary outcomes (eg. accuracy), then use the \code{binomial} family. See \code{\link[lme4]{lmer}}.
}
\item{parallel}{
Logical. If TRUE, computation will be parallel, assuming that a parallel backend has been specified (as in \code{library(doMC);options(cores=4);registerDoMC()}. Likely only to work when running R from a unix terminal.)
}
\item{alarm}{
Logical. If TRUE, call the \code{\link[utils]{alarm}} function when \code{\link{ezBoot}} completes.
}
}
\details{
While \code{within} and \code{between} are both optional, at least one column of \code{data} must be provided to either \code{within} or \code{between}. Any numeric or character variables in \code{data} that are specified as either \code{wid}, \code{within} or \code{between} will be converted to a factor with a warning. Prior to running, \code{dv} is collapsed to a mean for each cell defined by the combination of \code{wid}, \code{within} or \code{between}.
}
\value{
A list containing either two or three components:
\item{fit}{If predictions are obtained by mixed effects modelling, an \code{link[lme4]{lmer}} object consisting of the original mixed effects model}
\item{cells}{A data frame containing predictions for each cell of the design.}
\item{boots}{A data frame containing predictions for each cell of the design from each iteration of the bootstrap procedure.}
}
\author{
Michael A. Lawrence \email{mike.lwrnc@gmail.com}\cr
Visit the \code{ez} development site at \url{http://github.com/mike-lawrence/ez}\cr
for the bug/issue tracker and the link to the mailing list.
}
\seealso{
\code{link{ezANOVA}}, \code{\link{ezMixed}}, \code{\link{ezPerm}}, \code{\link{ezPlot2}}, \code{\link{ezResample}}
}
\examples{

#Read in the ANT data (see ?ANT).
data(ANT)
head(ANT)
ezPrecis(ANT)

#Run ezBoot on the accurate RT data
rt = ezBoot(
    data = ANT
    , dv = rt
    , wid = subnum
    , within = .(cue,flank)
    , between = group
    , iterations = 1e1 #1e3 or higher is best for publication
)

\dontrun{
#plot the full design
p = ezPlot2(
    preds = rt
    , x = flank
    , split = cue
    , col = group
)
print(p)

#plot the effect of group across the flank*cue design
p = ezPlot2(
    preds = rt
    , x = flank
    , split = cue
    , diff = group
)
print(p)

#plot the flank*cue design, averaging across group
p = ezPlot2(
    preds = rt
    , x = flank
    , split = cue
)
print(p)
}
}
