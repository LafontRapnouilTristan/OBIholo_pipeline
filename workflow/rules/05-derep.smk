folder_prefix=config["resultsfolder"]+"{run}/"
folder_prefix2=config["resultsfolder"]+"{{run}}/"
files_prefix="{run}"

# SPLIT FASTA FILES TO SPEED UP DEREPLICATION
checkpoint split_fasta:
    input:
        folder_prefix+files_prefix+"_R1R2_good_demultiplexed_basicfilt.fasta"
    output:
        directory(folder_prefix+"derepl_tmp")
    params:
        folder=folder_prefix+"derepl_tmp",
        nfiles=config["split_fasta"]["nfiles"],
        tmp=folder_prefix+"derepl_tmp/tmp"
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
        folder_prefix+"derepl_tmp/tmp{t}.fasta"
    output:
        folder_prefix+"uniq/tmp_uniq{t}.fasta"
    conda:
        "../envs/obi_env.yaml"
    shell:
        """
        obiuniq -m sample {input} > {output}
        """
        
# AGGREGATE
def aggregate_derepl2(wildcards):
        checkpoint_output=checkpoints.split_fasta.get(**wildcards).output[0]
        file_names=expand(folder_prefix2+"uniq/tmp_uniq{t}.fasta", t=glob_wildcards(os.path.join(checkpoint_output, "tmp{t}.fasta")).t)
#    # print('in_def_aggregate_derepl')
#    # print(checkpoint_output)
#    # print(glob_wildcards(os.path.join(checkpoint_output, "tmp{t}.fasta")).t)
#    # print(file_names)
        return file_names
        	
# MERGE DEREPLICATED FILES
rule merge_derepl:
    input:
        aggregate_derepl2
    output:
        dereped=folder_prefix+files_prefix+"_R1R2_good_demultiplexed_basicfilt_derepl.fasta"
    params:
        derepl=folder_prefix+"derepl_tmp",
        uniq=folder_prefix+"uniq"
    log:
        "log/{run}/merge_derepl.log"
    shell:
        """
        cat {input} > {output.dereped} 2> {log}
        rm -r {params.derepl} {params.uniq}
        """
