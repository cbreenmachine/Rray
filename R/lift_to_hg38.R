


chain.file <- "hg19ToHg38.over.chain"

.check_chain <- function(){
    if (! file.exists(chain)){
        tmp <- file.path("https://hgdownload.cse.ucsc.edu/goldenpath/hg19/liftOver/", chain.file)
        utils::download.file(tmp, destfile = paste0(chain.file, ".gz"))
        system(paste0("gzip -d ", chain.file, ".gz"))
    } 
}

lift_to_hg38 <- function(df){

    .check_chain()
    chain <- rtracklayer::import.chain(chain.file)

    # "Normal" coordinates, but renamed
    df <- df %>% 
            dplyr::rename(seqnames = chr) %>%
            dplyr::mutate(start = pos, end = pos + 1)
    gr <- Granges(df)
    gr.lifted <- liftOver(gr, chain = chain)

    out.df <- as.data.frame(gr.lifted) %>% dplyr::rename(chr = seqnames)
    return(out.df)
}