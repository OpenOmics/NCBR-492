#!/bin/sh

source /data/NCBR/apps/genome-assembly/conda/etc/profile.d/conda.sh
conda activate gtdbtk-2.1.1

cd ../data/manual_analysis/MAGs

mkdir tmp

gtdbtk classify_wf --genome_dir . --out_dir . --cpus 16 --tmpdir ./tmp --full_tree --force --extension fa

