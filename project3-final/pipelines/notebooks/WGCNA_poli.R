library(WGCNA)
library(DESeq2)
library(tidyverse)
library(magrittr)
library(biomaRt)

keep_degs <- read.csv("all_DEGs_poli_rep.csv")
rownames(keep_degs) <- keep_degs[,1]

data_counts <- read.csv("Final_poli.csv")
rownames(data_counts) <- data_counts[,1]
data_counts <- data_counts[,-1]

data_counts <- data_counts[row.names(data_counts) %in% row.names(keep_degs),]

data_counts <- data.matrix(data_counts)
data_counts <- round(data_counts)


colData <- read.csv("metadados_poli.csv")
rownames(colData) <- colData[,1]
colData <- colData[,-1]

all(colnames(data_counts)==rownames(colData))

colData$day <- factor(colData$day,
                      levels = c(0,1,2,3,4,5,6,10,13,17))

colData$phase <- c(
  "Control",
  "Early","Early","Early","Early",
  "Mid","Mid","Mid",
  "Late","Late"
)

colData$phase <- factor(colData$phase)

dds_poli <- DESeqDataSetFromMatrix(
  countData = data_counts,
  colData   = colData,
  design    = ~ phase
)

vsd <- vst(dds_poli, blind = T)
#dds_poli$phase <- relevel(dds_poli$phase, ref = "Control")

datExpr0 <- assay(vsd)

plotPCA(vsd, intgroup=c("phase"))

mapping <- list(phase = c("Control" = 0,
                          "Early" = 1,
                          "Mid" = 3,
                          "Late" = 2))

colData[["phase"]] <- mapping[["phase"]][colData[["phase"]]]

datExpr0 = t(datExpr0)

gsg <- goodSamplesGenes(datExpr0, verbose = 3)
gsg$allOK

sampleTree <- hclust(dist(datExpr0), method = "average");
sizeGrWindow(12,9)
par(cex = 0.6);
par(mar = c(0,4,2,0))
plot(sampleTree, main = "Sample clustering to detect outliers", sub="", xlab="", cex.lab = 1.5,
     cex.axis = 1.5, cex.main = 2)
abline(h = 150, col = "red")

clust <- cutreeStatic(sampleTree, cutHeight = 150, minSize = 10)
table(clust)

keepSamples <- (clust==0)
datExpr <- datExpr0[keepSamples,]
nGenes <- ncol(datExpr)
nSamples <- nrow(datExpr)
rownames(colData) == rownames(datExpr)


sampleTree2 = hclust(dist(datExpr), method = "average")
traitColors = numbers2colors(colData$phase, signed = FALSE);
plotDendroAndColors(sampleTree2, traitColors,
                    groupLabels = "phase",
                    main = "Sample dendrogram and trait heatmap")


powers <- c(c(1:10), seq(from = 12, to=20, by=2))
sft <- pickSoftThreshold(datExpr, powerVector = powers, verbose = 5)
sft$powerEstimate

sizeGrWindow(9, 5)
#png(file = "plot_output.png", width = 800, height = 400)
par(mfrow = c(1,2));
cex1 = 0.9;

# Scale-free topology fit index as a function of the soft-thresholding power
plot(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     xlab="Soft Threshold (power)",ylab="Scale Free Topology Model Fit,signed R^2",type="n",
     main = paste("Scale independence"));
text(sft$fitIndices[,1], -sign(sft$fitIndices[,3])*sft$fitIndices[,2],
     labels=powers,cex=cex1,col="red");
# this line corresponds to using an R^2 cut-off of h
abline(h=0.8,col="red", lty = 2)
# Mean connectivity as a function of the soft-thresholding power
plot(sft$fitIndices[,1], sft$fitIndices[,5],
     xlab="Soft Threshold (power)",ylab="Mean Connectivity", type="n",
     main = paste("Mean connectivity"))
text(sft$fitIndices[,1], sft$fitIndices[,5], labels=powers, cex=cex1,col="red")
abline(h=0, col="red",lty = 2)
dev.off()


cor <- WGCNA::cor
net <- blockwiseModules(datExpr, power = 20,
                        TOMType = "unsigned", minModuleSize = 150,
                        reassignThreshold = 0, mergeCutHeight = 0.25,
                        numericLabels = TRUE, pamRespectsDendro = FALSE,
                        saveTOMs = TRUE,
                        verbose = 3)
cor <- stats::cor

sizeGrWindow(12, 9)
# Convert labels to colors for plotting
mergedColors = labels2colors(net$colors)
# Plot the dendrogram and the module colors underneath
plotDendroAndColors(net$dendrograms[[1]], mergedColors[net$blockGenes[[1]]],
                    "Module colors",
                    dendroLabels = FALSE, hang = 0.03,
                    addGuide = TRUE, guideHang = 0.05)

moduleLabels = net$colors
moduleColors = labels2colors(net$colors)
MEs = net$MEs;
geneTree = net$dendrograms[[1]];

# ------------------------------------------------------------------------------
nGenes <- ncol(datExpr)
nSamples <- nrow(datExpr)

MEs0 <- moduleEigengenes(datExpr, moduleColors)$eigengenes
MEs <- orderMEs(MEs0)
moduleTraitCor <- cor(MEs, 
                      colData$phase, 
                      use = "p");
moduleTraitPvalue <- corPvalueStudent(moduleTraitCor,
                                      nSamples)

sizeGrWindow(12,6)
# Will display correlations and their p-values
textMatrix = paste(signif(moduleTraitCor, 2), "\n(",
                   signif(moduleTraitPvalue, 1), ")", sep = "");
dim(textMatrix) = dim(moduleTraitCor)
par(mar = c(6, 8.5, 3, 3));
# Display the correlation values within a heatmap plot
labeledHeatmap(Matrix = moduleTraitCor,
               xLabels = "phase",
               yLabels = names(MEs),
               ySymbols = names(MEs),
               colorLabels = FALSE,
               colors = blueWhiteRed(50),
               textMatrix = textMatrix,
               setStdMargins = FALSE,
               cex.text = 0.5,
               zlim = c(-1,1),
               main = paste("Module-trait relationships"))
# ------------------------------------------------------------------------------
ensembl_id = as.data.frame(colnames(datExpr))

annotation <- read.csv("enst_to_symbol_ph.csv",sep = ",", header = TRUE)

TOM <- TOMsimilarityFromExpr(datExpr, power = 20);
module_t <- c("turquoise")


probes <- colnames(datExpr)
inModule <- is.finite(match(moduleColors, module_t));
modProbes <- probes[inModule]
modGenes <- annotation$GeneSymbol[match(modProbes, annotation$ENST)];

modTOM <- TOM[inModule, inModule];
dimnames(modTOM) <- list(modProbes, modProbes)
modTOM <- as.data.frame(modTOM)

cyt <- exportNetworkToCytoscape(modTOM,
                                weighted = TRUE,
                                threshold = 0.1, #0,05 0,15
                                nodeNames = modProbes,
                                altNodeNames = modGenes,
                                nodeAttr = moduleColors[inModule])

edges <- cyt$edgeData
colnames(edges)[1] <- "Source"
colnames(edges)[2] <- "Target"
edges <- edges[, -4:-6]

nodes <- cyt$nodeData
colnames(nodes)[1] <- "id"
colnames(nodes)[2] <- "Label"


write.csv(edges, file="Poli_edges.csv", quote = FALSE,row.names = F)
write.csv(nodes, file="Poli_nodes.csv", quote = FALSE,row.names = F)