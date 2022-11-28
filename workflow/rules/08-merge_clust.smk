# MERGE CLUSTERS
rule merge_clust_11:
  input:
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned_cl.fasta"
  output:
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned_cl_agg.fasta"
  benchmark:
    "benchmarks/{run}/merge_clust.txt" 
  log:
    "log/{run}/merge_clust.log"
  conda:
    "../envs/obi_env.yaml"
  shell:
    """
		obiselect -c cluster -n 1 --merge sample -M -f count {input} > {output} 2> {log}
		"""
