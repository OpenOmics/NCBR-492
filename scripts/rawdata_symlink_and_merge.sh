#!/bin/sh

cd /data/NCBR/projects/NCBR-492/data/rawdata_symlinks/symlinks

# symlink all raw data files
find /data/NCBR/rawdata/NCBR-492/usftp21.novogene.com/01.RawData -type f -name *.gz -exec ln -s {} ./ \;

# merge lanes
mkdir -p ../merged 

for i in $(ls * | sed "s/_.*//" | uniq); \
do echo $i ${i}_*_1.fq.gz merging as "../merged/${i}.R1.fastq.gz"; \
echo $i ${i}_*_2.fq.gz merging as "../merged/${i}.R2.fastq.gz"; \
cat ${i}_*_1.fq.gz > ../merged/${i}.R1.fastq.gz; \
cat ${i}_*_2.fq.gz > ../merged/${i}.R2.fastq.gz; \
done

# records:

SF10 SF10_CKDN240014872-1A_225TCTLT4_L3_1.fq.gz merging as ../merged/SF10.R1.fastq.gz
SF10 SF10_CKDN240014872-1A_225TCTLT4_L3_2.fq.gz merging as ../merged/SF10.R2.fastq.gz
SF12 SF12_CKDN240014873-1A_225TCTLT4_L3_1.fq.gz SF12_CKDN240014873-1A_22FWGFLT4_L2_1.fq.gz merging as ../merged/SF12.R1.fastq.gz
SF12 SF12_CKDN240014873-1A_225TCTLT4_L3_2.fq.gz SF12_CKDN240014873-1A_22FWGFLT4_L2_2.fq.gz merging as ../merged/SF12.R2.fastq.gz
SF17 SF17_CKDN240014874-1A_227NLCLT4_L1_1.fq.gz SF17_CKDN240014874-1A_22FT5WLT4_L2_1.fq.gz merging as ../merged/SF17.R1.fastq.gz
SF17 SF17_CKDN240014874-1A_227NLCLT4_L1_2.fq.gz SF17_CKDN240014874-1A_22FT5WLT4_L2_2.fq.gz merging as ../merged/SF17.R2.fastq.gz
SF18 SF18_CKDN240014875-1A_227NLCLT4_L8_1.fq.gz SF18_CKDN240014875-1A_22FT5WLT4_L2_1.fq.gz merging as ../merged/SF18.R1.fastq.gz
SF18 SF18_CKDN240014875-1A_227NLCLT4_L8_2.fq.gz SF18_CKDN240014875-1A_22FT5WLT4_L2_2.fq.gz merging as ../merged/SF18.R2.fastq.gz
SF1 SF1_CKDN240014865-1A_227NLCLT4_L2_1.fq.gz SF1_CKDN240014865-1A_22FT5WLT4_L3_1.fq.gz merging as ../merged/SF1.R1.fastq.gz
SF1 SF1_CKDN240014865-1A_227NLCLT4_L2_2.fq.gz SF1_CKDN240014865-1A_22FT5WLT4_L3_2.fq.gz merging as ../merged/SF1.R2.fastq.gz
SF2 SF2_CKDN240014866-1A_227NLCLT4_L2_1.fq.gz merging as ../merged/SF2.R1.fastq.gz
SF2 SF2_CKDN240014866-1A_227NLCLT4_L2_2.fq.gz merging as ../merged/SF2.R2.fastq.gz
SF3 SF3_CKDN240014867-1A_225TCTLT4_L3_1.fq.gz merging as ../merged/SF3.R1.fastq.gz
SF3 SF3_CKDN240014867-1A_225TCTLT4_L3_2.fq.gz merging as ../merged/SF3.R2.fastq.gz
SF4 SF4_CKDN240014868-1A_227NLCLT4_L2_1.fq.gz merging as ../merged/SF4.R1.fastq.gz
SF4 SF4_CKDN240014868-1A_227NLCLT4_L2_2.fq.gz merging as ../merged/SF4.R2.fastq.gz
SF5 SF5_CKDN240014869-1A_225TCTLT4_L3_1.fq.gz merging as ../merged/SF5.R1.fastq.gz
SF5 SF5_CKDN240014869-1A_225TCTLT4_L3_2.fq.gz merging as ../merged/SF5.R2.fastq.gz
SF6 SF6_CKDN240014870-1A_225TCTLT4_L3_1.fq.gz merging as ../merged/SF6.R1.fastq.gz
SF6 SF6_CKDN240014870-1A_225TCTLT4_L3_2.fq.gz merging as ../merged/SF6.R2.fastq.gz
SF8 SF8_CKDN240014871-1A_225TCTLT4_L3_1.fq.gz merging as ../merged/SF8.R1.fastq.gz
SF8 SF8_CKDN240014871-1A_225TCTLT4_L3_2.fq.gz merging as ../merged/SF8.R2.fastq.gz

