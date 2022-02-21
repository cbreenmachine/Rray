#' @export
get_annotation <- function() {
    ann <- minfi::getAnnotation("IlluminaHumanMethylationEPICanno.ilm10b2.hg19")
    return(as.data.frame(ann))
}