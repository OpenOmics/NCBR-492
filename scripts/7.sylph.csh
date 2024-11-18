#!/bin/bash

#SBATCH
#SBATCH --job-name=sylph
#SBATCH --time=10-00:00:00
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=norm
#SBATCH --mem=200g

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
SYLPH=/data/NCBR/projects/NCBR-492/data/manual_analysis/sylph

# INPUT FILE
TRIMMED_R1=${TRIMMED}/${PR}.trimmed.R1.fastq
TRIMMED_R2=${TRIMMED}/${PR}.trimmed.R2.fastq
TRIMMED_R1_LINK=${TRIMMED}/${PR}.trimmed_1.fastq
TRIMMED_R2_LINK=${TRIMMED}/${PR}.trimmed_2.fastq

SCAFFOLDS=${ASSEMBLY}/${PR}/scaffolds.fasta
BIN_REF_FA=${BIN_REF}/metawrap_70_5_bins/bin.1.fa
MAG_FA=${MAG}/${PR}_metawrap.bin.1.fa

# PREPARE
mkdir -p ${SYLPH}

# PROCEDURE

# SKETCH READS 
/data/NHLBI_IDSS/tools/sylph/sylph sketch -1 ${TRIMMED}/*.trimmed.R1.fastq -2 ${TRIMMED}/*.trimmed.R2.fastq -d ${SYLPH}/sketches -t 16 || fail "sketching failed"
echo "All reads are sketched"

# Query using bacterial and viral database
/data/NHLBI_IDSS/tools/sylph/sylph query ${SYLPH}/sketches/*.sylsp /data/NHLBI_IDSS/tools/sylph/prebuilt-database/gtdb-r220-c200-dbv1.syldb /data/NHLBI_IDSS/tools/sylph/prebuilt-database/imgvr_c200_v0.3.0.syldb -t 16 -o ${SYLPH}/query.tsv || fail "query failed"
echo "Query done"

# Profile using the same database
/data/NHLBI_IDSS/tools/sylph/sylph profile ${SYLPH}/sketches/*.sylsp /data/NHLBI_IDSS/tools/sylph/prebuilt-database/gtdb-r220-c200-dbv1.syldb /data/NHLBI_IDSS/tools/sylph/prebuilt-database/imgvr_c200_v0.3.0.syldb -t 16 -o ${SYLPH}/profile.tsv || fail "profile failed"

echo "Profile done!"

