#' Workhorse function that uses sensible defaults to preprocess RGsets
#' @param RGset, an RGset object created by read.metharray() or something similar
#' @param targets a dataframe containing `ID` as a column that matches RGset names
#' @param 
#library(limma)
#library(minfi)
#library(tidyverse)
#library(data.table)
#library(IlluminaHumanMethylationEPICanno.ilm10b4.hg19)
#library(FlowSorted.Blood.EPIC)

.drop_bad_detection_samples <- function(RGset, targets){
  det.p <- minfi::detectionP(RGset)
  mean.p <- colMeans(det.p)
  print("...summary of mean detection p-values...")
  print(summary(mean.p))

  # Filter
  good.samples <- names(which(mean.p <= 0.05))
  RGset <- RGset[ ,good.samples]
  targets <- dplyr::filter(targets, ID %in% good.samples)
  return(list("RGset" = RGset, "targets" = targets, "det.p" = det.p))
}
    

#https://zwdzwd.github.io/InfiniumAnnotation

.normalize <- function(RGset, method){
  if (method == "noob") {
    mSetProcessed <- preprocessNoob(RGset)
  } else if  (method == "swan"){
    mSetProcessed <- preprocessSWAN(RGset)
  } else {
    error("Specify noob or swan!")
  } 
  return(mSetProcessed)
}



# Mapping and filtering ---------------------------------------------------

.map_and_filter <- function(mSetProcessed){
    mSetMapped <- mapToGenome(mSetProcessed)
    mSetFiltered <- dropLociWithSnps(mSetMapped)
    mSetFiltered <- dropMethylationLoci(mSetFiltered)
    return(mSetFiltered)
}

.predict_sex <- function(mSetFiltered, targets, filter=TRUE){

  # predict sex
  pSex <- minfi::getSex(mSetFiltered) %>% as.data.frame() %>% dplyr::rownames_to_column("ID")
  pSex.df <- dplyr::inner_join(pSex, targets, by = "ID")

  sex.keep <- (pSex.df$predictedSex == pSex.df$sex)
  print("...sex prediction...")
  table(sex.keep)

  if (filter){
    mSetFiltered <- mSetFiltered[ , sex.keep]
    targets <- targets[sex.keep, ]
  }
  
  return(list("mSetFiltered" = mSetFiltered, "targets" = targets, "pSex.df" = pSex.df))
}

# Filter probes that don't have good enough detection p-values at all samples
# Needs to happen after sex prediction

.drop_bad_detection_probes <- function(mSetFiltered, det.p){
  det.p <- det.p[match(featureNames(mSetFiltered), rownames(det.p)), ]
  keep <- rowSums(detP < 0.01) == ncol(mSetFiltered)
  mSetFiltered <- mSetFiltered[keep,]
  return(mSetFiltered)
}

### Filter probes for low quality, sex chromosomes, cross-reactive, CH

# filter probes of known cross-reactive sites
#.filter_x_reactive <- function(){
#  x.df <- read_table("../data/probes/2016-McCartnety-cross-hybrid-cpg.txt", col_names = "probe")
#  keep.ix <- !(featureNames(mSetFiltered) %in% x.df$probe)
#  mSetFiltered <- mSetFiltered[keep.ix, ]
#}



### Get Beta (bValues) and logit M-values (mValues)

.get_methylation_estimates <- function(mSetFiltered){
    mValues <- getM(mSetFiltered) %>% as.data.frame()
    bValues <- getBeta(mSetFiltered) %>% as.data.frame()

    mValues <- mValues[!duplicated(as.list(mValues))]
    bValues <- mValues[!duplicated(as.list(bValues))]
    return(list("M" = mValues, "beta" = betaValues))
}


.estimate_cell_comp <- function(RGset){
  cellCounts <- estimateCellCounts2(RGset, compositeCellType="Blood", referencePlatform = "IlluminaHumanMethylationEPIC")
  cc.df <- as.data.frame(cellCounts)  %>% rownames_to_column("ID") 
  return(cc.df)
}


preprocess <- function(RGset, targets, method){

    if (!all(colnames(RGset) == targets$ID)){
      error("Column names in RGset and targets$ID don't match--remake RGset with wrapper")
    } else {
      print("Names match!")
    }

    # First drop samples with uniformly bad detection
    out <- .drop_bad_detection_samples <- function(RGset, targets)
    RGset <- out$RGset
    targets <- out$targets
    
    # SWAN or NOOB preprocessing
    mSetProcessed <- .normalize(out$RGset, method)
    mSetFiltered <- .map_and_filter(mSetProcessed)
   
    # Sex prediction
    out <- .predict_sex(mSetFiltered)
    mSetFiltered <- out$mSetFiltered
    targets <- out$targets
    pSex.df <- out$pSex.df

    # One more round of detection p-value culling
    mSetFiltered <- .drop_bad_detection_probes(SetFiltered)


    out <- .get_methylation_estimates(mSetFiltered)
    M <- out$M
    beta <- out$M

    # Parallel filtering
    RGset <- RGset[, colnames(mSetFiltered)]
    cellcomp.df <- .estimate_cell_comp(RGset)


    return(list("M" = M, "beta" = beta, "targets" = targets, "cellcomp" = cellcomp.df))
}
