#!/bin/bash

#SBATCH
#SBATCH --job-name=binRef
#SBATCH --time=10-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=norm
#SBATCH --mem=300g
#SBATCH --array=1-11
#SBATCH --output=slurm-binref_%A_%a.out     # Custom output file name with job ID and array task ID
#SBATCH --error=slurm-binref_%A_%a.err      # Custom error file name with job ID and array task ID

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
BIN_REF=/data/NCBR/projects/NCBR-492/data/manual_analysis/bin_refinement/${PR}
# INPUT FILE
TRIMMED_R1=${TRIMMED}/${PR}.trimmed.R1.fastq
TRIMMED_R2=${TRIMMED}/${PR}.trimmed.R2.fastq
TRIMMED_R1_LINK=${TRIMMED}/${PR}.trimmed_1.fastq
TRIMMED_R2_LINK=${TRIMMED}/${PR}.trimmed_2.fastq

SCAFFOLDS=${ASSEMBLY}/${PR}/scaffolds.fasta

# PROCEDURE

# BIN REFINEMENT
mkdir -p ${BIN_REF}
echo "Input is ${BIN}"
echo "Output saved in ${BIN_REF}"

source /data/NCBR/apps/genome-assembly/conda/etc/profile.d/conda.sh; conda activate metawrap-env; source ~/.bash_profile;

metawrap bin_refinement -o ${BIN_REF} -t 16 -A ${BIN}/metabat2_bins/ -B ${BIN}/maxbin2_bins/ -C ${BIN}/concoct_bins/ -c 70 -x 5 || fail "bin refinement failed"

conda deactivate

date

