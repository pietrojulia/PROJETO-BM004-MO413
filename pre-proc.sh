#!/bin/bash

path_input=000_input/fastq/*.fastq.gz
SAMPLE=$(find $path_input -type f -printf "%f\n" | sed 's/\.fastq.gz//;s/[_].*$//' | sort -u)
echo $SAMPLE

#000_input

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
#for s in $SAMPLE; do
#    make -C 020_map ${s}.paired.sam
#done
