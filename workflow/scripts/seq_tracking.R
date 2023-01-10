#seq tracking 
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

path <- snakemake@input
params <- snakemake@params 
outs <- snakemake@output

# Global ####

# seq count
#fastq
cmd <- paste0("grep -c '@' " ,path[1:2])
ali <- system(cmd[1],intern = T)
qualali <- system(cmd[2],intern = T)
#fasta
cmd <- paste0("grep -c '>' " ,path[3:8])
dml <- system(cmd[1],intern = T)
basicfilt <- system(cmd[2],intern = T)
derep <- system(cmd[3],intern = T)
clean <- system(cmd[4],intern = T)
clust <- system(cmd[5],intern = T)
agg <- system(cmd[6],intern = T)

# reads count
cmd <- paste0("grep -o -P '(?<=\\scount=)[0-9]+' ",path[5:8]," | awk -F: '{n+=$1} END {print n}'" )
derep_reads <- system(cmd[1],intern = T)
clean_reads <- system(cmd[2],intern = T)
clust_reads <- system(cmd[3],intern = T)
agg_reads <- system(cmd[4],intern = T)

df <- data.frame(step=c("aligned",
                        "alignement qality filtering",
                        "demultiplexing",
                        "basic filtration",
                        "dereplication",
                        "obiclean",
                        "clustering",
                        "merging cluster"),
                 total_sequence=c(ali,
                                  qualali,
                                  dml,
                                  basicfilt,
                                  derep,
                                  clean,
                                  clust,
                                  agg),
                 reads=c(ali,
                         qualali,
                         dml,
                         basicfilt,
                         derep_reads,
                         clean_reads,
                         clust_reads,
                         agg_reads)
)
write.table(df,file=snakemake@output[[1]],row.names=F,sep="\t",quote=F)

# Sample wise ####

# sample wise derepled

cmd2 <- paste0("bash workflow/scripts/reads_count.sh ", path[5:8], " derepl ", params)
system(cmd2[1],intern = T)
system(cmd2[2],intern = T)
system(cmd2[3],intern = T)
system(cmd2[4],intern = T)
# sample wise dml and basfilt

#reads
cmd3 <- paste0("grep -o -P 'sample_ID=.{1,10};' ", path[3:4],"| sort | uniq -c | sed 's/sample_ID=//g' | sed 's/;//g' > ", outs[c(3,5)])
system(cmd3[1],intern = T)
system(cmd3[2],intern = T)
#uniqseq 
cmd4 <- paste0("bash workflow/scripts/count_dml ", path[3:4], " ", outs[c(2,4)] )
system(cmd4[1],intern = T)
system(cmd4[2],intern = T)



