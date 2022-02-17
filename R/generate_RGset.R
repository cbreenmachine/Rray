#' @export
generate_RGset <- function(idir, targets.df){
    my.files <- list.files(path = idir, full.names = T, recursive = T, pattern = "Grn.idat")
    my.files.stripped <- stringr::str_remove(basename(my.files), "_Grn.idat")

    valid.IDs <- intersect(my.files.stripped, targets.df$ID)
    print(valid.IDs)

    # Filter file paths and samplesheet (targets)
    my.files <- my.files[my.files.stripped %in% valid.IDs]
    targets.df <- targets.df %>% dplyr::mutate(ID %in% valid.IDs)
    
    # Heavy lifting--read RGset here...
    RGset <- minfi::read.metharray(my.files, verbose = TRUE)
    return(list("RGset" = RGset, "targets" = targets.df))

}

