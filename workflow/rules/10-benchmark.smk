# Benchmark
rule benchmark:
  input:
    config["benchmarksfolder"]+"{run}/alifilt.txt",
    config["benchmarksfolder"]+"{run}/clust.txt",
    config["benchmarksfolder"]+"{run}/deml.txt",
#    config["benchmarksfolder"]+"{run}/derep.txt",
    config["benchmarksfolder"]+"{run}/merge_clust.txt",
    config["benchmarksfolder"]+"{run}/obiclean.txt",
    config["benchmarksfolder"]+"{run}/seq_track.txt",
    config["benchmarksfolder"]+"{run}/tabformat.txt",
    config["benchmarksfolder"]+"{run}/taxassign.txt"
  output:
    report("benchmarks/{run}/{run}_raw_benchmark.png"),
    report("benchmarks/{run}/{run}_log_benchmark.png"),
    "benchmarks/{run}/{run}_benchmark.csv"
  log:
    "log/{run}/benchmark.log"
  conda:
    "../envs/R_env.yaml"
  script:
    "../scripts/benchmark.R"
