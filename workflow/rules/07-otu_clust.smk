# CLUSTERING
rule otu_clust:
  input:
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl.fasta"
  output:
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cl.fasta"
  params:
    minsim = config["clustering"]["minsim"],
    threads = config["clustering"]["cores"],
    ratio = config["clustering"]["ratio"]
  benchmark:
    "benchmarks/{run}/clust.txt" 
  log:
    "log/{run}/clustering.log"
  conda:
    "../envs/suma_env.yaml"
  shell:
    """
    sumaclust -t {params.minsim} -p {params.threads} -R {params.ratio} {input} > {output}
    """
