#' @export
drop_bad_detection_samples <- function(RGset, targets){
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
    