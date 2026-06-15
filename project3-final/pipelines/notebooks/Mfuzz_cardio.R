# --------------------------------- Mfuzz ----------------------------
library(Mfuzz)

# Ele só lê tsv
data <- read.csv('Final_cardio_fuzz.tsv',sep = '\t')
rownames(data) <- data[,1]
data <- data[,-1]

# Tem que mandar separado pra ele o tempo das amostras
time_points <- c(0,1,2,3,4,6,8,10,12,18)

# Transformar em uma matriz
cardio_matrix <- as.matrix(data)
storage.mode(cardio_matrix) <- "numeric"

# Aqui é uma etapa prévia de filtragem. Primeiro, achei interessante transformar os dados em log
# pq a expressão varia MUITO em valores absolutos, o que pode acabar gerando umas variações muito
# grandes sem necessariamente significar que está de fato variando muito.
cardio_matrix <- log2(cardio_matrix + 1)

# Ao invés de pegar a soma das linhas, pega a média de expressão
keep <- rowMeans(cardio_matrix) > 1
cardio_matrix <- cardio_matrix[keep,]


# Isso daqui é uma segunda etapa de filtragem, mantendo apenas os transcritos que apresentaram maior variância.
# Nesse caso, 0.9 indica que quero os 10% que mais variaram
vars <- apply(cardio_matrix, 1, var)
threshold <- quantile(vars, 0.9)
cardio_matrix <- cardio_matrix[vars >= threshold, ]


# A partir daqui é o pipeline do pacote

# Cria o objeto específico de análise do pacote a partir da matriz filtrada
cardio_mfuzz <- ExpressionSet(assayData = cardio_matrix)

# Ele faz uma etapa de normalização
cardio_mfuzz <- standardise(cardio_mfuzz)

# Esse m é um parâmetro do pacote para evitar agrupamento aleatório. Esse estimate calcula um ideal para nossos dados.
m <- mestimate(cardio_mfuzz)

# Aqui roda de fato o algoritmo de clusterização. 12 é o número de clusters.
# Um número grande de clusters pega comportamentos mais sutis de expressão (acho que não queremos isso)
# Um número pequeno de clusters mostra grupos dominantes que regem a diferenciação (acho que queremos isso)
cl <- mfuzz(cardio_mfuzz, c=12, m = m)

# Plota os gráficos. Esse mfrow indica quantas linhas e colunas de gráficos teremos.
# A lista com os dias tem que ser passada aqui
png(
  "mfuzz_cardio_12.png",
  width = 3000,
  height = 2400,
  res = 300
)

mfuzz.plot(cardio_mfuzz,
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
  cardio_mfuzz,
  cl,
  min.acore = 0.7
)

df1 <- as.data.frame(clusters[[1]])
df2 <- as.data.frame(clusters[[2]])
df4 <- as.data.frame(clusters[[4]])

lista_1 <- df1[,'NAME']
lista_df1 <- data.frame(
  NAME = df1[, "NAME"],
  cluster = 1
)

lista_2 <- df2[,'NAME']
lista_df2 <- data.frame(
  NAME = df2[, "NAME"],
  cluster = 2
)

lista_4 <- df4[,'NAME']
lista_df4 <- data.frame(
  NAME = df4[, "NAME"],
  cluster = 4
)

keep_genes <- rbind(lista_df1,lista_df2,lista_df4)

write.csv(keep_genes, "Anotacao_cardio.csv",row.names = FALSE)
