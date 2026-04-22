# Pipeline RNA-seq — StringTie (Implementação Real + Validação)

## 1. Objetivo 

Este pipeline tem como objetivo processar dados de RNA-seq a partir de arquivos SRA e gerar quantificação de expressão gênica e de transcritos utilizando o fluxo baseado em StringTie.

Além disso, o pipeline foi estruturado para:

- Ser automatizado por amostra (SRR)
- Gerar matrizes compatíveis com DESeq2
- Permitir comparação com featureCounts
- Medir tempo de execução por etapa

## 2. Estrutura Geral do Pipeline

O pipeline segue a seguinte sequência:

- Download dos dados (SRA)
- Conversão para FASTQ
- Controle de qualidade (pré e pós-trimming)
- Trimming das reads
- Alinhamento (HISAT2)
- Processamento BAM (Samtools)
- Montagem de transcritos (StringTie)
- Merge global de transcritos
- Re-estimation (quantificação final)
- Geração de matrizes (prepDE)
- Limpeza de arquivos intermediários
- Log de tempo por etapa

## 3. Organização de Diretórios

Para cada amostra, é criada a seguinte estrutura:

~~~
STR_<SRR>/
├── fastq/
├── qc_raw/
├── qc_trim/
├── align/
├── stringtie/
├── ballgown/
├── logs/
~~~

Além disso, diretórios globais:

```
merge/
matrices/
```

## 4. Pipeline — Etapas Detalhadas

- 4.1 Download dos dados
Ferramenta: SRA Toolkit

~~~
prefetch SRRXXXX
~~~

- 4.2 Conversão para FASTQ
~~~
fasterq-dump --split-files SRRXXXX
~~~

Saída: SRR_1.fastq e SRR_2.fastq

- 4.3. Controle de Qualidade (pré-trim)
Ferramenta: FastQC

~~~
fastqc *.fastq
~~~

- 4.4 Trimming
Ferramenta: Trimmomatic

Parâmetros utilizados:

```
LEADING:20

TRAILING:20

SLIDINGWINDOW:4:20

MINLEN:50
```

```
trimmomatic PE ...
```

Saída: reads paired + reads unpaired


- 4.5. Controle de Qualidade (pós-trim)
~~~
fastqc *_paired.fastq
~~~

- 4.6. Alinhamento
Ferramenta: HISAT2

Parâmetro crítico:

~~~
--dta → otimiza para montagem de transcritos

hisat2 --dta -x genome -1 R1 -2 R2 -S output.sam
~~~

- 4.7. Processamento BAM
Ferramenta: Samtools

Etapas:

```
samtools view -bS → BAM

samtools sort → BAM ordenado

samtools index → índice
```

- 4.8. Montagem de transcritos (StringTie)
~~~
stringtie sample_sorted.bam \
 -G annotation.gtf \
 -o sample.gtf \
 -A gene_abund.tab
~~~

Saídas: GTF com transcritos reconstruídos + Tabela de abundância por gene

## 5. Merge Global de Transcritos
Todos os GTFs são combinados:

```
stringtie --merge \
 -G annotation.gtf \
 -o merged.gtf \
 mergelist.txt
```

📌 Importante: O pipeline automaticamente coleta todos os .gtf pelo padrão: SR_\*/stringtie/\*.gtf

## 6. Re-estimation (Quantificação Final)
Cada amostra é reprocessada com o modelo global:

```
stringtie sample.bam \
 -e -B \
 -G merged.gtf \
 -o output.gtf
```

Parâmetros importantes:
> -e → restringe à anotação conhecida
> -B → prepara saída para Ballgown

## 7. Geração da Matriz de Contagem
Script: prepDE.py3

```
prepDE.py3 \
 -i sample_lst.txt \
 -g gene_count_matrix.csv \
 -t transcript_count_matrix.csv
```

Saídas: gene\_count_matrix.csv e transcript\_count\_matrix.csv

## 8. Limpeza de Arquivos
Remoção automática de arquivos pesados:

```
rm *.sam

rm *.bam (não ordenado)
```

Mantido: BAM ordenado, GTF final e matrizes.

## 9. Validações do Pipeline
Antes de rodar, o script valida automaticamente:

* Ferramentas instaladas:
	- prefetch
	- fasterq-dump
	- fastqc
	- hisat2
	- samtools
	- stringtie
	- python3
	- java
* Arquivos obrigatórios:
	- índice do genoma (HISAT2)
	- annotation GTF
	- prepDE.py
	- Trimmomatic



