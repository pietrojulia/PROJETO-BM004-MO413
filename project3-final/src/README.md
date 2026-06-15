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

- **4.1 Download dos dados**
Ferramenta: SRA Toolkit

~~~
prefetch SRRXXXX
~~~

- **4.2 Conversão para FASTQ**
~~~
fasterq-dump --split-files SRRXXXX
~~~

* Saída: 
	- SRR_1.fastq 
	- SRR_2.fastq

- **4.3. Controle de Qualidade (pré-trim)**
Ferramenta: FastQC

~~~
fastqc *.fastq
~~~

- **4.4 Trimming**
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

* Saída: 
	- reads paired
	- reads unpaired


- **4.5. Controle de Qualidade (pós-trim)**
~~~
fastqc *_paired.fastq
~~~

- **4.6. Alinhamento**
Ferramenta: HISAT2

Parâmetro crítico:

~~~
--dta → otimiza para montagem de transcritos

hisat2 --dta -x genome -1 R1 -2 R2 -S output.sam
~~~

- **4.7. Processamento BAM**
Ferramenta: Samtools

Etapas:

```
samtools view -bS → BAM

samtools sort → BAM ordenado

samtools index → índice
```

- **4.8. Montagem de transcritos (StringTie)**
~~~
stringtie sample_sorted.bam \
 -G annotation.gtf \
 -o sample.gtf \
 -A gene_abund.tab
~~~

* Saídas: 
	- GTF com transcritos reconstruídos 
	- Tabela de abundância por gene

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

* Parâmetros importantes:
	- -e → restringe à anotação conhecida
	- -B → prepara saída para Ballgown

## 7. Geração da Matriz de Contagem
Script: prepDE.py3

```
prepDE.py3 \
 -i sample_lst.txt \
 -g gene_count_matrix.csv \
 -t transcript_count_matrix.csv
```

* Saídas: 
	- gene\_count_matrix.csv
	- transcript\_count\_matrix.csv

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



# 10. Documentação dos scripts e parâmetros utilizados para Análise de Expressão Diferencial e Análise de Redes. 

Esta seção documenta os scripts enviados para a etapa final do trabalho.

**Script-base:** `Expression Day Cardio.R`

| Etapa | Parâmetros/decisões | Descrição |
|---------|---------|---------|
| Pacotes | DESeq2, data.table, readr, tidyverse, ggplot2, dplyr, tibble, pheatmap, ComplexHeatmap | Ambiente R utilizado para expressão diferencial, visualizações e manipulação de dados. |
| Entrada - lista filtrada | `lista_total_cm.csv` | Lista de transcritos/genes mantidos para a linhagem de cardiomiócitos. |
| Entrada - contagem | `Final_cardio.csv` | Matriz de contagens convertida para matriz numérica e arredondada. |
| Entrada - metadados | `metadados_cardio.csv` | Metadados com amostras ordenadas conforme as colunas da matriz de contagens. |
| Filtro inicial | `rownames(counts_cardio) %in% keep_transcripts_cardio$NAME` | Mantém somente os transcritos definidos na lista final. |
| Design estatístico | `design = ~ phase` | Modelo de expressão diferencial baseado na fase temporal. |
| Referência | Control | Fase controle usada como referência nas comparações. |
| Transformação | `vst(dds_cardio, blind = FALSE)` | Normalização por Variance Stabilizing Transformation para visualização em heatmap. |
| Critério DEG | `padj < 0.05; |log2FoldChange| > 2; baseMean > 50` | Critério adotado para marcar genes/transcritos diferencialmente expressos. |
| Contrastes | Early vs Control; Mid vs Control; Late vs Control; Late vs Mid | Comparações usadas para identificar genes ativados ou reprimidos ao longo do tempo. |
| Saídas principais | `volcano_plot_diff_cardio.png`; `Cardiomyocyte_heatmap.png`; `genes_up_cardio.csv`; `genes_down_cardio.csv`; `all_DEGs_cardio.csv`; `DEGs_with_clusters_cardio.csv`; `DEG_temporal_patterns_cardio.csv` | Arquivos gerados para visualização, contagem e integração com redes/Cytoscape. |

---

## 10.2 Script de expressão diferencial – células polihormonais

**Script-base:** `Expression Day Polih.R`

| Etapa | Parâmetros/decisões | Descrição |
|---------|---------|---------|
| Entrada - lista filtrada | `lista_total_poli.csv` | Lista de transcritos/genes mantidos para a linhagem polihormonal. |
| Entrada - contagem | `Final_poli.csv` | Matriz de contagens processada como matriz numérica arredondada. |
| Entrada - metadados | `metadados_poli.csv` | Metadados indexados pelo nome das amostras. |
| Fases | Control; Early; Mid; Late | Mesma organização temporal usada para cardiomiócitos. |
| Design estatístico | `design = ~ phase` | Modelo de expressão diferencial baseado na fase temporal. |
| Referência | Control | Estado inicial definido como referência. |
| Transformação | `vst(dds_poli, blind = FALSE)` | Normalização por estabilização da variância. |
| Heatmap | `scale = row`; `clustering_method = ward.D2`; `cutree_rows = 3` | Visualização dos perfis normalizados e agrupados por similaridade. |
| Clusters anotados | 4, 5 e 8 | Clusters utilizados para anotação visual no heatmap polihormonal. |
| Contrastes | Early vs Control; Mid vs Control; Late vs Control; Late vs Mid | Comparações temporais equivalentes às usadas em cardiomiócitos. |
| Saídas principais | `volcano_plot_diff_poli.png`; `Polihormonal_heatmap.png`; `genes_up_poli.csv`; `genes_down_poli.csv`; `all_DEGs_poli.csv`; `DEGs_with_clusters_poli.csv`; `deg_all_info_poli.csv` | Arquivos finais usados para resultados, redes e interpretação. |

---

## 10.3 Critérios para volcano plot e heatmap

- **Volcano plot:** eixo X = `log2FoldChange`; eixo Y = `-log10(padj)`.
- Genes classificados como **Up** quando `log2FoldChange > 2` e `padj < 0.05`.
- Genes classificados como **Down** quando `log2FoldChange < -2` e `padj < 0.05`.
- Genes sem significância estatística foram classificados como **NS**.
- As linhas de referência do volcano plot indicaram limites visuais de fold change e p-valor ajustado.
- Os heatmaps foram gerados com matriz normalizada por VST, escala por linha, agrupamento `ward.D2` e anotação por estágio temporal.

> **Observação metodológica importante:** a condição correta para genes down-regulated é `padj < 0.05` e `log2FoldChange < -2`. A apresentação utilizou a regra geral de significância por p-valor ajustado; no texto final, o critério deve ser registrado de forma consistente para genes up- e down-regulated.

---

## 10.4 Documentação da análise de redes e comunidades

**Script-base:** `igraph.R`; parâmetros complementares provenientes da análise WGCNA/Cytoscape descrita no trabalho e na apresentação.

| Componente | Parâmetros/decisões | Finalidade |
|------------|------------|------------|
| Entrada de arestas | `Cardio/edges.csv` | Tabela com conexões entre genes e pesos de ligação. |
| Entrada de nós | `Cardio/nodes.csv` | Tabela com genes/nós e atributos associados. |
| Grafo | `graph_from_data_frame(d = edges_cardio, directed = FALSE)` | Construção de grafo não direcionado a partir das arestas. |
| Pesos | `E(my_graph)$weight` | Uso do peso das arestas na detecção de comunidades. |
| Comunidades | `cluster_spinglass` | Algoritmo usado para agrupar nós em comunidades de rede. |
| Parâmetro spins | 25 | Número máximo de comunidades/estados considerados pelo método. |
| Temperatura inicial | `start.temp = 1` | Parâmetro de inicialização do algoritmo spinglass. |
| Temperatura final | `stop.temp = 0.01` | Critério de resfriamento/finalização. |
| Fator de resfriamento | `cool.fact = 0.99` | Controle do decaimento da temperatura no algoritmo. |
| Saída | `data.frame(Node, Community)` | Tabela relacionando cada nó à sua comunidade detectada. |

---

## 10.5 Parâmetros da WGCNA e exportação para Cytoscape

| Etapa | Parâmetro/decisão | Descrição |
|---------|---------|---------|
| Normalização | Variance Stabilizing Transformation (DESeq2) | Estabiliza a variância antes da construção de redes de coexpressão. |
| Filtro de baixa expressão | Soma das leituras < 1000 removida | Reduz ruído e custo computacional. |
| Similaridade | Correlação de Pearson | Mede concordância entre perfis de expressão dos genes. |
| Adjacência | Soft thresholding power β = 9 | Elevação das correlações para aproximar topologia scale-free. |
| Módulos | Sobreposição topológica | Identifica grupos de genes com alta similaridade topológica. |
| Módulo selecionado | turquoise | Módulo escolhido para construção das redes principais. |
| Filtro de arestas | peso > 0.1 | Mantém conexões com maior força de ligação para visualização. |
| Visualização | Cytoscape | Construção e interpretação das redes por cor, tamanho, grau e módulos. |
| Comunidades | Leiden / spinglass | Estratégias de detecção de grupos funcionais ou topológicos. |
| Atributos visuais | cor do nó = expressão/logFC; tamanho/grau = conectividade | Facilita a interpretação de hubs, módulos e mudanças temporais. |
