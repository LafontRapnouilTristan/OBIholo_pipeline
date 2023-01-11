# SPLIT FASTA FILES TO SPEED UP DEREPLICATION
checkpoint split_fasta:
    input:
        config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt.fasta"
    output:
        directory(config["resultsfolder"]+"{run}/derepl_tmp")
    params:
        folder=config["resultsfolder"]+"{run}/derepl_tmp",
        nfiles=config["split_fasta"]["nfiles"],
        tmp=config["resultsfolder"]+"{run}/derepl_tmp/tmp"
    conda:
        "../envs/obi_env.yaml"
    shell:
        """
        mkdir {params.folder}
        obiannotate -S start:"hash(str(sequence))%{params.nfiles}" {input} | obisplit -t start -p {params.tmp}
        """

# AGGREGATE
def aggregate_derepl1(wildcards):
        checkpoint_output=checkpoints.split_fasta.get(**wildcards).output[0]
        file_names=expand("{run}/derepl_tmp/tmp{t}.fasta", t=glob_wildcards(os.path.join(checkpoint_output, "tmp{t}.fasta")).t)
    # print('in_def_aggregate_derepl')
    # print(checkpoint_output)
    # print(glob_wildcards(os.path.join(checkpoint_output, "tmp{t}.fasta")).t)
    # print(file_names)
        return file_names
        
# DEREPLICATION
rule derepl:
    input:
        aggregate_derepl1
    output:
        config["resultsfolder"]+"{run}/uniq/tmp_uniq{t}.fasta"
    benchmark:
        config["benchmarksfolder"]+"{run}/derep_{t}.txt"
    log:
        "log/{run}/derep{t}.log"
    conda:
        "../envs/obi_env.yaml"
    shell:
        """
        obiuniq -m sample {input} > {output}
        """

# AGGREGATE
def aggregate_derepl2(wildcards):
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
        splitted=aggregate_derepl2,
        benchin=config["benchmarksfolder"]+"{run}/derep_*.txt"
    output:
        dereped=config["resultsfolder"]+"{run}/{run}_R1R2_good_demultiplexed_basicfilt_derepl.fasta",
        bench=config["benchmarksfolder"]+"{run}/derep.txt"
    params:
        derepl=config["resultsfolder"]+"{run}/derepl_tmp",
        uniq=config["resultsfolder"]+"{run}/uniq"
    log:
        "log/{run}/merge_derepl.log"
    shell:
        """
        cat {input.splitted} > {output.dereped} 2> {log}
        rm -r {params.derepl} {params.uniq}
        tail -n +2 -q {input.benchin} | cat | awk '{{for(i=1;i<=NF;i++)$i=(a[i]+=$i)}}END{{print}}' > {output.bench}
        """
