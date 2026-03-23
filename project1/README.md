# P1 - Template da Primeira Entrega
*2026.1 Ciência e Visualização de Dados em Saúde*

# Projeto `<Dinâmica Temporal e Redes de Coexpressão Gênica da Diferenciação de Células-Tronco Embrionárias>`
# Project `<Temporal Dynamics and Gene Co-expression Networks of Embryonic Stem Cell Differentiation>`

# Descrição Resumida do Projeto

> Este projeto tem como principal objetivo analisar e comparar a dinâmica temporal da expressão gênica durante a diferenciação de células-tronco embrionárias humanas (hESCs) em duas linhagens distintas: cardiomiócitos (mesoderme) e células polihormonais pancreáticas (endoderme).
> Apesar de compartilharem o mesmo genoma, tais células adquirem identidades distintas ao longo de seu processo de diferenciação, resultado de mudanças coordenadas na regulação gênica, da ativação de vias biológicas específicas e do desenvolvimento de interações moleculares únicas. Dessa forma, a compreensão das dinâmicas que regem o processo de diferenciação celular mostra-se essencial para a elucidação dos mecanismos subjacentes ao desenvolvimento embrionário e, consequentemente, para a identificação de potenciais alvos moleculares em aplicações de medicina regenerativa.
> Sendo assim, utilizando dados públicos de RNA-seq com resolução temporal, o projeto propõe integrar análise de expressão diferencial, enriquecimento funcional e ciência de redes para a identificação de padrões comuns e específicos entre as duas linhagens celulares estudadas. Nesse sentido, espera-se que redes de coexpressão gênica sejam construídas e analisadas quanto a suas propriedades topológicas ao longo do intervalo analisado, permitindo a identificação de genes centrais, módulos funcionais e eventos críticos no processo de diferenciação celular.


# Slides

> [Apresentação da Entrega 01 do Projeto da Disciplina](https://www.canva.com/design/DAHEfhZXZo8/FAfFwt-R1tJzMNhc0V6zjw/edit?utm_content=DAHEfhZXZo8&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton).

# Fundamentação Teórica

> Keskin et al. (2025, 2026): Textos base para o entendimento completo dos dados que serão utilizados nas análises;
> Trapnell et al. (2014): Exemplo prático de análises possíveis para dados transcriptômicos obtidos ao longo do processo de diferenciação celular;
> Zakrzewski et al. (2019), Campbell et al. (2019), Mao and Mooney (2015): Revisões gerais detalhando conceitos como medicina regenerativa e diferenciação celular.

De maneira geral, o conceito de célula-tronco estende-se ao conjunto de células com alto grau de potencialidade e baixo estado de diferenciação, as quais estão aptas à originar tipos celulares específicos, a partir do processo de diferenciação celular (Campbell et al., 2019). No que diz respeito à sua potencialidade, uma célula-tronco pode ser classificada sob grupos distintos, estes representativos de seu poder de diferenciação, a saber: células totipotentes, capazes de originar todos os tipos celulares de um organismo (zigoto, por exemplo); células pluripotentes (PSCs - do inglês, Pluripotent Stem Cells), incapazes de diferenciar-se em estruturas extraembrionárias, como a placenta, porém aptas a originar linhagens pertencentes aos três folhetos embrionários (endoderme, mesoderme e ectoderme); células multipotentes, cujo alcance de diferenciação mostra-se menor do que aquele identificado em PSCs, mas ainda capazes de diferenciar-se em linhagens celulares específicas; células unipotentes, limitadas a diferenciação em um único tipo celular específico (Campbell et al., 2019, Zakrzewski et al., 2019). 

Adicionalmente, as células-tronco podem ainda ser classificadas quanto ao seu modo de origem, em: células adultas; células-tronco pluripotentes induzidas (iPSCs - do inglês, Induced pluripotent stem cells); células embrionárias (ESCs - do inglês, Embryonic stem cells) (Campbell et al., 2019). Tendo em vista essa alta capacidade de diferenciação em tipos celulares específicos, muito se tem estudado a respeito da aplicação de células-tronco em estudos de medicina regenerativa, sendo uma alternativa segura ao transplante de órgãos e suas limitações inerentes (Mao and Mooney, 2015). No entanto, os mecanismos moleculares subjacentes ao processo de diferenciação celular apresentam-se com elevado grau de complexidade, uma vez que redes regulatórias robustas integram sinais temporais, espaciais, genéticos e ambientais na manutenção da especificação correta de uma ampla gama de linhagens celulares. Dessa forma, levando em conta a dinamicidade de tal processo, o entendimento completo acerca das etapas de diferenciação de células-tronco em tecidos específicos demanda a avaliação rigorosa de variáveis experimentais distintas.  

Nesse sentido, como evidenciado por Trapnell et al. (2014), a diferenciação celular mostra-se como um processo dinâmico e contínuo, no qual estados intermediários podem ser identificados por meio da análise temporal da expressão gênica, permitindo a identificação de transições críticas no destino celular. Baseando-se neste mesmo princípio, em seus estudos, Keskin et al. (2025, 2026) demonstraram que a diferenciação de células tronco embrionárias humanas (hESCs) em cardiomiócitos e células polihormonais envolve mudanças coordenadas na expressão gênica ao longo de múltiplos estágios temporais, levando à ativação progressiva de vias metabólicas e regulatórias específicas. À vista disso, a geração de novos dados experimentais referentes às etapas do processo de diferenciação de hESCs em tipos celulares específicos fornece material suficiente para a criação de modelos computacionais robustos, os quais cruciais para a resolução de questões ainda não esclarecidas sobre os mecanismos particulares à diferenciação celular. 


# Perguntas de Pesquisa

> Existe diferença entre as dinâmicas de expressão gênica encontradas ao longo do processo de diferenciação de células-tronco pluripotentes em cardiomiócitos e células polihormonais?
> Como a dinâmica temporal das redes de coexpressão gênica influencia o processo de diferenciação de células-tronco embrionárias humanas em cardiomiócitos e células pancreáticas?

## Hipóteses a serem testadas

> H0: A dinâmica da expressão gênica ao longo do processo de diferenciação de células-tronco pluripotentes em cardiomiócitos é idêntica àquela observada na diferenciação de células polihormonais. 
> H1: A dinâmica da expressão gênica ao longo do processo de diferenciação de células-tronco pluripotentes em cardiomiócitos é distinta àquela observada na diferenciação de células polihormonais.



# Bases de Dados

> A base de dados está disponível no Gene Expression Omnibus pelos números de acesso: GSE274620 (Keskin et al., 2025a) e GSE305933 (Keskin et al., 2025b). Ambos foram utilizados em estudo anterior para avaliar o perfil multi-ômico de células-tronco embrionárias. Para a autenticação e controle de qualidade, os autores compararam os conjuntos de dados com a linhagem RUES2 hESC (HPSCREG, 2026), disponibilizada pela The Rockefeller University.

> Base de Dados | Endereço na Web | Resumo descritivo
> ----- | ----- | -----
> GSE274620 | [URL NCBI](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE274620) | Proveniente do Gene Expression Omnibus. Amostras de RNA-seq da linhagem mesoderme de células tronco. Diferenciação em cardiomiócitos com série temporal.
> GSE305933 | [URL NCBI](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE305933) | Proveniente do Gene Expression Omnibus. Amostras de RNA-seq da linhagem endoderme de células tronco. Diferenciação em células pancreáticas polihormonais  com série temporal.
> SAMEA104387770 | [URL hPSCreg](https://hpscreg.eu/cell-line/RUESe002-A) | Proveninete do hPSCreg. Amostras de RNA-seq de células tronco embrionárias. Diferenciação de blastocistos em endoderme, ectoderme e mesoderme.

# Modelo Lógico

> ![Modelo Lógico de Grafos](images/Project1_logic_model_COMBI.png)

# Metodologia
> Esta seção evoluirá ao longo do projeto. Nesta primeira entrega, informe técnicas de Ciência de Redes que pretende explorar,
> tais como: detecção de comunidades, análise de centralidade, predição de links, ou a combinação de uma ou mais técnicas. Descreva o que perguntas pretende endereçar cm a técnica escolhida.

# Ferramentas

> Ferramentas a serem utilizadas (com base na visão atual do grupo sobre o projeto).

# Referências Bibliográficas

> Lista de artigos, links e referências bibliográficas.
>
> Fiquem à vontade para escolher o padrão de referenciamento preferido pelo grupo.
