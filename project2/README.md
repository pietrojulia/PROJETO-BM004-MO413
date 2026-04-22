# Segunda Entrega
*2026.1 Ciência e Visualização de Dados em Saúde*

# Projeto `Dinâmica Temporal e Redes de Coexpressão Gênica da Diferenciação de Células-Tronco Embrionárias`
# Project `Temporal Dynamics and Gene Co-expression Networks of Embryonic Stem Cell Differentiation`

# 1. Descrição Resumida do Projeto

Este projeto tem como principal objetivo analisar e comparar a dinâmica temporal da expressão gênica durante a diferenciação de células-tronco embrionárias humanas (hESCs) em duas linhagens distintas: cardiomiócitos (mesoderme) e células polihormonais pancreáticas (endoderme).

Apesar de compartilharem o mesmo genoma, tais células adquirem identidades distintas ao longo de seu processo de diferenciação, resultado de mudanças coordenadas na regulação gênica, da ativação de vias biológicas específicas e do desenvolvimento de interações moleculares únicas. Dessa forma, a compreensão das dinâmicas que regem o processo de diferenciação celular mostra-se essencial para a elucidação dos mecanismos subjacentes ao desenvolvimento embrionário e, consequentemente, para a identificação de potenciais alvos moleculares em aplicações de medicina regenerativa.

Sendo assim, utilizando dados públicos de RNA-seq com resolução temporal, o projeto propõe integrar análise de expressão diferencial, enriquecimento funcional e ciência de redes para a identificação de padrões comuns e específicos entre as duas linhagens celulares estudadas. Nesse sentido, espera-se que redes de coexpressão gênica sejam construídas e analisadas quanto a suas propriedades topológicas ao longo do intervalo analisado, permitindo a identificação de genes centrais, módulos funcionais e eventos críticos no processo de diferenciação celular.


# 2. Slides

[Apresentação da Entrega 01 do Projeto da Disciplina](assets/slides/Entrega 2 - BM004.pdf)


# 3. Fundamentação Teórica
- **Campbell et al. (2019)**: Definição de células-tronco como células com alta potencialidade e baixo grau de diferenciação. Classificação das células-tronco quanto à potencialidade (totipotentes, pluripotentes, multipotentes e unipotentes);

- **Zakrzewski et al. (2019)**: Complementação da classificação funcional das células-tronco e seus diferentes níveis de diferenciação;

- **Campbell et al. (2019)**: Classificação das células-tronco quanto à origem (adultas, iPSCs e embrionárias);

- **Mao and Mooney (2015)**: Aplicação de células-tronco na medicina regenerativa como alternativa ao transplante de órgãos;

- **Trapnell et al. (2014)**: Diferenciação celular como processo dinâmico e contínuo, analisável por expressão gênica ao longo do tempo;

- **Keskin et al. (2025, 2026)**: Análise da diferenciação de hESCs em diferentes linhagens com base em mudanças temporais na expressão gênica. Base experimental para construção de modelos computacionais aplicados ao estudo da diferenciação celular.


# 4. Perguntas de Pesquisa

- Existe diferença entre as dinâmicas de expressão gênica encontradas ao longo do processo de diferenciação de células-tronco pluripotentes em cardiomiócitos e células polihormonais?

- Como a dinâmica temporal das redes de coexpressão gênica influencia o processo de diferenciação de células-tronco embrionárias humanas em cardiomiócitos e células pancreáticas?

## 4.1. Hipóteses a serem testadas

- H0: A dinâmica da expressão gênica ao longo do processo de diferenciação de células-tronco pluripotentes em cardiomiócitos é idêntica àquela observada na diferenciação de células polihormonais. 

- H1: A dinâmica da expressão gênica ao longo do processo de diferenciação de células-tronco pluripotentes em cardiomiócitos é distinta àquela observada na diferenciação de células polihormonais.


# 5. Metodologia

Com o objetivo de comparar a dinâmica da expressão gênica entre as linhagens mesodérmica (cardiomiócitos) e endodérmica (células polihormonais), será realizada uma análise temporal de expressão gênica diferencial a partir de dados de RNA-seq. Inicialmente, cada linhagem será comparada a um grupo controle correspondente a células-tronco embrionárias pluripotentes (RUES2), em três pontos temporais definidos com base nos estudos de Keskin et al., 2025 e Keskin et al., 2026:

- i. dia 0 (estado pluripotente);
- ii. dia 3 (início da diferenciação, com especificação de linhagem);
- iii. dia 17 (estado diferenciado).

A partir dessas comparações, serão obtidos conjuntos de genes diferencialmente expressos (DEGs) para cada linhagem em cada tempo, totalizando seis conjuntos principais. Em seguida, os genes diferencialmente expressos serão utilizados para a construção de redes de coexpressão gênica, nas quais os nós representam genes e as arestas representam relações de correlação entre seus perfis de expressão ao longo do tempo para cada amostra.

As redes serão construídas com base em medidas de correlação (como correlação de Pearson ou Spearman), permitindo identificar padrões de co-regulação gênica. A análise dessas redes poderá envolver métricas de centralidade como degree, betweenness e eigenvector, para assim identificar genes centrais (hubs), que podem desempenhar papéis regulatórios importantes no processo de diferenciação celular. Além disso, o uso do algoritmo de Louvain será testado para identificar comunidades; necessário neste contexto para prever módulos de genes coexpressos, que estão potencialmente associados a funções biológicas específicas ou vias regulatórias. No entanto, análises comparativas entre redes são essenciais para identificar diferenças estruturais entre as redes de cada linhagem ao longo do tempo, evidenciando processos biológicos específicos da mesoderme e da endoderme.

Assim, para a análise da dinâmica temporal das redes de coexpressão gênica, cada rede será construída de maneira independente para cada ponto temporal analisado. Serão comparadas as propriedades topológicas das redes ao longo do tempo, como densidade, centralidade e estrutura de comunidades. O objetivo é identificar mudanças estruturais associadas ao processo de diferenciação celular, de modo que estas alterações possam ser interpretadas como pontos críticos de transição, nos quais ocorrem reorganizações significativas nas interações gênicas, que refletem alterações no estado celular. A identificação desses pontos permitirá inferir momentos-chave do processo de diferenciação em que há ativação de programas regulatórios específicos para cada linhagem.


## 5.1 Bases de Dados e Evolução

A base de dados está disponível no Gene Expression Omnibus, a partir  dos estudos de Keskin et al. (2025, 2026) e referenciada pelos números de acesso: GSE274620 (Keskin et al., 2025a) e GSE305933 (Keskin et al., 2025b). Ambos datasets foram utilizados para avaliar o perfil multi-ômico de células-tronco embrionárias. Para a autenticação e controle de qualidade, os autores compararam os conjuntos de dados com a linhagem RUES2 hESC (HPSCREG, 2026), disponibilizada pela The Rockefeller University. 


> Base de Dados | Endereço na Web | Resumo descritivo | Tamanho | 
> ----- | ----- | ----- | ----- 
> GSE274620 | [URL NCBI](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE274620) | Proveniente do Gene Expression Omnibus. Amostras de RNA-seq da linhagem mesoderme de células tronco. Diferenciação em cardiomiócitos com série temporal. | 29.55GB | 
> GSE305933 | [URL NCBI](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE305933) | Proveniente do Gene Expression Omnibus. Amostras de RNA-seq da linhagem endoderme de células tronco. Diferenciação em células pancreáticas polihormonais com série temporal. | 27.27 GB |
> SAMEA104387770 | [URL hPSCreg](https://hpscreg.eu/cell-line/RUESe002-A) | Proveninete do hPSCreg. Amostras de RNA-seq de células tronco embrionárias. Diferenciação de blastocistos em endoderme, ectoderme e mesoderme. | 2.8 GB | 

O dataset GSE274620 foi gerado a partir da diferenciação de hESCs em cardiomiócitos, representando a linhagem mesodérmica. Esse conjunto contém 10 amostras coletadas em diferentes pontos temporais ao longo do processo de diferenciação, com medições de expressão gênica obtidas por RNA-seq, realizadas em duplicata. De forma análoga, o dataset GSE305933 descreve a diferenciação de hESCs em células pancreáticas polihormonais, representando a linhagem endodérmica, seguindo o mesmo desenho experimental e estratégia de quantificação. Para este estudo, foram selecionadas apenas as amostras correspondentes aos dias 0, 3 e 17, que representam, respectivamente, o estado pluripotente inicial, o estágio intermediário de especificação de linhagem e o estado final diferenciado. Considerando as duplicatas e ambas as linhagens, o conjunto analisado totaliza aproximadamente 20 GB de dados brutos.

Os dados brutos foram baixados diretamente do NBCI via SRA Toolkit. Primeiramente, a qualidade das amostras foi testada por FastQC, que forneceu um relatório sobre as características das sequências, como qualidade por posição da base; conteúdo GC; sequências repetidas e contaminação por adaptadores. Em seguida, foi realizada a etapa de limpeza com o Trimmomatic, que removeu adaptadores, regiões de baixa qualidade (Phred < 20 nas extremidades), leituras com comprimento inferior a 36 pares de bases e trechos com média de qualidade inferior a 15 em janelas deslizantes. Após essa etapa, as amostras foram novamente avaliadas com o FastQC para garantir a efetividade do pré-processamento.

A partir dos dados limpos, mapeamos as amostras por HISAT2 com o genoma de referência Hg38 (do inglês, human genome build 38), disponibilizado pelo próprio programa, para identificar a posição precisa dos transcritos. Com os transcritos indexados e ordenados, contabilizamos os transcritos pelo StringTie, responsável pela reconstrução dos transcritos e estimativa de suas respectivas abundâncias. Os resultados individuais foram integrados em um modelo unificado, utilizado como base para a quantificação comparativa entre as amostras. Ao final, duas matrizes foram geradas, uma com as quantificações de transcritos (ENSEMBL) e outra de genes (RefSeq) para cada amostra. A matriz de transcritos foi usada para apresentação das próximas etapas.


> ![Fluxograma pre-proc](assets/images/Fluxograma.png)

## 5.2 Modelo Lógico

> ![Modelo Lógico de Grafos](assets/images/Project1_logic_model_COMBI.png)


## 5.3 Integração entre Bases

Embora os datasets GSE274620 e GSE305933 tenham sido produzidos com protocolos experimentais semelhantes, foi necessário garantir a comparabilidade direta entre eles. Para isso, foram selecionados pontos temporais equivalentes (dias 0, 3 e 17) e mantidas apenas as amostras em duplicata, assegurando consistência no desenho experimental entre as duas linhagens. Outro ponto importante foi a padronização das etapas de pré-processamento. Todas as amostras, independentemente da origem, foram submetidas ao mesmo pipeline (FastQC, Trimmomatic, HISAT2 e StringTie), evitando a introdução de vieses técnicos decorrentes de diferenças metodológicas.

Além dos desafios metodológicos, a principal limitação encontrada foi o alto custo computacional das análises. O processamento completo das amostras foi realizado em um ambiente com 16 GB DDR4 de memória RAM e 512GB  de armazenamento em SSD NVMe M.2 em sistema operacional Ubuntu Linux e Processador AMD Ryzen 7 5825U (8 núcleos, 16 threads, até 4.5 GHz). Uma amostra demorou cerca de 30 minutos na máquina descrita. 

Apesar dessas limitações, a padronização do pipeline e a seleção criteriosa das amostras permitiram a construção de um conjunto de dados integrado, consistente e adequado para as análises comparativas propostas neste projeto.


# 6. Análise Preliminar
A análise de PCA para a linhagem de cardiomiócitos revela uma separação bem definida entre os três tempos, com PC1 explicando 57,1% da variância e PC2 42,9%, indicando que a maior parte da variação nos dados está associada à progressão temporal da diferenciação. Observa-se que o ponto intermediário (D3) ocupa uma posição bastante distinta dos estados inicial e final, sugerindo uma reorganização transcricional mais acentuada durante essa fase. Já na linhagem de células polihormonais, a variância também se distribui de forma equilibrada entre os dois primeiros componentes (PC1 = 52,5% e PC2 = 47,5%), porém com uma disposição espacial das amostras que indica uma transição mais contínua entre os estados, na qual D3 atua como intermediário mais alinhado entre D0 e D18. Em conjunto, esses resultados mostram que, embora ambas as linhagens apresentem forte influência da dinâmica temporal na variação da expressão gênica, a diferenciação em cardiomiócitos parece ocorrer de maneira mais abrupta, enquanto a linhagem polihormonal apresenta uma progressão mais gradual, reforçando diferenças nos programas regulatórios envolvidos em cada processo.

> ![Análise PCA - matriz de contadores de transcritos cardiomiócitos](assets/images/pca_cardio.png)


> ![Análise PCA - matriz de contadores de transcritos polihormonais](assets/images/pca_polih.png)

# 7. Evolução do Projeto
Ao longo do desenvolvimento deste projeto, foram realizadas adaptações pontuais na abordagem metodológica, mantendo, no entanto, a estrutura central proposta na Entrega 01.

Desde a concepção inicial, o projeto já previa a análise da dinâmica temporal da expressão gênica em três pontos específicos (dias 0, 3 e 17), definidos com base em sua relevância biológica no processo de diferenciação celular. Esses pontos representam, respectivamente, o estado pluripotente, a fase inicial de especificação de linhagem e o estado diferenciado. Dessa forma, não houve alteração nessa escolha ao longo do desenvolvimento, mas sim um aprofundamento na justificativa biológica e na forma de operacionalizar essa análise.

Um dos principais avanços em relação à proposta inicial foi a consolidação do pipeline de pré-processamento dos dados. Embora diferentes ferramentas tenham sido inicialmente consideradas, foi estabelecido um fluxo padronizado envolvendo FastQC, Trimmomatic, HISAT2 e StringTie. Essa definição permite maior controle sobre a qualidade dos dados e garante consistência entre as amostras analisadas.

Durante a execução, também se tornaram mais evidentes os desafios associados ao processamento de dados de RNA-seq em larga escala, especialmente em termos de custo computacional e tempo de execução. Esses fatores reforçaram a necessidade de um planejamento mais cuidadoso das etapas analíticas e da organização dos dados.

Adicionalmente, houve um refinamento na forma de integração entre as bases de dados, com maior atenção à padronização das amostras, ao uso consistente do genoma de referência e à uniformização das etapas de processamento. Esse cuidado foi fundamental para garantir a comparabilidade entre as linhagens estudadas.

Por fim, o projeto evoluiu no sentido de maior alinhamento entre as perguntas de pesquisa, as hipóteses e as estratégias analíticas adotadas. Esse refinamento contribuiu para uma abordagem mais coesa e estruturada, mantendo a proposta original, mas com maior clareza metodológica e rigor na execução.


# 8. Ferramentas
Como pretendemos avaliar os perfis de expressão gênicas e suas correlações ao longo do tempo para cada linhagem celular, usaremos como base a metodologia descrita pelos artigos de Keskin et al., 2025 e Keskin et al., 2026. Adicionamos etapas descritas em workflows anteriores, como análises de redes, que permitem identificar correlações intrínsecas entre genes. Até o presente momento, a coleta e pré-processamento dos dados foi realizada da seguinte maneira:

## 8.1. Pré-processamento de dados

> Software/Ferramenta | Função | Citação
> ----- | ----- | -----
> FastQC | Controle de qualidade | [Wingett et al., 2018] 
> Trimmomatic | Limpeza dos dados | [Bolger et al., 2014] 
> HISAT2 | Mapeamento | HISAT2: [Wen et al., 2017], STAR: [Dobin et al., 2013] 
> StringTie | Contagem dos transcritos | Plastid: [Keskin et al., 2026], StringTie: [Pertea et al., 2015]


A seguir, serão descritas, de maneira breve, quais as ferramentas e softwares que serão utilizados para cada uma das futuras etapas do trabalho.

## 8.2. Análise de Expressão Diferencial

> Software/Ferramenta | Função | Citação
> ----- | ----- | -----
> DESeq2 | Análise de expressão diferencial | [Love et al., 2014]


## 8.3. Anotação e Análise de Enriquecimento de Vias

> Software/Ferramenta | Função | Citação
> ----- | ----- | -----
> Bibliotecas R: clusterProfiler, org.Hs.eg.db e AnnotationDbi | Anotação funcional | clusterProfiler: [Yu G, 2024], org.Hs.eg.db: [Carlson M, 2017], AnnotationDbi: [Pagès et al., 2025]
> Bibliotecas R: enrichplot | Enriquecimento de vias | [Yu et al., 2026]


## 8.4. Análise de Redes

> Software/Ferramenta | Função | Citação
> ----- | ----- | -----
> WGCNA | Análises de correlação | [Langfelder et al., 2008]
> GEPHI ou Cytoscape | Construção e análise das redes de correlação | GEPHI: [Bastian et al., 2009], Cytoscape: [Shannon et al., 2003]


# 9. Referências Bibliográficas

[Bastian et al., 2009] Bastian, M.; Heymann, S.; Jacomy, M. Gephi: an open source software for exploring and manipulating networks. In: Proceedings of the 3rd International AAAI Conference on Web and Social Media. Burnaby, Canada, 2009. p. 361–362.


[Bolger et al., 2014] Bolger, A. M.; Lohse, M.; Usadel, B. Trimmomatic: a flexible trimmer for Illumina sequence data. Bioinformatics, v. 30, n. 15, p. 2114–2120, 2014.


[Campbell et al., 2019] Campbell, Madeline et al. Stem cell spheroids. 2019.


[Carlson, 2017] Carlson, M. org.Hs.eg.db: Genome wide annotation for Human. R package version 3.5.0, 2017.


[Dobin et al., 2013] Dobin, A. et al. STAR: ultrafast universal RNA-seq aligner. Bioinformatics, v. 29, n. 1, p. 15–21, 2013. doi:10.1093/bioinformatics/bts635.


[Dvash et al., 2006] Dvash, T.; Ben-Yosef, D.; Eiges, R. Human embryonic stem cells as a powerful tool for studying human embryogenesis. Pediatric Research, v. 60, p. 111–117, 2006. doi:10.1203/01.pdr.0000228349.24676.17.


[HPSCREG, 2026] HPSCREG. Human Pluripotent Stem Cell Registry. Disponível em: hpscreg.eu. Acesso em: 19 mar. 2026.


[Keskin et al., 2025] Keskin, A.; Shayya, H. J.; Sirabella, D. et al. Temporal multiomics gene expression data of human embryonic stem cell-derived cardiomyocyte differentiation. Scientific Data, v. 12, p. 1308, 2025. doi:10.1038/s41597-025-05655-9.


[Keskin et al., 2025a] Keskin, A. et al. Temporal multiomics gene expression data of human embryonic stem cell-derived cardiomyocyte differentiation. NCBI Gene Expression Omnibus (GEO), 2025. Disponível em: https://identifiers.org/geo/GSE274620.


[Keskin et al., 2025b] Keskin, A. et al. Temporal multiomics gene expression data across human embryonic stem cell-derived polyhormonal cell differentiation. NCBI Gene Expression Omnibus (GEO), 2025. Disponível em: https://identifiers.org/geo/GSE305933.


[Keskin et al., 2026] Keskin, A.; Shayya, H. J.; Patel, A. et al. Temporal multiomics gene expression data across human embryonic stem cell-derived polyhormonal cell differentiation. Scientific Data, v. 13, p. 278, 2026. doi:10.1038/s41597-026-06606-8.


[Langfelder; Horvath, 2008] Langfelder, P.; Horvath, S. WGCNA: an R package for weighted correlation network analysis. BMC Bioinformatics, v. 9, p. 559, 2008.


[Lee; Lee, 2011] Lee, J. E.; Lee, D. R. Human embryonic stem cells: derivation, maintenance and cryopreservation. International Journal of Stem Cells, v. 4, n. 1, p. 9–17, 2011. doi:10.15283/ijsc.2011.4.1.9.


[Love et al., 2014] Love, M. I.; Huber, W.; Anders, S. Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biology, v. 15, p. 550, 2014.


[Mao and Mooney, 2015] Mao, Angelo S.; Mooney, David J. Regenerative medicine: Current therapies and future directions. Proceedings of the National Academy of Sciences, v. 112, n. 47, p. 14452-14459, 2015.


[Pagès et al., 2025] Pagès, H. et al. AnnotationDbi: manipulation of SQLite-based annotations in Bioconductor. R package version 1.72.0, 2025. Disponível em: https://bioconductor.org/packages/AnnotationDbi.


[Pertea et al., 2015] Pertea, M. et al. StringTie enables improved reconstruction of a transcriptome from RNA-seq reads. Nature Biotechnology, v. 33, n. 3, p. 290–295, 2015. doi:10.1038/nbt.3122.


[Shannon et al., 2003] Shannon, P. et al. Cytoscape: a software environment for integrated models of biomolecular interaction networks. Genome Research, v. 13, n. 11, p. 2498–2504, 2003.


[Thomson et al., 1998] Thomson, J. A. et al. Embryonic stem cell lines derived from human blastocysts. Science, v. 282, n. 5391, p. 1145–1147, 1998. doi:10.1126/science.282.5391.1145.


[Trapnell et al., 2014] Trapnell, C. et al. The dynamics and regulators of cell fate decisions are revealed by pseudotemporal ordering of single cells. Nature Biotechnology, v. 32, n. 4, p. 381–386, 2014. doi:10.1038/nbt.2859.


[Wen, 2017] Wen, G. A simple process of RNA-sequence analyses by Hisat2, Htseq and DESeq2. In: Proceedings of the International Conference on Biomedical Engineering and Bioinformatics. 2017. p. 11–15.


[Wingett; Andrews, 2018] Wingett, S. W.; Andrews, S. FastQ Screen: a tool for multi-genome mapping and quality control. F1000Research, v. 7, p. 1338, 2018. doi:10.12688/f1000research.15931.2.


[Yu, 2024] Yu, G. Thirteen years of clusterProfiler. The Innovation, v. 5, n. 6, p. 100722, 2024. doi:10.1016/j.xinn.2024.100722.


[Yu, 2026] Yu, G. enrichplot: visualization of functional enrichment result. R package version 1.30.5, 2026. Disponível em: https://bioconductor.org/packages/enrichplot.


[Zakrzewski et al., 2019] Zakrzewski, Wojciech et al. Stem cells: past, present, and future. Stem cell research & therapy, v. 10, n. 1, p. 68, 2019.
