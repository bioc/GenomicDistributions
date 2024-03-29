#' Read local or remote file
#'
#' @param source a string that is either a path to a local or remote GTF
#' @param destDir a string that indicates the path to the directory where
#'       the downloaded GTF file should be stored. If not provided, 
#'       a temporary directory will be used.
#'
#' @return data.frame retrieved file path
#' @export
#'
#' @examples
#' CElegansGtfCropped = system.file("extdata", 
#'                                  "C_elegans_cropped_example.gtf.gz", 
#'                                  package="GenomicDistributions")
#' CElegansGtf = retrieveFile(CElegansGtfCropped)
retrieveFile = function(source, destDir=NULL){
  if (is.null(destDir)) destDir = tempdir()
    # download file, if not local
  if (!file.exists(source)) {
    destFile = paste(destDir, basename(source), sep = "/")
    if (file.exists(destFile)){
      message("File exists: ", destFile)
    }else{
      message("File will be saved in: ", destFile)
      download.file(url = source, destfile = destFile)    
    }
  }else{
    destFile = source
    message("Got local file: ", destFile)
  }
  
    return(destFile)
}


#' Get transcription start sites (TSSs) from a remote or local GTF file
#'
#' @param source a string that is either a path to a local or remote GTF
#' @param destDir a string that indicates the path to the directory where 
#'        the downloaded GTF file should be stored
#' @param convertEnsemblUCSC a logical indicating whether Ensembl style 
#'        chromosome annotation should be changed to UCSC style
#' @param filterProteinCoding a logical indicating if TSSs should be only
#'        protein-coding genes (default = TRUE)
#'
#' @return a list of GRanges objects
#'
#' @import dplyr
#' @export
#'
#' @examples
#' CElegansGtfCropped = system.file("extdata", 
#'                                  "C_elegans_cropped_example.gtf.gz", 
#'                                  package="GenomicDistributions")
#' CElegansTss = getTssFromGTF(CElegansGtfCropped, TRUE)
getTssFromGTF = function(source, convertEnsemblUCSC=FALSE, destDir=NULL,
                         filterProteinCoding=TRUE){
    GtfDf = as.data.frame(rtracklayer::import(retrieveFile(source, destDir)))
    
    if (filterProteinCoding) {
      subsetGtfDf = GtfDf %>% 
        dplyr::filter(gene_biotype == "protein_coding", type == "gene")
    } else {
      subsetGtfDf = GtfDf
    }
    
    gr = makeGRangesFromDataFrame(subsetGtfDf, keep.extra.columns = TRUE)
    feats = promoters(gr, 1, 1) 
    if(convertEnsemblUCSC)
      seqlevels(feats) = paste0("chr", seqlevels(feats))
    feats
}


#' Get gene models from a remote or local GTF file
#'
#' @param source a string that is either a path to a local or remote GTF
#' @param destDir a string that indicates the path to the directory where
#'        the downloaded GTF file should be stored
#' @param features a vector of strings with feature identifiers that to 
#'        include in the result list
#' @param convertEnsemblUCSC a logical indicating whether Ensembl style 
#'        chromosome annotation should be changed to UCSC style
#' @param filterProteinCoding a logical indicating if TSSs should be only
#'        protein-coding genes (default = TRUE)
#'
#' @return a list of GRanges objects
#'
#' @import dplyr
#' @export
#'
#' @examples
#' CElegansGtfCropped = system.file("extdata", 
#'                                  "C_elegans_cropped_example.gtf.gz", 
#'                                  package="GenomicDistributions")
#' features = c("gene", "exon", "three_prime_utr", "five_prime_utr")
#' CElegansGeneModels = getGeneModelsFromGTF(CElegansGtfCropped, features, TRUE)
getGeneModelsFromGTF = function(source,
                                 features,
                                 convertEnsemblUCSC = FALSE,
                                 destDir = NULL,
                                 filterProteinCoding=TRUE) {
  GtfDf = as.data.frame(rtracklayer::import(retrieveFile(source, destDir)))
  
  if (filterProteinCoding) {
    subsetGtfDf = GtfDf %>%
      dplyr::filter(gene_biotype == "protein_coding")
  } else {
    subsetGtfDf = GtfDf
  }
  
  retList = list()
  message("Extracting features: ", paste(features, collapse = ", "))
  for (feat in features) {
    featGR =  GenomicRanges::reduce(
      unique(GenomeInfoDb::keepStandardChromosomes(
        GenomicRanges::makeGRangesFromDataFrame(
          subsetGtfDf %>% filter(type == feat),
          keep.extra.columns = TRUE), 
        pruning.mode = "coarse")))
    # change from Ensembl style chromosome annotation to UCSC style
    if (convertEnsemblUCSC)
      seqlevels(featGR) =  paste0("chr", seqlevels(featGR))
    retList[[feat]] = featGR
  }
  retList
}


#' Get gene models from a remote or local FASTA file
#'
#' @param source a string that is either a path to a  
#'        local or remote FASTA
#' @param destDir a string that indicates the path to the 
#'        directory where the downloaded FASTA file should be stored
#' @param convertEnsemblUCSC a logical indicating whether Ensembl style 
#'        chromosome annotation should be changed to UCSC style (add chr)
#' @return a named vector of sequence lengths
#' @importFrom Biostrings readDNAStringSet
#' @export
#'
#' @examples
#' CElegansFasteCropped = system.file("extdata", 
#'                                    "C_elegans_cropped_example.fa.gz", 
#'                                    package="GenomicDistributions")
#' CElegansChromSizes = getChromSizesFromFasta(CElegansFasteCropped)
getChromSizesFromFasta = function(source, destDir=NULL,
                                  convertEnsemblUCSC=FALSE) {
  fastaPath = retrieveFile(source, destDir)
  fastaStringSet = readDNAStringSet(fastaPath)
  oriNames = fastaStringSet@ranges@NAMES
  names = vapply(oriNames, function(x){
    strsplit(x, " ")[[1]][1]
  }, character(1))
  chromSizes = fastaStringSet@ranges@width
  if(convertEnsemblUCSC){
    names(chromSizes) = paste0("chr", names)
  } else{
    names(chromSizes) = names
  }
  chromSizes
}
