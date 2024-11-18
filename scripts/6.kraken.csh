#!/bin/bash

#SBATCH
#SBATCH --job-name=kraken
#SBATCH --time=10-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=norm
#SBATCH --mem=300g
#SBATCH --array=1-11
#SBATCH --output=slurm-kraken_%A_%a.out     # Custom output file name with job ID and array task ID
#SBATCH --error=slurm-kraken_%A_%a.err      # Custom error file name with job ID and array task ID

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
MAG=/data/NCBR/projects/NCBR-492/data/manual_analysis/MAGs
KRAKEN=/data/NCBR/projects/NCBR-492/data/manual_analysis/kraken

# INPUT FILE
TRIMMED_R1=${TRIMMED}/${PR}.trimmed.R1.fastq
TRIMMED_R2=${TRIMMED}/${PR}.trimmed.R2.fastq
TRIMMED_R1_LINK=${TRIMMED}/${PR}.trimmed_1.fastq
TRIMMED_R2_LINK=${TRIMMED}/${PR}.trimmed_2.fastq

SCAFFOLDS=${ASSEMBLY}/${PR}/scaffolds.fasta
BIN_REF_FA=${BIN_REF}/metawrap_70_5_bins/bin.1.fa
MAG_FA=${MAG}/${PR}_metawrap.bin.1.fa

# PREPARE
mkdir -p ${KRAKEN}

# PROCEDURE

# KRAKEN
echo "Input trimmed R1 is ${TRIMMED_R1}"
echo "Input trimmed R2 is ${TRIMMED_R2}" 
echo "Output saved in ${KRAKEN}"

module load kraken/2.1.2

kraken2 --db /data/NIDDK_IDSS/rawdata/NIDDK-13/k2_pluspf_20221209 \
--threads 16 \
--paired ${TRIMMED_R1} ${TRIMMED_R2} \
--report ${KRAKEN}/${PR}.kraken.taxa.txt \
--output ${KRAKEN}/${PR}.kraken.out.txt

echo "Kraken done!"

