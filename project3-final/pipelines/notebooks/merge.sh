# Matrix creation

cd /home/cristian/Downloads/Genomics/Projeto_BM004/counts/Cardiomiocitos

gtf_1="$1"
gtf_2="$2"
gtf_3="$3"
gtf_4="$4"
gtf_5="$5"
gtf_6="$6"

stringtie --merge -G ../../Gene_anotation/Homo_sapiens.GRCh38.115.gtf -o cardio_merged.gtf "$gtf_1" "$gtf_2" "$gtf_3" "$gtf_4" "$gtf_5" "$gtf_6" 
