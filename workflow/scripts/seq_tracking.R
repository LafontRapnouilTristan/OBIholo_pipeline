#seq tracking 
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

path <- snakemake@input

# seq count
cmd <- paste0("grep -c '@' " ,path[[1]])
ali <- system(cmd,intern = T)

cmd <- paste0("grep -c '@' " ,path[[2]])
qualali <- system(cmd,intern = T)

cmd <- paste0("grep -c '@' " ,path[[3]])
dml <- system(cmd,intern = T)

cmd <- paste0("grep -R '@' ",path[[4]]," | wc -l " )
filtrim <- system(cmd,intern = T)

cmd <- paste0("grep -c '>' " ,path[[5]])
derep <- system(cmd,intern = T)

cmd <- paste0("grep -c '>' " ,path[[6]])
clean <- system(cmd,intern = T)

cmd <- paste0("grep -c '>' " ,path[[7]])
abbfilt <- system(cmd,intern = T)

cmd <- paste0("grep -c '>' " ,path[[8]])
bimera <- system(cmd,intern = T)

cmd <- paste0("grep -c '>' " ,path[[9]])
clust <- system(cmd,intern = T)

cmd <- paste0("grep -c '>' " ,path[[10]])
agg <- system(cmd,intern = T)

# reads count
cmd <- paste0("grep -o -P '(?<=\\scount=)[0-9]+' ",path[[5]]," | awk -F: '{n+=$1} END {print n}'" )
derep_reads <- system(cmd,intern = T)

cmd <- paste0("grep -o -P '(?<=\\scount=)[0-9]+' ",path[[6]]," | awk -F: '{n+=$1} END {print n}'" )
clean_reads <- system(cmd,intern = T)

cmd <- paste0("grep -o -P '(?<=\\scount=)[0-9]+' ",path[[7]]," | awk -F: '{n+=$1} END {print n}'" )
abbfilt_reads <- system(cmd,intern = T)

cmd <- paste0("grep -o -P '(?<=\\scount=)[0-9]+' ",path[[8]]," | awk -F: '{n+=$1} END {print n}'" )
bimera_reads <- system(cmd,intern = T)

cmd <- paste0("grep -o -P '(?<=\\scount=)[0-9]+' ",path[[9]]," | awk -F: '{n+=$1} END {print n}'" )
clust_reads <- system(cmd,intern = T)

cmd <- paste0("grep -o -P '(?<=\\scount=)[0-9]+' ",path[[10]]," | awk -F: '{n+=$1} END {print n}'" )
agg_reads <- system(cmd,intern = T)

df <- data.frame(step=c("aligned",
                        "alignement qality filtering",
                        "demultiplexing",
                        "filter and trim",
                        "dereplication",
                        "obiclean",
                        "abbundance filtering",
                        "bimera removal",
                        "clustering",
                        "merging cluster"),
                 total_sequence=c(ali,
                                  qualali,
                                  dml,
                                  filtrim,
                                  derep,
                                  clean,
                                  abbfilt,
                                  bimera,
                                  clust,
                                  agg),
                 reads=c(ali,
                         qualali,
                         dml,
                         filtrim,
                         derep_reads,
                         clean_reads,
                         abbfilt_reads,
                         bimera_reads,
                         clust_reads,
                         agg_reads)
)
write.csv2(df,snakemake@output[[1]],row.names=F)