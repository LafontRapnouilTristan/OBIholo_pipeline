# BASIC FILTRATION
rule basicfilt:
	input:
		config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed.fasta"
	output:
		config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt.fasta"
	params:
		minlength=config["basicfilt"]["minlength"],
		mincount=config["basicfilt"]["mincount"]
		minqual=config["basicfilt"]["minqual"]
	log:
		"log/{run}/basicfilt.log"
	conda:
		"../envs/obi_env.yaml"
	shell:
		"""
		obiannotate --length -S 'GC_content:len(str(sequence).replace("a","").replace("t",""))*100/len(sequence)' {input} | obigrep -l {params.minlength} -s '^[acgt]+$' -p 'count>{params.mincount} and avg_quality>{params.minqual}' > {output} 2> {log}
		"""