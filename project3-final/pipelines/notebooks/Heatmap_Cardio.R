# --------------------------------- DESeq ----------------------------
library(DESeq2)
library(tidyverse)
library(pheatmap)


# Step 1: preparing count data ---------------


# read in counts data
counts_data <- read.csv("Final_cardio.csv")
rownames(counts_data) <- counts_data[,1]
counts_data <- counts_data[,-1]
counts_data <- data.matrix(counts_data)
counts_data <- round(counts_data)
counts_data <- counts_data[rownames(counts_data) %in% keep_genes$NAME,]


# read in sample info
colData <- read.csv("metadados_cardio.csv")
rownames(colData) <- colData[,1]
colData <- colData[,-1]

all(colnames(counts_data)==rownames(colData))

colData$day <- factor(colData$day,
                     levels = c(0,1,2,3,4,6,8,10,12,18))

colData$phase <- c(
  "Control",
  "Early","Early","Early","Early",
  "Mid","Mid","Mid",
  "Late","Late"
)

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

annotation <- data.frame(
  Stage = factor(
    c("Control","Early","Early","Early",
      "Early","Mid","Mid","Mid",
      "Late","Late"),
    levels = c("Control","Early","Mid","Late"),
    labels = c("Control","Early","Intermediate","Late")
  )
)

ann_colors <- list(
  Stage = c(
    Control = "#E76F51",
    Early = "#2A9D8F",
    Intermediate = "#E9C46A",
    Late = "#5E60CE"
  )
)

rownames(annotation) <- colnames(mat)

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
  annotation_col = annotation,
  annotation_row = annotation_row,
  annotation_colors = c(ann_colors, row_colors),
  clustering_method = "ward.D2",
  cutree_rows = 3,
  gaps_row = NULL,
  show_rownames = FALSE,
  main = "Differential Expression Cardiomyocyte Heatmap",
  name = " ",
  filename = "Cardiomyocyte_heatmap.png",
  width = 15,
  height = 12
)


###########################################
#            CONTRASTS                    #
###########################################

# Fazendo o contraste dos dias


## EARLY X CONTROL
res_cm_contrast_early <- results(
  dds_cm,
  contrast = c("phase","Early","Control"))
res_cm_contrast_early$sig <- as.factor(ifelse(res_cm_contrast_early$padj < 0.05 & 
                                                abs(res_cm_contrast_early$log2FoldChange) >2 & 
                                                res_cm_contrast_early$baseMean > 50,
                                              ifelse(res_cm_contrast_early$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_early = as.data.frame(res_cm_contrast_early)
res_cm_contrast_early <-  res_cm_contrast_early[order(factor(res_cm_contrast_early$sig, levels = c('up', 'down', 'not'))), ]
res_cm_contrast_early_diff <- res_cm_contrast_early[which(res_cm_contrast_early$sig !="not"),c("log2FoldChange","sig")]
res_cm_contrast_early_diff$time <- rep("Early", nrow(res_cm_contrast_early_diff))

## MID X CONTROL
res_cm_contrast_mid <- results(
  dds_cm,
  contrast = c("phase","Mid","Control"))
res_cm_contrast_mid$sig <- as.factor(ifelse(res_cm_contrast_mid$padj < 0.05 & 
                                              abs(res_cm_contrast_mid$log2FoldChange) >2 & 
                                              res_cm_contrast_mid$baseMean > 50,
                                            ifelse(res_cm_contrast_mid$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_mid = as.data.frame(res_cm_contrast_mid)
res_cm_contrast_mid <-  res_cm_contrast_mid[order(factor(res_cm_contrast_mid$sig, levels = c('up', 'down', 'not'))), ]
res_cm_contrast_mid_diff <- res_cm_contrast_mid[which(res_cm_contrast_mid$sig !="not"),c("log2FoldChange","sig")]
res_cm_contrast_mid_diff$time <- rep("Mid", nrow(res_cm_contrast_mid_diff))

## LATE X CONTROL
res_cm_contrast_late <- results(
  dds_cm,
  contrast = c("phase","Late","Control"))
res_cm_contrast_late$sig <- as.factor(ifelse(res_cm_contrast_late$padj < 0.05 & 
                                               abs(res_cm_contrast_late$log2FoldChange) >2 & 
                                               res_cm_contrast_late$baseMean > 50,
                                             ifelse(res_cm_contrast_late$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_late = as.data.frame(res_cm_contrast_late)
res_cm_contrast_late <-  res_cm_contrast_late[order(factor(res_cm_contrast_late$sig, levels = c('up', 'down', 'not'))), ]
res_cm_contrast_late_diff <- res_cm_contrast_late[which(res_cm_contrast_late$sig !="not"),c("log2FoldChange","sig")]
res_cm_contrast_late_diff$time <- rep("Late", nrow(res_cm_contrast_late_diff))

### MID x LATE
res_cm_contrast_mid_late <- results(
  dds_cm,
  contrast = c("phase","Late","Mid"))
res_cm_contrast_mid_late$sig <- as.factor(ifelse(res_cm_contrast_mid_late$padj < 0.05 & 
                                                   abs(res_cm_contrast_mid_late$log2FoldChange) >2 & 
                                                   res_cm_contrast_mid_late$baseMean > 50,
                                                 ifelse(res_cm_contrast_mid_late$log2FoldChange > 2,'up','down'), 'not'))
res_cm_contrast_mid_late = as.data.frame(res_cm_contrast_mid_late)
res_cm_contrast_mid_late <-  res_cm_contrast_mid_late[order(factor(res_cm_contrast_mid_late$sig, levels = c('up', 'down', 'not'))), ]
res_cm_contrast_mid_late_diff <- res_cm_contrast_mid_late[which(res_cm_contrast_mid_late$sig !="not"),c("log2FoldChange","sig")]
res_cm_contrast_mid_late_diff$time <- rep("Mid Late", nrow(res_cm_contrast_mid_late_diff))

## Juntando ups e downs 
#--------------------------------------------------------------------------------------
genes_up_cardio <- data.frame(
  gene = unique(c(
    rownames(res_cm_contrast_early)[res_cm_contrast_early$sig == "up"],
    rownames(res_cm_contrast_mid)[res_cm_contrast_mid$sig == "up"],
    rownames(res_cm_contrast_late)[res_cm_contrast_late$sig == "up"],
    rownames(res_cm_contrast_mid_late)[res_cm_contrast_mid_late$sig == "up"]
  )),
  regulation = "up"
)

genes_down_cardio <- data.frame(
  gene = unique(c(
    rownames(res_cm_contrast_early)[res_cm_contrast_early$sig == "down"],
    rownames(res_cm_contrast_mid)[res_cm_contrast_mid$sig == "down"],
    rownames(res_cm_contrast_late)[res_cm_contrast_late$sig == "down"],
    rownames(res_cm_contrast_mid_late)[res_cm_contrast_mid_late$sig == "down"]
  )),
  regulation = "down"
)

write.csv(genes_up_cardio, "genes_up_cardio.csv")
write.csv(genes_down_cardio, "genes_down_cardio.csv")
#----------------------------------------------------------------------------------------

genes_all_cardio <- rbind(res_cm_contrast_early_diff, 
                          res_cm_contrast_mid_diff,
                          res_cm_contrast_late_diff,
                          res_cm_contrast_mid_late_diff)
write.csv(genes_all_cardio, "all_DEGs_cardio.csv", row.names = TRUE)