# --------------------------------- DESeq ----------------------------
library(DESeq2)
library(tidyverse)
library(pheatmap)
library(dplyr)


# Step 1: preparing count data ---------------
keep_genes = read.csv("Anotacao_cardio.csv", header=TRUE)

# read in counts data
counts_data <- read.csv("Final_cardio_rep.csv")
rownames(counts_data) <- counts_data[,1]
counts_data <- counts_data[,-1]
counts_data <- data.matrix(counts_data)
counts_data <- round(counts_data)
counts_data <- counts_data[rownames(counts_data) %in% keep_genes$NAME,]


# read in sample info
colData <- read.csv("metadados_cardio_rep.csv")
rownames(colData) <- colData[,1]
colData <- colData[,-1]

all(colnames(counts_data)==rownames(colData))

colData$day <- factor(colData$day,
                      levels = c(0,1,2,3,4,6,8,10,12,18))

colData$phase <- factor(colData$phase)

# Step 2: construct a DESeqDataSet object -----------

dds_cardio <- DESeqDataSetFromMatrix(
  countData = counts_data,
  colData   = colData,
  design    = ~ phase
)

dds_cardio$phase = relevel(dds_cardio$phase, ref = "Control")

# Step 3: Run DESeq
dds_cm <- DESeq(dds_cardio)
re_cm <- results(dds_cm)
summary(re_cm)

plotMA(re_cm)


#Gerando o HEATMAP
vsd <- vst(dds_cardio, blind = FALSE)
mat <- assay(vsd)

rownames(colData)
metadata_cardio_phase <- as.data.frame(colData$phase)
rownames(metadata_cardio_phase) <- rownames(colData)


# -------------------------Garantir os clusters do Mfuzz --------------------------------------

# Criar annotation_row usando os clusters
annotation_row <- keep_genes %>%
  dplyr::select(NAME, cluster)

# Definir rownames
rownames(annotation_row) <- annotation_row$NAME

# Remover coluna NAME
annotation_row$NAME <- NULL

# Garantir mesma ordem da matriz do heatmap
annotation_row <- annotation_row[rownames(mat), , drop = FALSE]

# Transformar cluster em fator
annotation_row$cluster <- factor(annotation_row$cluster)

# Cores dos clusters
row_colors <- list(
  cluster = c(
    "1" = "#D73027",
    "2" = "#4575B4",
    "4" = "#66A61E"
  )
)

# ---------------------------------------------------------------------------------------------

pheatmap(
  mat,
  scale = "row",
  annotation_row = annotation_row,
  annotation_colors = row_colors,
  clustering_method = "ward.D2",
  cutree_rows = 3,
  gaps_row = NULL,
  show_rownames = FALSE,
  main = "Differential Expression Cardiomyocyte Heatmap",
  name = " ",
  width = 15,
  height = 12
)


###########################################
#            CONTRASTS                    #
###########################################

# Fazendo o contraste dos dias

## D1 X CONTROL
res_cm_contrast_D1 <- results(
  dds_cm,
  contrast = c("phase","D1","Control"))
res_cm_contrast_D1$sig <- as.factor(ifelse(res_cm_contrast_D1$padj < 0.05 & 
                                                abs(res_cm_contrast_D1$log2FoldChange) >2 & 
                                                res_cm_contrast_D1$baseMean > 50,
                                              ifelse(res_cm_contrast_D1$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D1 = as.data.frame(res_cm_contrast_D1)
res_cm_contrast_D1 <- res_cm_contrast_D1 %>% rename(logFC_D1 = log2FoldChange,
                                                          sig_D1 = sig)
res_cm_contrast_D1 <- res_cm_contrast_D1[, c("logFC_D1", "sig_D1")]


## D2 X CONTROL
res_cm_contrast_D2 <- results(
  dds_cm,
  contrast = c("phase","D2","Control"))
res_cm_contrast_D2$sig <- as.factor(ifelse(res_cm_contrast_D2$padj < 0.05 & 
                                             abs(res_cm_contrast_D2$log2FoldChange) >2 & 
                                             res_cm_contrast_D2$baseMean > 50,
                                           ifelse(res_cm_contrast_D2$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D2 = as.data.frame(res_cm_contrast_D2)
res_cm_contrast_D2 <- res_cm_contrast_D2 %>% rename(logFC_D2 = log2FoldChange,
                                                    sig_D2 = sig)
res_cm_contrast_D2 <- res_cm_contrast_D2[, c("logFC_D2", "sig_D2")]


## D3 X CONTROL
res_cm_contrast_D3 <- results(
  dds_cm,
  contrast = c("phase","D3","Control"))
res_cm_contrast_D3$sig <- as.factor(ifelse(res_cm_contrast_D3$padj < 0.05 & 
                                             abs(res_cm_contrast_D3$log2FoldChange) >2 & 
                                             res_cm_contrast_D3$baseMean > 50,
                                           ifelse(res_cm_contrast_D3$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D3 = as.data.frame(res_cm_contrast_D3)
res_cm_contrast_D3 <- res_cm_contrast_D3 %>% rename(logFC_D3 = log2FoldChange,
                                                    sig_D3 = sig)
res_cm_contrast_D3 <- res_cm_contrast_D3[, c("logFC_D3", "sig_D3")]

## D4 X CONTROL
res_cm_contrast_D4 <- results(
  dds_cm,
  contrast = c("phase","D4","Control"))
res_cm_contrast_D4$sig <- as.factor(ifelse(res_cm_contrast_D4$padj < 0.05 & 
                                             abs(res_cm_contrast_D4$log2FoldChange) >2 & 
                                             res_cm_contrast_D4$baseMean > 50,
                                           ifelse(res_cm_contrast_D4$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D4 = as.data.frame(res_cm_contrast_D4)
res_cm_contrast_D4 <- res_cm_contrast_D4 %>% rename(logFC_D4 = log2FoldChange,
                                                    sig_D4 = sig)
res_cm_contrast_D4 <- res_cm_contrast_D4[, c("logFC_D4", "sig_D4")]

## D6 X CONTROL
res_cm_contrast_D6 <- results(
  dds_cm,
  contrast = c("phase","D6","Control"))
res_cm_contrast_D6$sig <- as.factor(ifelse(res_cm_contrast_D6$padj < 0.05 & 
                                             abs(res_cm_contrast_D6$log2FoldChange) >2 & 
                                             res_cm_contrast_D6$baseMean > 50,
                                           ifelse(res_cm_contrast_D6$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D6 = as.data.frame(res_cm_contrast_D6)
res_cm_contrast_D6 <- res_cm_contrast_D6 %>% rename(logFC_D6 = log2FoldChange,
                                                    sig_D6 = sig)
res_cm_contrast_D6 <- res_cm_contrast_D6[, c("logFC_D6", "sig_D6")]

## D8 X CONTROL
res_cm_contrast_D8 <- results(
  dds_cm,
  contrast = c("phase","D8","Control"))
res_cm_contrast_D8$sig <- as.factor(ifelse(res_cm_contrast_D8$padj < 0.05 & 
                                             abs(res_cm_contrast_D8$log2FoldChange) >2 & 
                                             res_cm_contrast_D8$baseMean > 50,
                                           ifelse(res_cm_contrast_D8$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D8 = as.data.frame(res_cm_contrast_D8)
res_cm_contrast_D8 <- res_cm_contrast_D8 %>% rename(logFC_D8 = log2FoldChange,
                                                    sig_D8 = sig)
res_cm_contrast_D8 <- res_cm_contrast_D8[, c("logFC_D8", "sig_D8")]

## D10 X CONTROL
res_cm_contrast_D10 <- results(
  dds_cm,
  contrast = c("phase","D10","Control"))
res_cm_contrast_D10$sig <- as.factor(ifelse(res_cm_contrast_D10$padj < 0.05 & 
                                             abs(res_cm_contrast_D10$log2FoldChange) >2 & 
                                             res_cm_contrast_D10$baseMean > 50,
                                           ifelse(res_cm_contrast_D10$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D10 = as.data.frame(res_cm_contrast_D10)
res_cm_contrast_D10 <- res_cm_contrast_D10 %>% rename(logFC_D10 = log2FoldChange,
                                                    sig_D10 = sig)
res_cm_contrast_D10 <- res_cm_contrast_D10[, c("logFC_D10", "sig_D10")]

## D12 X CONTROL
res_cm_contrast_D12 <- results(
  dds_cm,
  contrast = c("phase","D12","Control"))
res_cm_contrast_D12$sig <- as.factor(ifelse(res_cm_contrast_D12$padj < 0.05 & 
                                             abs(res_cm_contrast_D12$log2FoldChange) >2 & 
                                             res_cm_contrast_D12$baseMean > 50,
                                           ifelse(res_cm_contrast_D12$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D12 = as.data.frame(res_cm_contrast_D12)
res_cm_contrast_D12 <- res_cm_contrast_D12 %>% rename(logFC_D12 = log2FoldChange,
                                                    sig_D12 = sig)
res_cm_contrast_D12 <- res_cm_contrast_D12[, c("logFC_D12", "sig_D12")]

## D18 X CONTROL
res_cm_contrast_D18 <- results(
  dds_cm,
  contrast = c("phase","D18","Control"))
res_cm_contrast_D18$sig <- as.factor(ifelse(res_cm_contrast_D18$padj < 0.05 & 
                                             abs(res_cm_contrast_D18$log2FoldChange) >2 & 
                                             res_cm_contrast_D18$baseMean > 50,
                                           ifelse(res_cm_contrast_D18$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_D18 = as.data.frame(res_cm_contrast_D18)
res_cm_contrast_D18 <- res_cm_contrast_D18 %>% rename(logFC_D18 = log2FoldChange,
                                                    sig_D18 = sig)
res_cm_contrast_D18 <- res_cm_contrast_D18[, c("logFC_D18", "sig_D18")]


genes_all_cardio <- cbind(res_cm_contrast_D1, 
                          res_cm_contrast_D2,
                          res_cm_contrast_D3,
                          res_cm_contrast_D4,
                          res_cm_contrast_D6,
                          res_cm_contrast_D8,
                          res_cm_contrast_D10,
                          res_cm_contrast_D12,
                          res_cm_contrast_D18)

genes_all_cardio <- na.omit(genes_all_cardio)

write.csv(genes_all_cardio, "all_DEGs_cardio_rep.csv", row.names = TRUE)
