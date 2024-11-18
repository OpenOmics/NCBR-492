#!/bin/sh

#SBATCH
#SBATCH --job-name=trim_assemb
#SBATCH --time=10-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=largemem
#SBATCH --mem=2000g
#SBATCH --array=1-11

# function to signal failure for specific command
function fail {
    echo "FAIL: $@" >&2
    exit 1  # signal failure
}

PR_LIST=sample.list
PR=`awk "NR==$SLURM_ARRAY_TASK_ID" $PR_LIST`

RAWREAD=/data/NCBR/projects/NCBR-492/data/rawdata_symlinks/merged
TRIMMED=/data/NCBR/projects/NCBR-492/data/manual_analysis/fastp
ASSEMBLY=/data/NCBR/projects/NCBR-492/data/manual_analysis/metaspades

# raw read trimming
module load fastp/0.23.2

mkdir -p $TRIMMED

fastp -w 8 \
      --detect_adapter_for_pe \
      --in1 ${RAWREAD}/${PR}.R1.fastq.gz \
      --in2 ${RAWREAD}/${PR}.R2.fastq.gz \
      --out1 ${TRIMMED}/${PR}.trimmed.R1.fastq.gz \
      --out2 ${TRIMMED}/${PR}.trimmed.R2.fastq.gz \
      --json ${TRIMMED}/${PR}.fastp.json \
      --html ${TRIMMED}/${PR}.fastp.html

# metaspades assembly

mkdir -p ${ASSEMBLY}/${PR}

date
ml spades/4.0.0

spades.py --meta \
	-1 ${TRIMMED}/${PR}.trimmed.R1.fastq.gz \
       	-2 ${TRIMMED}/${PR}.trimmed.R2.fastq.gz \
	-o ${ASSEMBLY}/${PR} \
	--threads 16 --memory 2000 || fail "assembly failed"
date

