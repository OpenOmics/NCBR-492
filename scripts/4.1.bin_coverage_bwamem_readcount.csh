#!/bin/bash

#SBATCH
#SBATCH --job-name=binCov
#SBATCH --time=10-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=norm
#SBATCH --mem=50g
#SBATCH --array=1-11
#SBATCH --output=slurm-binCovBWA_%A_%a.out     # Custom output file name with job ID and array task ID
#SBATCH --error=slurm-binCovBWA_%A_%a.err      # Custom error file name with job ID and array task ID

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

# INPUT FILE
TRIMMED_R1=${TRIMMED}/${PR}.trimmed.R1.fastq
TRIMMED_R2=${TRIMMED}/${PR}.trimmed.R2.fastq
TRIMMED_R1_LINK=${TRIMMED}/${PR}.trimmed_1.fastq
TRIMMED_R2_LINK=${TRIMMED}/${PR}.trimmed_2.fastq

SCAFFOLDS=${ASSEMBLY}/${PR}/scaffolds.fasta
BIN_REF_FA=${BIN_REF}/metawrap_70_5_bins/bin.1.fa
MAG_FA=${MAG}/${PR}_metawrap.bin.1.fa

# PREPARE
#mkdir -p ${MAG}
#cp ${BIN_REF_FA} ${MAG_FA}

# PROCEDURE

# BIN COVERAGE
echo "Input MAG is ${BIN_REF_FA} -> ${MAG_FA}"
echo "Input trimmed R1 is ${TRIMMED_R1}"
echo "Input trimmed R2 is ${TRIMMED_R2}"
echo "Output saved in ${MAG}"

ml samtools/1.21

# 1. convert sam to bam
samtools view -S -b ${MAG}/${PR}_bwamem.sam > ${MAG}/${PR}_bwamem.bam

# 2. count total reads 
# To exclude both secondary and supplementary alignments, use -F 2304
total_reads=$(samtools view -@ 16  -c -F 2304 ${MAG}/${PR}_bwamem.bam)

# 3. count mapped reads (only when both reads in a pair mapped are considered)
# -f 3: This flag includes only properly paired reads, meaning both reads in the pair are mapped.
# -F 2820: This excludes secondary, supplementary, duplicate, and unmapped reads, ensuring that only primary, mapped, non-duplicate reads are counted.
mapped_reads=$(samtools view -@ 16 -c -f 3 -F 2820 ${MAG}/${PR}_bwamem.bam)
mapped_fraction=$((${mapped_reads} / ${total_reads}))

echo "sample = ${PR}, total_reads = ${total_reads}, mapped_reads = ${mapped_reads}, mapped_fraction = ${mapped_fraction}"
echo "${PR}, ${total_reads}, ${mapped_reads}, ${mapped_fraction}" >> ${MAG}/MAG.bwamem.mapped

