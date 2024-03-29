#' Loads BSgenome objects from UCSC-style character vectors.
#'
#' This function will let you use a simple character vector (e.g. 'hg19') to
#' load and then return BSgenome objects. This lets you avoid having to use the
#' more complex annotation for a complete BSgenome object (e.g.
#' BSgenome.Hsapiens.UCSC.hg38.masked)
#' 
#' @param genomeBuild One of 'hg19', 'hg38', 'mm10', 'mm9', or 'grch38'
#' @param masked Should we used the masked version? Default:TRUE
#' @return A BSgenome object corresponding to the provided genome build.
#' @export
#' @examples
#' \dontrun{
#' bsg = loadBSgenome('hg19')
#' }
loadBSgenome = function(genomeBuild, masked=TRUE) {
    # Convert the given string into the BSgenome notation
    if (!requireNamespace("BSgenome", quietly=TRUE)) {
        message("BSgenome package is not installed.")
    }
    databasePkgString = switch (genomeBuild,
                                grch38 = "BSgenome.Hsapiens.UCSC.hg38",
                                hg38 = "BSgenome.Hsapiens.UCSC.hg38",
                                hg19 = "BSgenome.Hsapiens.UCSC.hg19",
                                mm10 = "BSgenome.Mmusculus.UCSC.mm10",
                                mm9 = "BSgenome.Mmusculus.UCSC.mm9",
                                bogus = "bogus" # a bogus genome for tests
    )
    if (masked) {
        databasePkgString = paste0(databasePkgString, ".masked")
    }
    
    if (is.null(databasePkgString)) {
        stop("I don't know how to map the string ", genomeBuild,
             " to a BSgenome")
    }
    return(.requireAndReturn(databasePkgString))
}

#' Load selected EnsDb library
#'
#' @param genomeBuild string, genome identifier
#'
#' @return loaded library
#' @export
#'
#' @examples
#' \dontrun{
#' loadEnsDb("hg19")
#' }
loadEnsDb = function(genomeBuild) {
    databasePkgString = switch (genomeBuild,
                                grch38 = "EnsDb.Hsapiens.v86",
                                hg38 = "EnsDb.Hsapiens.v86",
                                hg19 = "EnsDb.Hsapiens.v75",
                                mm10 = "EnsDb.Mmusculus.v79",
                                bogus = "bogus" # a bogus db for unit tests
    )
    
    if (is.null(databasePkgString)) {
        stop("I don't know how to map the string ", genomeBuild,
             " to a EnsDb")
    }
    return(.requireAndReturn(databasePkgString))
}

#' Returns built-in chrom sizes for a given reference assembly
#
#' @param refAssembly A string identifier for the reference assembly
#' @return A vector with the chromosome sizes corresponding to a 
#' specific genome assembly.
#' @export
#' @examples
#' getChromSizes("hg19")
getChromSizes = function(refAssembly) {
  datasetId = paste0("chromSizes_", refAssembly)
  
  if (refAssembly == "hg19"){
    
    chromSizesDataset = getReferenceData(refAssembly, tagline="chromSizes_")
    
  } else if (refAssembly == "hg38"){
    
    if (!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      chromSizesDataset = GenomicDistributionsData::chromSizes_hg38()
    }
    
  } else if (refAssembly == "mm10"){
    
    if (!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      chromSizesDataset = GenomicDistributionsData::chromSizes_mm10()
    }
    
  } else if (refAssembly == "mm9"){
    
    if (!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      chromSizesDataset = GenomicDistributionsData::chromSizes_mm9()
    }
    
  } else {
    stop(paste(datasetId, "not available in GenomicDistributions package",
               "or GenomicDistributionsData package,",
               "please use getChromSizesFromFasta() to get chromosome sizes."))
  }
  
  return(chromSizesDataset)
}


# Returns built-in TSSs for a given reference assembly
#
# @param refAssembly A string identifier for the reference assembly
getTSSs = function(refAssembly) { 
  datasetId = paste0("TSS_", refAssembly)
  
  if (refAssembly == "hg19"){
    
    TSSs = getReferenceData(refAssembly, tagline="TSS_")
    
  } else if (refAssembly == "hg38"){
    
    if (!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      TSSs = GenomicDistributionsData::TSS_hg38()
    }
    
  } else if (refAssembly == "mm10"){
    
    if (!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      TSSs = GenomicDistributionsData::TSS_mm10()
    }
    
  } else if (refAssembly == "mm9"){
    
    if(!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      TSSs = GenomicDistributionsData::TSS_mm9()
    }
    
  } else {
    stop(paste(datasetId, "not available in GenomicDistributions package",
               "or GenomicDistributionsData package,",
               "please use getTssFromGTF() to get list of TSSs."))
  }
  
  return(TSSs)
}


#' Returns built-in gene models for a given reference assembly
#'
#' Some functions require gene models, which can obtained from any source.
#' This function allows you to retrieve a few common built-in ones.
#' @param refAssembly A string identifier for the reference assembly
#' @return A list containing the gene models corresponding to a
#' specific reference assembly.
#' @export
#' @examples
#' getGeneModels("hg19")
getGeneModels = function(refAssembly) { 
  datasetId = paste0("geneModels_", refAssembly)
  
  if(refAssembly == "hg19"){
    
    geneModelsDataset = getReferenceData(refAssembly, tagline="geneModels_")
    
  } else if(refAssembly == "hg38"){
    
    if(!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      geneModelsDataset = GenomicDistributionsData::geneModels_hg38()
    }
    
  } else if(refAssembly == "mm10"){
    
    if(!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      geneModelsDataset = GenomicDistributionsData::geneModels_mm10()
    }
    
  } else if(refAssembly == "mm9"){
    
    if(!"GenomicDistributionsData" %in% utils::installed.packages()){
      stop(paste(datasetId, "not available in GenomicDistributions package",
                 "and GenomicDistributionsData package is not installed"))
    } else {
      geneModelsDataset = GenomicDistributionsData::geneModels_mm9()
    }
    
  } else {
    stop(paste(datasetId, "not available in GenomicDistributions package",
               "or GenomicDistributionsData package,",
               "please use getGeneModelsFromGTF() to get",
               "gene models."))
  }
  
  return(geneModelsDataset)
}

#' Get reference data for a specified assembly
#' 
#' This is a generic getter function that will return a data object requested,
#' if it is included in the built-in data with the GenomicDistributions package 
#' or GenomicDistributionsData package (if installed). Data objects can 
#' be requested for different reference assemblies and data types (specified by
#' a tagline, which is a unique string identifying the data type).
#' 
#' @param refAssembly Reference assembly string (e.g. 'hg38')
#' @param tagline The string that was used to identify data of a given type in 
#'     the data building step. It's used for the filename so we know
#'     what to load, and is what makes this function generic (so it 
#'     can load different data types).
#' @return A requested and included package data object.
getReferenceData = function(refAssembly, tagline) {
    # query available datasets and convert the packageIQR object into a vector
    datasetId = paste0(tagline, refAssembly)
    dataset = .getDataFromPkg(id=datasetId, "GenomicDistributions")
    if(!is.null(dataset))
        return(dataset)
    if(!"GenomicDistributionsData" %in% utils::installed.packages())
        stop(paste(datasetId, "not available in GenomicDistributions package",
                   "and GenomicDistributionsData package is not installed"))
    dataset = .getDataFromPkg(id=datasetId, "GenomicDistributionsData")
    if(!is.null(dataset))
        return(dataset)
    stop(paste(datasetId, "not available in GenomicDistributions and",
               "GenomicDistributionsData packages"))
}

.getDataFromPkg = function(id, pkg){
    datasetListIQR = utils::data(package=pkg)
    datasetList = datasetListIQR$results[,"Item"]
    if (id %in% datasetList){
        utils::data(list=id, package=pkg, envir=environment())
        return(get(id))
    } 
    return(invisible(NULL))
}

