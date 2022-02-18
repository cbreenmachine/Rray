#' @export
map_and_filter <- function(mSetProcessed){
    mSetMapped <- mapToGenome(mSetProcessed)
    mSetFiltered <- dropLociWithSnps(mSetMapped)
    mSetFiltered <- dropMethylationLoci(mSetFiltered)
    return(mSetFiltered)
}