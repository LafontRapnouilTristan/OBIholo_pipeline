# taxassign
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(dada2)
library(stringr)

cleaned_seq <- getSequences(snakemake@input[[1]])
tab <- data.frame(seq_id = str_extract(names(cleaned_seq),"seq[0-9]+"),
                  sequence=cleaned_seq,
                  abundance=str_extract(names(cleaned_seq),"(?<= count=)[0-9]"))

tabseq<- makeSequenceTable(tab)
taxa <- assignTaxonomy(tabseq,
                       snakemake@params[[2]],
                       multithread=snakemake@params[[1]],
                       outputBootstraps = T)

taxa <-cbind(sequences=rownames(taxa),taxa)

write.csv2(taxa, snakemake@output[[1]],row.names = F)