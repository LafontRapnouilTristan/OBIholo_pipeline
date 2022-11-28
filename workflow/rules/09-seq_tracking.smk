rule seq_tracking:
  input:
    config["resultsfolder"]+"{run}/{run}_R1R2.fastq", # total aligned reads
    config["resultsfolder"]+"{run}/{run}_R1R2_good.fastq", # after filtering
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed.fastq", # after deml
    config["resultsfolder"]+"{run}/dada2_trimmed_fastq", # trimmed dada2
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_filtAndTrim_derep.fasta", # dereplicated
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_filtAndTrim_derep_cleaned.fasta", # cleaned
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_filtAndTrim_derep_cleaned_abfilt.fasta", # abb filtered
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_filtAndTrim_derep_cleaned_abfilt_bimerafree.fasta", # bimerafree
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_filtAndTrim_derep_cleaned_abfilt_bimerafree_cl.fasta", # clustered
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_filtAndTrim_derep_cleaned_abfilt_bimerafree_cl_agg.fasta", # merged
  output:
    config["resultsfolder"]+"{run}/{run}_seq_tracking.csv"
  benchmark:
    "benchmarks/{run}/seq_track.txt" 
  log:
    "log/{run}/seqtrack.log"
  conda:
    "../envs/R_env.yaml"
  script:
    "../scripts/seq_tracking.R"
