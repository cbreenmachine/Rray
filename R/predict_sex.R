#' @export
predict_sex <- function(mSetFiltered, targets, filter=TRUE){

  # predict sex
  pSex <- minfi::getSex(mSetFiltered) %>% as.data.frame() %>% tibble::rownames_to_column("ID")
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