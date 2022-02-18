#' Workhorse function that uses sensible defaults to preprocess RGsets
#' @param RGset, an RGset object created by read.metharray() or something similar
#' @param targets a dataframe containing `ID` as a column that matches RGset names
### Filter probes for low quality, sex chromosomes, cross-reactive, CH

# filter probes of known cross-reactive sites
#.filter_x_reactive <- function(){
#  x.df <- read_table("../data/probes/2016-McCartnety-cross-hybrid-cpg.txt", col_names = "probe")
#  keep.ix <- !(featureNames(mSetFiltered) %in% x.df$probe)
#  mSetFiltered <- mSetFiltered[keep.ix, ]
#}

#' @export
preprocess <- function(RGset, targets, method){

    if (!all(colnames(RGset) == targets$ID)){
      error("Column names in RGset and targets$ID don't match--remake RGset with wrapper")
    } else {
      print("Names match!")
    }

    # First drop samples with uniformly bad detection
    out <- drop_bad_detection_samples(RGset, targets)
    RGset <- out$RGset
    targets <- out$targets
    det.p <- out$det.p
    
    # SWAN or NOOB preprocessing
    mSetProcessed <- normalize(out$RGset, method)
    mSetFiltered <- map_and_filter(mSetProcessed)
    targets <- out$targets
    pSex.df <- out$pSex.df

    # Sex prediction
    out <- predict_sex(mSetFiltered)
    mSetFiltered <- out$mSetFiltered
    targets <- out$targets
    pSex.df <- out$pSex.df

    # One more round of detection p-value culling
    mSetFiltered <- drop_bad_detection_probes(SetFiltered)

    out <- get_methylation_estimates(mSetFiltered)
    M <- out$M
    beta <- out$M

    # Parallel filtering
    RGset <- RGset[, colnames(mSetFiltered)]
    cellcomp.df <- estimate_cell_comp(RGset)

    return(list("M" = M, "beta" = beta, "targets" = targets, "cell.comp" = cellcomp.df, "sex.pred" = pSex.df))
}
