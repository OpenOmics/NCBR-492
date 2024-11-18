#!/bin/bash

#SBATCH
#SBATCH --job-name=binning
#SBATCH --time=10-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=norm
#SBATCH --mem=300g
#SBATCH --array=1-11
#SBATCH --output=slurm-binning_%A_%a.out     # Custom output file name with job ID and array task ID
#SBATCH --error=slurm-binning_%A_%a.err      # Custom error file name with job ID and array task ID

# function to signal failure for specific command
function fail {
    echo "FAIL: $@" >&2
    exit 1  # signal failure
}

# INPUT SAMPLE NAME
PR_LIST=sample.list
PR=`awk "NR==$SLURM_ARRAY_TASK_ID" $PR_LIST`
# INPUT DIR
RAWREAD=/data/NCBR/projects/NCBR-492/data/rawdata_symlinks/merged
TRIMMED=/data/NCBR/projects/NCBR-492/data/manual_analysis/fastp
ASSEMBLY=/data/NCBR/projects/NCBR-492/data/manual_analysis/metaspades
BIN=/data/NCBR/projects/NCBR-492/data/manual_analysis/binning/${PR}
# INPUT FILE
TRIMMED_R1=${TRIMMED}/${PR}.trimmed.R1.fastq
TRIMMED_R2=${TRIMMED}/${PR}.trimmed.R2.fastq
TRIMMED_R1_LINK=${TRIMMED}/${PR}.trimmed_1.fastq
TRIMMED_R2_LINK=${TRIMMED}/${PR}.trimmed_2.fastq

SCAFFOLDS=${ASSEMBLY}/${PR}/scaffolds.fasta

# PROCEDURE
# GUNZIP TRIMMED READS
gunzip ${TRIMMED}/*.gz

# USING SOFT LINK TO RESOLVE TRIMMED READS FILE NAMES (metawrap required trimmed read suffix as _1.fastq _2.fastq)
ln -s $TRIMMED_R1 $TRIMMED_R1_LINK
ln -s $TRIMMED_R2 $TRIMMED_R2_LINK


# BINNING
mkdir -p ${BIN}
echo "Assembly file is ${SCAFFOLDS}"
echo "Trimmed reads file are ${TRIMMED_R1} ${TRIMMED_R2}"
echo "Trimmed reads link files are ${TRIMMED_R1_LINK} ${TRIMMED_R2_LINK}"
echo "Output saved in ${BIN}"

source /data/NCBR/apps/genome-assembly/conda/etc/profile.d/conda.sh; conda activate metawrap-env; source ~/.bash_profile;

metawrap binning  --metabat2 --maxbin2 --concoct -m 300 -t 16 -a ${SCAFFOLDS} -o ${BIN} ${TRIMMED_R1_LINK} ${TRIMMED_R2_LINK} || fail "binning failed"

conda deactivate

date

