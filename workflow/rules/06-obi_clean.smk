# Obiclean
rule obiclean:
  input: 
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl.fasta"
  output:
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned.fasta"
  params:
    ratio=config["obiclean"]["ratio"]
  benchmark:
    "benchmarks/{run}/obiclean.txt" 
  log:
    "log/{run}/obiclean.log"
  conda:
    "../envs/obi_env.yaml"
  shell:
    """
    obiclean -s merged_sample -r {params.ratio} -H {input} > {output}
    """
