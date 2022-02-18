#' @export
get_methylation_estimates <- function(mSetFiltered){
    mValues <- getM(mSetFiltered) %>% as.data.frame()
    bValues <- getBeta(mSetFiltered) %>% as.data.frame()

    mValues <- mValues[!duplicated(as.list(mValues))]
    bValues <- mValues[!duplicated(as.list(bValues))]
    return(list("M" = mValues, "beta" = bValues))
}