# taxassign
rule taxassign_12:
  input:
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned_cl_agg.fasta"
  output:
    config["resultsfolder"]+"{run}/{run}_taxassigned.csv"
  params:
    config["taxassign"]["multithread"],
    lambda wildcards: config["taxassign"]["tax_file_{}".format(wildcards.run)]
  benchmark:
    "benchmarks/{run}/taxassign.txt" 
  log:
    "log/{run}/taxassign.log"
  conda:
    "../envs/R_env.yaml"
  script:
    "../scripts/taxassign_dada2.R"
