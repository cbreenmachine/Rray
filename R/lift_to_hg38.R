chain.file <- "hg19ToHg38.over.chain"

.check_chain <- function(){
    if (! file.exists(chain.file)){
        tmp <- file.path("https://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/", chain.file)
        utils::download.file(tmp, destfile = paste0(chain.file, ".gz"))
        system(paste0("gzip -d ", chain.file, ".gz"))
    } 
}


#'@export
lift_to_hg38 <- function(df){

    .check_chain()
    chain <- rtracklayer::import.chain(chain.file)

    # "Normal" coordinates, but renamed
    df <- df %>% 
            dplyr::rename(seqnames = chr) %>%
            dplyr::mutate(start = pos - 1, end = pos + 1)
    gr <- GenomicRanges::GRanges(df)
    gr.lifted <- rtracklayer::liftOver(gr, chain = chain)

    out.df <- as.data.frame(gr.lifted) %>% 
        dplyr::rename(chr = seqnames) %>% 
        dplyr::select(-c(group, group_name)) %>%
        dplyr::mutate(pos = start + 1) # put the pos back to sensible one-based
    return(out.df)
}