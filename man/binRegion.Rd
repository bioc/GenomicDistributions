% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chrom-plots.R
\name{binRegion}
\alias{binRegion}
\title{Aggregating signals in bins across a set of regions}
\usage{
binRegion(start, end, bins, idDF = NULL)
}
\arguments{
\item{start}{The starting coordinate}

\item{end}{The ending coordinate}

\item{bins}{The number of bins to divide this segment}

\item{idDF}{An identifier vector to keep with your bins, in case you are
doing this on a long table with multiple segments concatenated}
}
\value{
A data.table, expanded to nrow = number of bins, with these id columns:
		id: region ID
		binID: repeating ID (this is the value to aggregate across)
		ubinID: unique bin IDs
}
\description{
Given a start coordinate, end coordinate, and number of bins to divide, 
this function will split the regions into that many bins.
Bins will be only approximately the same size, due to rounding.
(they should not be more than 1 different).
}
\details{
Use case: take a set of regions, like CG islands, and bin them; now you can
aggregate signal scores across the bins, giving you an aggregate signal
in bins across many regions of the same type.

In theory, this just runs on 3 values, but you can run it inside a 
data.table j expression to divide a bunch of regions in the same way.
}
\examples{
loadCGData("hg19")
cgIslandsDT = data.table(...)
binnedCGI = cgIslandsDT[, binRegion(start, end, 50)]
}