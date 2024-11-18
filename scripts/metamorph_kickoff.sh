#!/bin/sh

# load module
module load snakemake singularity

# get file list as a txt file

## change dir to the merged file dir

echo "DNA" > ../../../scripts/rawdata.merged.filelist.txt
ls $PWD/* -1 > ../../../scripts/rawdata.merged.filelist.txt

# dry run
../metamorph/metamorph run --input rawdata.merged.filelist.txt --output ../data/metamorph_output/ --mode local --dry-run
# real kick off
../metamorph/metamorph run --input rawdata.merged.filelist.txt --output ../data/metamorph_output/ --mode slurm
