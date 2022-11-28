# Benchmark plotting
log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library(ggplot2)
library(ggpubr)

#bench_files <- list.files(path = ,full.names = T)
bench <- do.call(rbind, lapply(unlist(snakemake@input), read.table, sep="\t",header=T))
bench$steps <- gsub(basename(unlist(snakemake@input)),pattern=".txt",replacement = "")


plot_list <- list()
for (i in 1:(ncol(bench)-1)){
  plot_list[[i]] <- ggplot(bench,aes(y=bench[,i], x=steps)) +
    theme(axis.text.x = element_text(angle = 45))+
  # scale_x_discrete(guide = guide_axis(n.dodge=3))+
    ylab(names(bench)[i])+
    geom_boxplot()
}

plot_bench <- ggarrange(plotlist = plot_list,ncol = 3,nrow=ceiling(i/3))
ggsave(plot_bench,filename = snakemake@output[[1]], device = "png", height = 10, width = 10)

