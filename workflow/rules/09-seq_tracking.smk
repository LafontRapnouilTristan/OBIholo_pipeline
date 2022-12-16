rule seq_tracking:
  input:
    config["resultsfolder"]+"{run}/{run}_R1R2.fastq", # total aligned reads
    config["resultsfolder"]+"{run}/{run}_R1R2_good.fastq", # after filtering
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed.fasta", # after deml
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt.fasta", # filt
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl.fasta", # dereplicated
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned.fasta", # cleaned
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned_cl.fasta", # clustered
    config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl_cleaned_cl_agg.fasta", # merged
  output:
    config["resultsfolder"]+"{run}/{run}_seq_tracking.csv",
    config["resultsfolder"]+"{run}/{run}_seq_tracking_deml.txt",
    config["resultsfolder"]+"{run}/{run}_reads_tracking_deml.txt",
    config["resultsfolder"]+"{run}/{run}_seq_tracking_basfilt.txt",
    config["resultsfolder"]+"{run}/{run}_reads_tracking_basfilt.txt",
    config["resultsfolder"]+"{run}/{run}_derep.sampstat",
    config["resultsfolder"]+"{run}/{run}_clean.sampstat",
    config["resultsfolder"]+"{run}/{run}_clust.sampstat",
    config["resultsfolder"]+"{run}/{run}_agg.sampstat"
  params:
    "derep",
    "clean",
    "clust",
    "agg"
  benchmark:
    "benchmarks/{run}/seq_track.txt"
  log:
    "log/{run}/seqtrack.log"
  conda:
    "../envs/R_env.yaml"
  script:
    "../scripts/seq_tracking.R"
