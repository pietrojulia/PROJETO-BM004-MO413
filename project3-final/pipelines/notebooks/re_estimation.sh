#!/bin/bash

# change working directory
cd /home/cristian/Downloads/Genomics/Projeto_BM004/

for file_name in "$@"
do

# STEP 3: Run stringtie - Quantification
#stringtie -p 4 -e -B HISAT2/Cardiomiocitos/"${file_name}.bam" -G counts/Cardiomiocitos/cardio_merged.gtf -o counts/Cardiomiocitos/re_estimation/"${file_name}.gtf"

stringtie -p 4 -e -B HISAT2/Polihormonais/"${file_name}.bam" -G counts/Polihormonais/poli_merged.gtf -o counts/Polihormonais/re_estimation/"${file_name}.gtf"

done
