% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/partition-plots.R
\name{calcExpectedPartitions}
\alias{calcExpectedPartitions}
\title{Calculates expected partiton overlap based on contribution of each
feature (partition) to genome size. Expected and observed overlaps
are then compared.}
\usage{
calcExpectedPartitions(
  query,
  partitionList,
  genomeSize = NULL,
  remainder = "intergenic",
  bpProportion = FALSE
)
}
\arguments{
\item{query}{GRanges or GRangesList with regions to classify.}

\item{partitionList}{An ORDERED (if bpProportion=FALSE) and NAMED
list of genomic partitions GRanges. This list must be in
priority order; the input will be assigned
to the first partition it overlaps. However, if bpProportion=TRUE,
the list does not need ordering.}

\item{genomeSize}{The number of bases in the query genome. In other words,
the sum of all chromosome sizes.}

\item{remainder}{Which partition do you want to account for 'everything
else'?}

\item{bpProportion}{logical indicating if overlaps should be calculated based
on number of base pairs overlapping with each partition.
bpProportion=FALSE does overlaps in priority order,
bpProportion=TRUE counts number of overlapping
base pairs between query and each partition.}
}
\value{
A data.frame assigning each element of a GRanges object to a
    partition from a previously provided partitionList.The data.frame also
    contains Chi-square p-values calculated for observed/expected
    overlaps on each individual partition.
}
\description{
Calculates expected partiton overlap based on contribution of each
feature (partition) to genome size. Expected and observed overlaps
are then compared.
}
\examples{
partitionList = genomePartitionList(geneModels_hg19$genesGR,
                                    geneModels_hg19$exonsGR,
                                    geneModels_hg19$threeUTRGR,
                                    geneModels_hg19$fiveUTRGR)
chromSizes = getChromSizes('hg19')
genomeSize = sum(chromSizes)
calcExpectedPartitions(vistaEnhancers, partitionList, genomeSize)
}
