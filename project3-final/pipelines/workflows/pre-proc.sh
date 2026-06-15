#bin/bash

set -euo pipefail

SRR="${1:-}"

if [ -z "$SRR" ]; then
  echo "Uso: ./pipeline_stringtie.sh SRRXXXX"
  exit 1
fi

BASE_DIR="$(pwd)"
PREFIX="STR"
SAMPLE_NAME="${PREFIX}_${SRR}"
WORK_DIR="$BASE_DIR/$SAMPLE_NAME"

TIME_LOG="$BASE_DIR/tempo_detalhado_pipeline_stringtie.csv"

########################################
# FUNÇÃO DE TEMPO
########################################
measure_time() {
  local STEP_NAME="$1"
  local START
  local END
  local DURATION

  START=$(date +%s)
  shift
  "$@"
  END=$(date +%s)
  DURATION=$((END - START))

  echo "pipeline_stringtie.sh,$SRR,$STEP_NAME,$DURATION" >> "$TIME_LOG"
  echo "Tempo [$STEP_NAME]: ${DURATION}s"
}

########################################
# DIRETÓRIOS
########################################
FASTQ_DIR="$WORK_DIR/fastq"
QC_RAW_DIR="$WORK_DIR/qc_raw"
QC_TRIM_DIR="$WORK_DIR/qc_trim"
ALIGN_DIR="$WORK_DIR/align"
STRINGTIE_DIR="$WORK_DIR/stringtie"
BALLGOWN_DIR="$WORK_DIR/ballgown"
LOG_DIR="$WORK_DIR/logs"

GENOME_INDEX="$BASE_DIR/genome/grch38/genome"
ANNOTATION_GTF="$BASE_DIR/annotation/gencode.v44.annotation.nochr.gtf"
MERGE_DIR="$BASE_DIR/merge"
MATRIX_DIR="$BASE_DIR/matrices"
PREPDE_SCRIPT="$BASE_DIR/prepDE.py3"

THREADS=4
MERGELIST="$MERGE_DIR/mergelist.txt"
MERGED_GTF="$MERGE_DIR/stringtie_merged.gtf"
SAMPLE_LIST="$MATRIX_DIR/sample_lst.txt"

mkdir -p "$WORK_DIR" \
         "$FASTQ_DIR" \
         "$QC_RAW_DIR" \
         "$QC_TRIM_DIR" \
         "$ALIGN_DIR" \
         "$STRINGTIE_DIR" \
         "$BALLGOWN_DIR" \
         "$LOG_DIR" \
         "$MERGE_DIR" \
         "$MATRIX_DIR"

########################################
# VALIDAÇÕES
########################################
for cmd in prefetch fasterq-dump fastqc hisat2 samtools stringtie python3 java find; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Erro: comando não encontrado -> $cmd"
    exit 1
  fi
done

if [ ! -f "/usr/share/java/trimmomatic.jar" ]; then
  echo "Erro: Trimmomatic não encontrado em /usr/share/java/trimmomatic.jar"
  exit 1
fi

if [ ! -f "${GENOME_INDEX}.1.ht2" ] && [ ! -f "${GENOME_INDEX}.1.ht2l" ]; then
  echo "Erro: índice do HISAT2 não encontrado -> $GENOME_INDEX"
  exit 1
fi

if [ ! -f "$ANNOTATION_GTF" ]; then
  echo "Erro: annotation não encontrada -> $ANNOTATION_GTF"
  exit 1
fi

if [ ! -f "$PREPDE_SCRIPT" ]; then
  echo "Erro: prepDE.py3 não encontrado -> $PREPDE_SCRIPT"
  exit 1
fi

if [ ! -f "$TIME_LOG" ]; then
  echo "pipeline,amostra,etapa,segundos" > "$TIME_LOG"
fi

########################################
# PIPELINE
########################################
START_TOTAL=$(date +%s)

echo "=============================="
echo "Processando: $SRR"
echo "=============================="

measure_time download_sra prefetch "$SRR"

measure_time fasterq_dump fasterq-dump --split-files "$SRR" -O "$FASTQ_DIR"

measure_time fastqc_bruto fastqc \
  "$FASTQ_DIR/${SRR}_1.fastq" \
  "$FASTQ_DIR/${SRR}_2.fastq" \
  -o "$QC_RAW_DIR"

measure_time trimmomatic java -jar /usr/share/java/trimmomatic.jar PE \
  "$FASTQ_DIR/${SRR}_1.fastq" \
  "$FASTQ_DIR/${SRR}_2.fastq" \
  "$FASTQ_DIR/${SRR}_1_paired.fastq" \
  "$FASTQ_DIR/${SRR}_1_unpaired.fastq" \
  "$FASTQ_DIR/${SRR}_2_paired.fastq" \
  "$FASTQ_DIR/${SRR}_2_unpaired.fastq" \
  LEADING:20 TRAILING:20 SLIDINGWINDOW:4:20 MINLEN:50

measure_time fastqc_pos_trim fastqc \
  "$FASTQ_DIR/${SRR}_1_paired.fastq" \
  "$FASTQ_DIR/${SRR}_2_paired.fastq" \
  -o "$QC_TRIM_DIR"

measure_time hisat2 hisat2 --dta -p "$THREADS" \
  -x "$GENOME_INDEX" \
  -1 "$FASTQ_DIR/${SRR}_1_paired.fastq" \
  -2 "$FASTQ_DIR/${SRR}_2_paired.fastq" \
  -S "$ALIGN_DIR/${SRR}.sam"

measure_time sam_to_bam bash -c "samtools view -bS '$ALIGN_DIR/${SRR}.sam' > '$ALIGN_DIR/${SRR}.bam'"

measure_time sort_bam samtools sort \
  -@ "$THREADS" \
  "$ALIGN_DIR/${SRR}.bam" \
  -o "$ALIGN_DIR/${SRR}_sorted.bam"

measure_time index_bam samtools index "$ALIGN_DIR/${SRR}_sorted.bam"

measure_time stringtie_assemble stringtie \
  "$ALIGN_DIR/${SRR}_sorted.bam" \
  -G "$ANNOTATION_GTF" \
  -p "$THREADS" \
  -o "$STRINGTIE_DIR/${SAMPLE_NAME}.gtf" \
  -A "$STRINGTIE_DIR/${SAMPLE_NAME}_gene_abund.tab"

########################################
# MERGE GLOBAL
########################################
: > "$MERGELIST"

find "$BASE_DIR" \
  -maxdepth 3 \
  -type f \
  -path "$BASE_DIR/STR_*/stringtie/STR_SRR*.gtf" \
  | sort > "$MERGELIST"

if [ ! -s "$MERGELIST" ]; then
  echo "Erro: mergelist ficou vazio. Nenhum GTF encontrado para merge."
  exit 1
fi

measure_time merge stringtie --merge \
  -G "$ANNOTATION_GTF" \
  -o "$MERGED_GTF" \
  "$MERGELIST"

########################################
# RE-ESTIMATION
########################################
measure_time reestimate stringtie \
  "$ALIGN_DIR/${SRR}_sorted.bam" \
  -e -B \
  -G "$MERGED_GTF" \
  -p "$THREADS" \
  -o "$BALLGOWN_DIR/${SAMPLE_NAME}.gtf"

########################################
# MATRIZ
########################################
: > "$SAMPLE_LIST"

find "$BASE_DIR" \
  -maxdepth 1 \
  -type d \
  -name "STR_SRR*" \
  | sort | while read -r dir; do
    name=$(basename "$dir")
    gtf="$dir/ballgown/${name}.gtf"

    if [ -f "$gtf" ]; then
      echo -e "${name}\t${gtf}" >> "$SAMPLE_LIST"
    fi
done

if [ ! -s "$SAMPLE_LIST" ]; then
  echo "Erro: sample_lst.txt ficou vazio."
  exit 1
fi

measure_time prepDE python3 "$PREPDE_SCRIPT" \
  -i "$SAMPLE_LIST" \
  -g "$MATRIX_DIR/gene_count_matrix.csv" \
  -t "$MATRIX_DIR/transcript_count_matrix.csv"

########################################
# LIMPEZA
########################################
measure_time limpeza bash -c "
rm -f '$ALIGN_DIR/${SRR}.sam'
rm -f '$ALIGN_DIR/${SRR}.bam'
"

END_TOTAL=$(date +%s)
TOTAL=$((END_TOTAL - START_TOTAL))

echo "pipeline_stringtie.sh,$SRR,total,$TOTAL" >> "$TIME_LOG"

echo "Tempo total: ${TOTAL}s"
echo "FINALIZADO: $SRR"
echo "Log de tempo: $TIME_LOG"


