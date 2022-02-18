#' @export
estimate_cell_comp <- function(RGset){
  cellCounts <- FlowSorted.Blood.EPIC::estimateCellCounts2(RGset, compositeCellType="Blood", referencePlatform = "IlluminaHumanMethylationEPIC")
  cc.df <- as.data.frame(cellCounts)  %>% rownames_to_column("ID") 
  return(cc.df)
}
