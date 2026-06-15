# --------------------------------- DESeq ----------------------------
library(DESeq2)
library(tidyverse)
library(pheatmap)
library(dplyr)


# Step 1: preparing count data ---------------
keep_genes = read.csv("Anotacao_poli.csv", header=TRUE)

# read in counts data
counts_data <- read.csv("Final_poli_rep.csv")
rownames(counts_data) <- counts_data[,1]
counts_data <- counts_data[,-1]
counts_data <- data.matrix(counts_data)
counts_data <- round(counts_data)
counts_data <- counts_data[rownames(counts_data) %in% keep_genes$NAME,]


# read in sample info
colData <- read.csv("metadados_poli_rep.csv")
rownames(colData) <- colData[,1]
colData <- colData[,-1]

all(colnames(counts_data)==rownames(colData))

colData$day <- factor(colData$day,
                      levels = c(0,1,2,3,4,5,6,10,13,17))

colData$phase <- factor(colData$phase)

# Step 2: construct a DESeqDataSet object -----------

dds_poli <- DESeqDataSetFromMatrix(
  countData = counts_data,
  colData   = colData,
  design    = ~ phase
)

dds_poli$phase = relevel(dds_poli$phase, ref = "Control")

# Step 3: Run DESeq
dds_ph <- DESeq(dds_poli)
re_ph <- results(dds_ph)
summary(re_ph)


plotMA(re_ph)

#Gerando o HEATMAP
vsd <- vst(dds_poli, blind = FALSE)
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
    "4" = "#4575B4",
    "12" = "#66A61E"
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
res_ph_contrast_D1 <- results(
  dds_ph,
  contrast = c("phase","D1","Control"))
res_ph_contrast_D1$sig <- as.factor(ifelse(res_ph_contrast_D1$padj < 0.05 & 
                                             abs(res_ph_contrast_D1$log2FoldChange) >2 & 
                                             res_ph_contrast_D1$baseMean > 50,
                                           ifelse(res_ph_contrast_D1$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D1 = as.data.frame(res_ph_contrast_D1)
res_ph_contrast_D1 <- res_ph_contrast_D1 %>% rename(logFC_D1 = log2FoldChange,
                                                    sig_D1 = sig)
res_ph_contrast_D1 <- res_ph_contrast_D1[, c("logFC_D1", "sig_D1")]


## D2 X CONTROL
res_ph_contrast_D2 <- results(
  dds_ph,
  contrast = c("phase","D2","Control"))
res_ph_contrast_D2$sig <- as.factor(ifelse(res_ph_contrast_D2$padj < 0.05 & 
                                             abs(res_ph_contrast_D2$log2FoldChange) >2 & 
                                             res_ph_contrast_D2$baseMean > 50,
                                           ifelse(res_ph_contrast_D2$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D2 = as.data.frame(res_ph_contrast_D2)
res_ph_contrast_D2 <- res_ph_contrast_D2 %>% rename(logFC_D2 = log2FoldChange,
                                                    sig_D2 = sig)
res_ph_contrast_D2 <- res_ph_contrast_D2[, c("logFC_D2", "sig_D2")]


## D3 X CONTROL
res_ph_contrast_D3 <- results(
  dds_ph,
  contrast = c("phase","D3","Control"))
res_ph_contrast_D3$sig <- as.factor(ifelse(res_ph_contrast_D3$padj < 0.05 & 
                                             abs(res_ph_contrast_D3$log2FoldChange) >2 & 
                                             res_ph_contrast_D3$baseMean > 50,
                                           ifelse(res_ph_contrast_D3$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D3 = as.data.frame(res_ph_contrast_D3)
res_ph_contrast_D3 <- res_ph_contrast_D3 %>% rename(logFC_D3 = log2FoldChange,
                                                    sig_D3 = sig)
res_ph_contrast_D3 <- res_ph_contrast_D3[, c("logFC_D3", "sig_D3")]

## D4 X CONTROL
res_ph_contrast_D4 <- results(
  dds_ph,
  contrast = c("phase","D4","Control"))
res_ph_contrast_D4$sig <- as.factor(ifelse(res_ph_contrast_D4$padj < 0.05 & 
                                             abs(res_ph_contrast_D4$log2FoldChange) >2 & 
                                             res_ph_contrast_D4$baseMean > 50,
                                           ifelse(res_ph_contrast_D4$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D4 = as.data.frame(res_ph_contrast_D4)
res_ph_contrast_D4 <- res_ph_contrast_D4 %>% rename(logFC_D4 = log2FoldChange,
                                                    sig_D4 = sig)
res_ph_contrast_D4 <- res_ph_contrast_D4[, c("logFC_D4", "sig_D4")]

## D5 X CONTROL
res_ph_contrast_D5 <- results(
  dds_ph,
  contrast = c("phase","D5","Control"))
res_ph_contrast_D5$sig <- as.factor(ifelse(res_ph_contrast_D5$padj < 0.05 & 
                                             abs(res_ph_contrast_D5$log2FoldChange) >2 & 
                                             res_ph_contrast_D5$baseMean > 50,
                                           ifelse(res_ph_contrast_D5$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D5 = as.data.frame(res_ph_contrast_D5)
res_ph_contrast_D5 <- res_ph_contrast_D5 %>% rename(logFC_D5 = log2FoldChange,
                                                    sig_D5 = sig)
res_ph_contrast_D5 <- res_ph_contrast_D5[, c("logFC_D5", "sig_D5")]

## D6 X CONTROL
res_ph_contrast_D6 <- results(
  dds_ph,
  contrast = c("phase","D6","Control"))
res_ph_contrast_D6$sig <- as.factor(ifelse(res_ph_contrast_D6$padj < 0.05 & 
                                             abs(res_ph_contrast_D6$log2FoldChange) >2 & 
                                             res_ph_contrast_D6$baseMean > 50,
                                           ifelse(res_ph_contrast_D6$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D6 = as.data.frame(res_ph_contrast_D6)
res_ph_contrast_D6 <- res_ph_contrast_D6 %>% rename(logFC_D6 = log2FoldChange,
                                                    sig_D6 = sig)
res_ph_contrast_D6 <- res_ph_contrast_D6[, c("logFC_D6", "sig_D6")]

## D10 X CONTROL
res_ph_contrast_D10 <- results(
  dds_ph,
  contrast = c("phase","D10","Control"))
res_ph_contrast_D10$sig <- as.factor(ifelse(res_ph_contrast_D10$padj < 0.05 & 
                                              abs(res_ph_contrast_D10$log2FoldChange) >2 & 
                                              res_ph_contrast_D10$baseMean > 50,
                                            ifelse(res_ph_contrast_D10$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D10 = as.data.frame(res_ph_contrast_D10)
res_ph_contrast_D10 <- res_ph_contrast_D10 %>% rename(logFC_D10 = log2FoldChange,
                                                      sig_D10 = sig)
res_ph_contrast_D10 <- res_ph_contrast_D10[, c("logFC_D10", "sig_D10")]

## D13 X CONTROL
res_ph_contrast_D13 <- results(
  dds_ph,
  contrast = c("phase","D13","Control"))
res_ph_contrast_D13$sig <- as.factor(ifelse(res_ph_contrast_D13$padj < 0.05 & 
                                              abs(res_ph_contrast_D13$log2FoldChange) >2 & 
                                              res_ph_contrast_D13$baseMean > 50,
                                            ifelse(res_ph_contrast_D13$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D13 = as.data.frame(res_ph_contrast_D13)
res_ph_contrast_D13 <- res_ph_contrast_D13 %>% rename(logFC_D13 = log2FoldChange,
                                                      sig_D13 = sig)
res_ph_contrast_D13 <- res_ph_contrast_D13[, c("logFC_D13", "sig_D13")]

## D17 X CONTROL
res_ph_contrast_D17 <- results(
  dds_ph,
  contrast = c("phase","D17","Control"))
res_ph_contrast_D17$sig <- as.factor(ifelse(res_ph_contrast_D17$padj < 0.05 & 
                                              abs(res_ph_contrast_D17$log2FoldChange) >2 & 
                                              res_ph_contrast_D17$baseMean > 50,
                                            ifelse(res_ph_contrast_D17$log2FoldChange > 2,'up','down'), 'not'))
res_ph_contrast_D17 = as.data.frame(res_ph_contrast_D17)
res_ph_contrast_D17 <- res_ph_contrast_D17 %>% rename(logFC_D17 = log2FoldChange,
                                                      sig_D17 = sig)
res_ph_contrast_D17 <- res_ph_contrast_D17[, c("logFC_D17", "sig_D17")]


genes_all_poli <- cbind(res_ph_contrast_D1, 
                        res_ph_contrast_D2,
                        res_ph_contrast_D3,
                        res_ph_contrast_D4,
                        res_ph_contrast_D5,
                        res_ph_contrast_D6,
                        res_ph_contrast_D10,
                        res_ph_contrast_D13,
                        res_ph_contrast_D17)

genes_all_poli <- na.omit(genes_all_poli)

write.csv(genes_all_poli, "all_DEGs_poli_rep.csv", row.names = TRUE)