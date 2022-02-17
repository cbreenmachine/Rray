

fit_models <- function(M, df, forumla){
  return(NULL)
}


# Read data ---------------------------------------------------------------

# Join phenotypes and blood composition
#df <- merge(pheno.df, blood.df, by = "ID") %>%
 # mutate(beadchip = map_chr(str_split(.$ID, "_"), 1))

#if (str_detect(args$ifile, "SHOW")){
  # Handle smoking levels
#  df <- df %>% mutate(smoking = factor(str_replace_all(word(.$smoking), "[[:punct:]]", ""), levels = 1:3))
#} else if (str_detect(args$ifile, "ADRC")){
 # df <- df %>% mutate(smoking = ifelse(is.na(yrs_smoked), 0, yrs_smoked)) %>%
 #   select(-c(yrs_smoked, packs_smoked))
#}
  

# Check that IDs match and send CpG ID to rownames
#M <- M %>% 
#  dplyr::select(c("V1", as.vector(pheno.df$ID))) %>% 
#  column_to_rownames("V1")
#all(names(M) == pheno.df$ID) # Check matching


### generate model and identify surrogate variables
#mod <- model.matrix( ~ bmi + sex + age + race + slide + gran + nk + mono + bcell + cd8 + cd4)
#mod0 <- model.matrix( ~       sex + age + race + slide + gran + nk + mono + bcell + cd8 + cd4)

# TODO: SVA
#modSv <- mod
# n.sv <- num.sv(mValues,mod,method='leek')
# svobj <- sva(mValues,mod,mod0,n.sv=n.sv)
# modSv <- cbind(mod, svobj$sv)

### basic linear fit using limma
# Grab the most important columns--chrom, pos, rs id, gene set, CpG island, etc.
#ann.sub.df <- ann.df[match(rownames(M),ann.df$Name),
 #                    c("chr","pos", "strand", "UCSC_RefGene_Name", "UCSC_RefGene_Group","Relation_to_Island")]
#all(rownames(M) == ann.sub.df$Name)



# Model design ------------------------------------------------------------

#modSv <- model.matrix(~ . - ID, df)
#colnames(modSv)
#fit <- lmFit(M, modSv)
#fit2 <- eBayes(fit)

#fit2$p.value[ ,"bmi"]

#DMPs <- topTable(fit2, coef="bmi",num=Inf,sort.by='none',genelist=ann.sub.df)

#fwrite(fit2$coefficients, file.path(args$odir, "coefficients.csv"),row.names=TRUE)
#fwrite(DMPs, file.path(args$odir, "DMPs.csv"),row.names=TRUE)
