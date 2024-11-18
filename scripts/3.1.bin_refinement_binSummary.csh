#!/bin/sh

cd /data/NCBR/projects/NCBR-492/data/manual_analysis/bin_refinement

header=$(head -n 1 SF1/metawrap_70_5_bins.stats)
echo -e "Sample\t$header" > metawrap_70_5_bins.merged.stats

for file in */metawrap_70_5_bins.stats; do
    dirname=$(basename "$(dirname "$file")")
    tail -n +2 "$file" | awk -v prefix="$dirname" '{print prefix "\t" $0}'
done >> metawrap_70_5_bins.merged.stats
