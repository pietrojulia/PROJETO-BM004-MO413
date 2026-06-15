#!/bin/bash

# change working directory
cd /home/cristian/Downloads/Genomics/Projeto_BM004/

for file_name in "$@"
do

prefetch "$file_name"
fasterq-dump "$file_name" -O SRA/Polihormonais/

rm SRA/Polihormonais/sra/"${file_name}.sra"

# STEP 1: Run fastqc
read1="${file_name}_1.fastq"
read2="${file_name}_2.fastq"
fastqc "SRA/Polihormonais/$read1" "SRA/Polihormonais/$read2" -o fastqc/

# Esse trimed é só se vc quiser, não precisa necessariamente
# run trimmomatic to trim reads with poor quality
trimmomatic PE -threads 4 "SRA/Polihormonais/$read1" "SRA/Polihormonais/$read2" Trimmed_Data/"${file_name}_forward_paired.fastq" Trimmed_Data/"${file_name}_forward_unpaired.fastq" Trimmed_Data/"${file_name}_reverse_paired.fastq" Trimmed_Data/"${file_name}_reverse_unpaired.fastq" ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:True LEADING:20 TRAILING:20 MINLEN:50 -phred33

rm "SRA/Polihormonais/$read1" "SRA/Polihormonais/$read2"

fastqc "Trimmed_Data/${file_name}_forward_paired.fastq" "Trimmed_Data/${file_name}_reverse_paired.fastq" -o fastqc/

rm Trimmed_Data/"${file_name}_forward_unpaired.fastq"
rm Trimmed_Data/"${file_name}_reverse_unpaired.fastq"


# STEP 2: Run HISAT2

# run alignment
hisat2 -p 4 -q -x HISAT2/Homo_sapiens/genome --dta -1 Trimmed_Data/"${file_name}_forward_paired.fastq" -2 Trimmed_Data/"${file_name}_reverse_paired.fastq" | samtools sort -o HISAT2/Polihormonais/"${file_name}.bam"

rm Trimmed_Data/"${file_name}_forward_paired.fastq"
rm Trimmed_Data/"${file_name}_reverse_paired.fastq"

# STEP 3: Run stringtie - Quantification
stringtie -p 4 HISAT2/Polihormonais/"${file_name}.bam" -G Gene_anotation/Homo_sapiens.GRCh38.115.gtf -o counts/Polihormonais/"${file_name}.gtf"

done

# STEP 4: Merge

ls counts/Polihormonais/*.gtf > counts/Polihormonais/gtfs.txt

stringtie --merge -G Gene_anotation/Homo_sapiens.GRCh38.115.gtf -o counts/Polihormonais/cardio_merged.gtf $(cat counts/Polihormonais/gtfs.txt)

# STEP 5: Re-estimation
for file_name in "$@"
do

stringtie -p 4 -e -B HISAT2/Polihormonais/"${file_name}.bam" -G counts/Polihormonais/cardio_merged.gtf -o counts/Polihormonais/re_estimation/"${file_name}.gtf"

done


