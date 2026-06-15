# --------------------------------- Mfuzz ----------------------------
library(Mfuzz)

# Ele só lê tsv
data <- read.csv('Final_poli_fuzz.tsv',sep = '\t')
rownames(data) <- data[,1]
data <- data[,-1]

# Tem que mandar separado pra ele o tempo das amostras
time_points <- c(0,1,2,3,4,5,6,10,13,17)

# Transformar em uma matriz
poli_matrix <- as.matrix(data)
storage.mode(poli_matrix) <- "numeric"

# Aqui é uma etapa prévia de filtragem. Primeiro, achei interessante transformar os dados em log
# pq a expressão varia MUITO em valores absolutos, o que pode acabar gerando umas variações muito
# grandes sem necessariamente significar que está de fato variando muito.
poli_matrix <- log2(poli_matrix + 1)

# Ao invés de pegar a soma das linhas, pega a média de expressão
keep <- rowMeans(poli_matrix) > 1
poli_matrix <- poli_matrix[keep,]


# Isso daqui é uma segunda etapa de filtragem, mantendo apenas os transcritos que apresentaram maior variância.
# Nesse caso, 0.9 indica que quero os 10% que mais variaram
vars <- apply(poli_matrix, 1, var)
threshold <- quantile(vars, 0.9)
poli_matrix <- poli_matrix[vars >= threshold, ]


# A partir daqui é o pipeline do pacote

# Cria o objeto específico de análise do pacote a partir da matriz filtrada
poli_mfuzz <- ExpressionSet(assayData = poli_matrix)

# Ele faz uma etapa de normalização
poli_mfuzz <- standardise(poli_mfuzz)

# Esse m é um parâmetro do pacote para evitar agrupamento aleatório. Esse estimate calcula um ideal para nossos dados.
m <- mestimate(poli_mfuzz)

# Aqui roda de fato o algoritmo de clusterização. 12 é o número de clusters.
# Um número grande de clusters pega comportamentos mais sutis de expressão (acho que não queremos isso)
# Um número pequeno de clusters mostra grupos dominantes que regem a diferenciação (acho que queremos isso)
cl <- mfuzz(poli_mfuzz, c=12, m = m)

# Plota os gráficos. Esse mfrow indica quantas linhas e colunas de gráficos teremos.
# A lista com os dias tem que ser passada aqui
png(
  "mfuzz_poli_12.png",
  width = 3000,
  height = 2400,
  res = 300
)

mfuzz.plot(poli_mfuzz,
           cl = cl,
           mfrow = c(3,4),
           time.labels = time_points,
           new.window = FALSE)

dev.off()

# Isso daqui é para pegar os transcritos com a maior importância nos clusters. É com eles que iremos filtrar as
# análises do DESeq e fazer o enriquecimento.

# Eu escolhi pegar um score MUITO ALTO para ficar realmente com os genes que melhor representam o cluster pq
# 1) Diminui e muito o número de dados pra rodar;
# 2) Mostra menos vias no enriquecimento.

# O cluster 10 parece interessante
clusters <- acore(
  poli_mfuzz,
  cl,
  min.acore = 0.7
)

df1 <- as.data.frame(clusters[[1]])
df4 <- as.data.frame(clusters[[4]])
df12 <- as.data.frame(clusters[[12]])

lista_1 <- df1[,'NAME']
lista_df1 <- data.frame(
  NAME = df1[, "NAME"],
  cluster = 1
)

lista_4 <- df4[,'NAME']
lista_df4 <- data.frame(
  NAME = df4[, "NAME"],
  cluster = 4
)

lista_12 <- df12[,'NAME']
lista_df12 <- data.frame(
  NAME = df12[, "NAME"],
  cluster = 12
)

keep_genes <- rbind(lista_df1,lista_df4,lista_df12)

write.csv(keep_genes, "Anotacao_poli.csv",row.names = FALSE)