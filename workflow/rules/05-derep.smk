# SPLIT FASTA FILES TO SPEED UP DEREPLICATION
checkpoint split_fasta:
	input:
		config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt.fasta"
	output:
		directory("{run}_derepl_tmp")
	params:
		folder="{run}/derepl_tmp",
		nfiles=config["split_fasta"]["nfiles"],
		tmp="{run}/derepl_tmp/tmp"
	conda:
		"../envs/obi_env.yaml"
	shell:
		"""
		mkdir {params.folder}
		obiannotate -S start:"hash(str(sequence))%{params.nfiles}" {input} | obisplit -t start -p {params.tmp}
		"""


# DEREPLICATION
rule derepl:
	input:
		"{run}/derepl_tmp/tmp{t}.fasta"
	output:
		"{run}/uniq/tmp_uniq{t}.fasta"
  benchmark:
	  "benchmarks/{run}/derep.txt"
  log:
		"log/{run}/derep.log
	conda:
		"../envs/obi_env.yaml"
	shell:
		"""
		obiuniq -m sample {input} > {output}
		"""
		
# AGGREGATE
def aggregate_derepl(wildcards):
        checkpoint_output=checkpoints.split_fasta.get(**wildcards).output[0]
        file_names=expand("{run}/uniq/tmp_uniq{t}.fasta", t=glob_wildcards(os.path.join(checkpoint_output, "tmp{t}.fasta")).t)
	# print('in_def_aggregate_derepl')
	# print(checkpoint_output)
	# print(glob_wildcards(os.path.join(checkpoint_output, "tmp{t}.fasta")).t)
	# print(file_names)
        return file_names


# MERGE DEREPLICATED FILES
rule merge_derepl:
	input:
		aggregate_derepl
	output:
		"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl.fasta"
	params:
    derepl="{run}/derepl_tmp",
		uniq="{run}/uniq"
	log:
		"log/{run}/merge_derepl.log"
	shell:
		"""
		cat {input} > {output} 2> {log}
		rm -r {params.derepl} {params.uniq}
		"""