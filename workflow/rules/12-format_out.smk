# TAB FORMATTING
rule tab_format_12:
  input:
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned_cl_agg.fasta"
  output:
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned_cl_agg.tab"
  benchmark:
    "benchmarks/{run}/tabformat.txt"   
  log:
    "log/{run}/tab_format.log"
  conda:
    "../envs/obi_env.yaml"
  shell:
    """
	  obitab -n NA -d -o {input} > {output} 2> {log}
		"""
