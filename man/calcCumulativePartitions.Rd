% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/partition-plots.R
\name{calcCumulativePartitions}
\alias{calcCumulativePartitions}
\title{Calculates the cumulative distribution of overlaps between query and
arbitrary genomic partitions}
\usage{
calcCumulativePartitions(query, partitionList, remainder = "intergenic")
}
\arguments{
\item{query}{GRanges or GRangesList with regions to classify.}

\item{partitionList}{An ORDERED and NAMED list of genomic partitions
GRanges. This list must be in priority order; the input will be assigned
to the first partition it overlaps.}

\item{remainder}{Which partition do you want to account for 'everything
else'?}
}
\value{
A data.frame assigning each element of a GRanges object to a
    partition from a previously provided partitionList.
}
\description{
Takes a GRanges object, then assigns each element to a partition from the
provided partitionList, and then tallies the number of regions assigned to
each partition. A typical example of partitions is promoter, exon, intron,
etc; this function will yield the number of each for a query GRanges object
There will be a priority order to these, to account for regions that may
overlap multiple genomic partitions.
}
\examples{
partitionList = genomePartitionList(geneModels_hg19$genesGR,
                                    geneModels_hg19$exonsGR,
                                    geneModels_hg19$threeUTRGR,
                                    geneModels_hg19$fiveUTRGR)
calcCumulativePartitions(vistaEnhancers, partitionList)
}
