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
cmd <- paste0("grep -c '@' " ,path[[1:2]])
ali <- system(cmd[1],intern = T)
qualali <- system(cmd[2],intern = T)
#fasta
cmd <- paste0("grep -c '>' " ,path[[3:8]])
dml <- system(cmd[3],intern = T)
basicfilt <- system(cmd[4],intern = T)
derep <- system(cmd[5],intern = T)
clean <- system(cmd[6],intern = T)
clust <- system(cmd[7],intern = T)
agg <- system(cmd[8],intern = T)

# reads count
cmd <- paste0("grep -o -P '(?<=\\scount=)[0-9]+' ",path[[5:8]]," | awk -F: '{n+=$1} END {print n}'" )
derep_reads <- system(cmd[5],intern = T)
clean_reads <- system(cmd[6],intern = T)
clust_reads <- system(cmd[7],intern = T)
agg_reads <- system(cmd[8],intern = T)

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
write.csv2(df,outs[1],row.names=F)

# Sample wise ####

# sample wise derepled

cmd <- paste0("bash ../scripts/reads_count ", path[5:8], " derepl ", params)
system(cmd[1],intern = T)
system(cmd[2],intern = T)
system(cmd[3],intern = T)
system(cmd[4],intern = T)
# sample wise dml and basfilt

#reads
cmd <- paste0("grep -o -P 'sample_ID=.{1,10};' ", path[3:4],"| sort | uniq -c | sed 's/sample_ID=//g' | sed 's/;//g' > ", out[3,5])
system(cmd[1],intern = T)
system(cmd[2],intern = T)
#uniqseq 
cmd <- paste0("bash ","../scripts/count_dml", path, " ", out[2,4] )
system(cmd,intern = T)
system(cmd[1],intern = T)
system(cmd[2],intern = T)



