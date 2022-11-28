# Benchmark
rule benchmark:
  input:
    config["benchmarksfolder"]+"{run}/abbfilt.txt",
    config["benchmarksfolder"]+"{run}/alifilt.txt",
    config["benchmarksfolder"]+"{run}/bimera.txt",
    config["benchmarksfolder"]+"{run}/clust.txt",
    config["benchmarksfolder"]+"{run}/dada_prep.txt",
    config["benchmarksfolder"]+"{run}/deml.txt",
    config["benchmarksfolder"]+"{run}/derep.txt",
    config["benchmarksfolder"]+"{run}/filt_and_trim.txt",
    config["benchmarksfolder"]+"{run}/merge_clust.txt",
    config["benchmarksfolder"]+"{run}/obiclean.txt",
    config["benchmarksfolder"]+"{run}/seq_track.txt",
    config["benchmarksfolder"]+"{run}/tabformat.txt",
    config["benchmarksfolder"]+"{run}/taxassign.txt"
  output:
    report("benchmarks/{run}/{run}_benchmark.png")
  log:
    "log/{run}/benchmark.log"
  conda:
    "../envs/R_env.yaml"
  script:
    "../scripts/benchmark.R"
