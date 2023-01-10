#!/bin/bash
#SBATCH -J snakeflow
#SBATCH -p unlimitq
#SBATCH --mem=10G
#SBATCH --cpus-per-task=1
#SBATCH -o snakemake_output_%j.out
#SBATCH -e snakemake_error_%j.err
#SBATCH --mail-type=ALL

# Environment
module purge
module load bioinfo/snakemake-5.25.0
module load system/Miniconda3-4.7.10

# Variables
CONFIG=config/resources_genologin.yaml
COMMAND="sbatch --cpus-per-task={cluster.cpus} --time={cluster.time} --mem={cluster.mem} -J {cluster.jobname} -o snake_subjob_log/{cluster.jobname}.%N.%j.out -e snake_subjob_log/{cluster.jobname}.%N.%j.err"
CORES=100

# Workflow
snakemake -s Snakefile --use-conda --cluster-config $CONFIG --cluster "$COMMAND" --jobs $CORES --keep-going

