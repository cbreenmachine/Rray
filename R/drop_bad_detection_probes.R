#' @export
drop_bad_detection_probes <- function(mSetFiltered, det.p){
  det.p <- det.p[match(featureNames(mSetFiltered), rownames(det.p)), ]
  keep <- rowSums(det.p < 0.01) == ncol(mSetFiltered)
  mSetFiltered <- mSetFiltered[keep,]
  return(mSetFiltered)
}