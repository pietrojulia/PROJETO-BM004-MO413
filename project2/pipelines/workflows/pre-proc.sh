#!/bin/bash

#000_input
make -C 000_input/fastq download
make -C 000_input/gen.index genome
make -C 000_input/ref.genome Homo_sapiens.GRCh38.84.gtf

path_input=000_input/fastq/*.fastq.gz
SAMPLE=$(find $path_input -type f -printf "%f\n" | sed 's/\.fastq.gz//;s/[_].*$//' | sort -u)
echo $SAMPLE

#005_preqc
for s in $SAMPLE; do
    make -C 005_preqc ${s}_1_fastqc.html
    make -C 005_preqc ${s}_2_fastqc.html
done

#010_trim
for s in $SAMPLE; do
    make -C 010_trim ${s}_1.paired.fastq.gz
done

#015_posqc
for s in $SAMPLE; do
    make -C 015_posqc ${s}_1.paired_fastqc.html
    make -C 015_posqc ${s}_2.paired_fastqc.html
done

#020_map
for s in $SAMPLE; do
    make -C 020_map ${s}.paired.sam
done

#025_sam
for s in $SAMPLE; do
    make -C 025_sam ${s}.paired.bam
done

#030_assemble
for s in $SAMPLE; do
    make -C 030_assemble ${s}.paired.gtf
done
