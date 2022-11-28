# Snakemake workflow

__author__ = "Tristan Lafont Rapnouil"
__email__ = "tristan.lafontrapnouil@gmail.com"

"""
DESCRIPTION

This is a snakemake workflow that analyzes DNA metabarcoding data with the OBITools and SUMACLUST.

"""
configfile:"config/config.yaml"
report:"report/workflow.rep"

# GET FINAL OUTPUT(S)
#def get_input_all():
#  if config["tomerge"]:
#    inputfiles = config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_filtAndTrim_derep_cleaned_abfilt_bimerafree_cl_agg.tab",
#  else:
#    inputfiles = expand("{folder}{run}/{run}_R1R2_good_demultiplexed_filtAndTrim_derep_cleaned_abfilt_bimerafree_cl_agg.tab",run = #config["fastqfiles"],folder = config["resultsfolder"]),
#  return inputfiles
#rule all:
#  input:
#    get_input_all()

rule all:
    input:
        expand(config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_filt_derep_cleaned_abfilt_cl_agg.tab",run = config["fastqfiles"]),
        expand(config["resultsfolder"]+"{run}/{run}_taxassigned.csv",run = config["fastqfiles"]),
        expand(config["resultsfolder"]+"{run}/{run}_seq_tracking.csv",run = config["fastqfiles"]),
        expand(config["benchmarksfolder"]+"{run}/{run}_benchmark.png",run = config["fastqfiles"])
        
include: "workflow/rules/01-pairing.smk"
include: "workflow/rules/02-sort_alignments.smk"
include: "workflow/rules/03-demultiplex.smk"
include: "workflow/rules/04-basic_filtration.smk"
include: "workflow/rules/05-derep.smk"
include: "workflow/rules/06-obi_clean.smk"
include: "workflow/rules/07-otu_clust.smk"
include: "workflow/rules/08-merge_clust.smk"
include: "workflow/rules/09-taxassign.smk"
include: "workflow/rules/09-format_out.smk",
include: "workflow/rules/09-seq_tracking.smk"
include: "workflow/rules/10-benchmark.smk"