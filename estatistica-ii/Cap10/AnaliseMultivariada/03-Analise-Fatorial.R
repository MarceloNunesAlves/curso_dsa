# Projeto de Análise Multivariada - Por Que os Clientes Cancelam Seus Planos de Assinatura Mensal?

# Análise Fatorial

# A Análise Fatorial é uma técnica estatística usada para identificar a estrutura relacional 
# latente entre um conjunto de variáveis e diminuir para um número menor de variáveis. 

# Isso significa essencialmente que a variação do grande número de variáveis pode ser descrita 
# por poucas variáveis de resumo, isto é, fatores. 

# A Análise Fatorial é de natureza exploratória - não conhecemos realmente as variáveis latentes 
# e as etapas são repetidas até chegarmos a um número menor de fatores. 

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap10")

# Pacotes
install.packages('PerformanceAnalytics')
install.packages('psych')
install.packages('GPArotation')
library(PerformanceAnalytics)
library(psych)
library(GPArotation)
options(warn = -1)

# Carregando os dados
clientes <- read.csv("dados/clientes.csv")
dim(clientes)
str(clientes)
View(clientes)

# Checando por valores NA
sapply(clientes, function(x) sum(is.na(x)))

# Removemos os registros com valores NA
clientes <- clientes[complete.cases(clientes),] 
sapply(clientes, function(x) sum(is.na(x)))
dim(clientes)
str(clientes)

# Criamos um dataframe a partir das 3 variáveis quantitativas
names(clientes)
clientes_var_num <- data.frame(clientes$Fidelidade, clientes$CobrancaMensal, clientes$CobrancaTotal)
str(clientes_var_num)
View(clientes_var_num)

# Vamos verificar a correlação entre as variáveis
?chart.Correlation
chart.Correlation(clientes_var_num, method = c("pearson"), histogram = TRUE, pch = "19", cex = 0.7)

# Em seguida, descobriremos o número de fatores que selecionaremos para análise de fatores. 
# Podemos usar métodos como Análise Paralela, Autovalor, PCA, etc. 

# Análise Paralela

# Usaremos a função 'fa.parallel' do pacote Psych para executar a análise paralela. 
# Especificamos o dataframe e o método do fator ('minres' no nosso caso).

# Determinando o número ideal de fatores
?fa.parallel
fa.parallel(clientes_var_num, fm = 'minres', fa = 'fa')

# O console mostra o número máximo de fatores que podemos considerar. 

# A linha azul mostra valores próprios dos dados reais e as duas linhas vermelhas 
# (colocadas uma sobre a outra) mostram dados simulados e reamostrados. 

# Aqui, examinamos as grandes quedas nos dados reais e identificamos o ponto em que está 
# nivelado à direita. Além disso, localizamos o ponto de inflexão - o ponto em que a diferença 
# entre dados simulados e dados reais tende a ser mínima.

# Olhando para esse gráfico de análise paralela, não há como usar mais de 2 fatores.

# Outra alternativa para checar o número ideal de fatores:
?scree
scree(clientes_var_num)


# Análise Fatorial Exploratória

# Agora que chegamos ao número provável de fatores, vamos explorá-los. 

# Analisando a Fatorabilidade dos Dados

# Bartlett’s Test of Sphericity
# O Teste de Esfericidade de Bartlett testa a hipótese de que as variáveis não sejam
# correlacionadas na população. A hipótese básica diz que a matriz de correlação da
# população é uma matriz identidade a qual indica que o modelo fatorial é inapropriado.

# Se este teste não for estatisticamente significativo, você não deve empregar 
# uma análise fatorial. Verificamos o valor-p. Menor que 0.05 o teste é significativo.
?cortest.bartlett
cortest.bartlett(clientes_var_num)

# O teste de Bartlett foi estatisticamente significativo, sugerindo que a matriz 
# de correlação observada entre os itens não é uma matriz identidade. 
# Isso realmente não é uma indicação particularmente poderosa de que você tem um 
# conjunto de dados fatorável. Tudo o que realmente diz é que pelo menos 
# algumas das variáveis estão correlacionadas entre si.


# Medida de Adequacidade da Amostra de Kaiser-Meyer-Olkin (KMO)
# Essa medida é representada por um índice (KMO) que avalia a adequacidade da
# análise fatorial.

# O Teste KMO é usado para verificar se as correlações parciais nos seus dados
# estão próximas o suficiente de zero para sugerir que há pelo menos um fator 
# latente subjacente às suas variáveis. O valor mínimo aceitável é 0.50, 
# mas a maioria dos autores recomenda um valor de 0.60 antes de realizar uma análise 
# fatorial. A função KMO no pacote psych produz uma medida geral de adequação da 
# amostragem (MSA). É calculado um MSA geral do teste e um MSA para cada item (variável). 
?KMO
KMO(clientes_var_num)

# O KMO para nossos dados é em torno de 0.40, o que é baixo. 
# Isso indica que a amostra não é ideal para análise fatorial.

# Vamos aplicar a análise apenas a título de demonstração e depois 
# faremos um exercício complementar!

# Para realizar a análise exploratória fatorial, usaremos a função fa() do pacote psych. 
?fa

# A seguir, estão os argumentos que forneceremos:

# r - Dados brutos ou matriz de correlação ou covariância.
# nfactors - Número de fatores a serem extraídos.
# rotate - Embora existam vários tipos de rotações, 'Varimax' e 'Oblimin' são os mais populares.
# fm - Uma das técnicas de extração de fatores como 'Mínimo Residual (OLS)', 
# 'Máxima Probabilidade',  'Eixo Principal' (PA), PCA, etc.

# Em nosso caso, selecionaremos a rotação oblíqua (rotate = "oblimin"), pois acreditamos 
# que há uma correlação nos fatores. A rotação Varimax é usada sob a suposição de que os 
# fatores são completamente não correlacionados. 

# Usaremos o fatoração 'Mínimos quadrados / mínimos ordinários' (fm = "minres"), pois é conhecido 
# por fornecer resultados semelhantes a "Máxima verossimilhança" sem assumir uma distribuição 
# normal multivariada e derivar soluções através da decomposição iterativa de autovalor como 
# um eixo principal.

# Mas vamos experimentar outros métodos de fatoração.

# Método 1 - Mínimo Residual (OLS)
analise1 <- fa(clientes_var_num, nfactors = 2, rotate = "oblimin", fm = "minres")
print(analise1)

# Esta função pode ser usada, mas reclama quando o número de fatores não é o ideal
?factanal 
factanal(clientes_var_num, factors = 2)

# Diagrama
?fa.diagram
fa.diagram(analise1)

# Como você pode ver, duas variáveis se tornaram significantes em um fator.

# Vamos mudar o método
?fa

# Método 2 - Fator Principal
analise2 <- fa(clientes_var_num, nfactors = 2, rotate = "oblimin", fm = "pa")
print(analise2)
fa.diagram(analise2)

# Método 3 - Componente Principal
?principal
analise3 <- principal(clientes_var_num, nfactors = 2, rotate = "oblimin")
print(analise3)
fa.diagram(analise3)


# Faremos a leitura das métricas de forma individual

# Total de fatores
analise1$factors

# Eigenvalues
analise1$values

# Scores R2
analise1$R2.scores

# Complexidade
analise1$complexity

# Comunalidade
# A comunalidade de cada variável é a porcentagem de variação que pode ser explicada 
# pelos fatores. O ideal é que um único fator explique o máximo de variância de uma variável.
fa.diagram(analise1)
analise1$communality

# Agora vamos considerar as cargas de cada variável, em cada fator, com mais de 0,7.
# Observe que valores negativos são aceitáveis aqui. 

# A matriz de cargas de fatores mostra quanto cada variável gera de carga em cada fator.
# A carga do fator é um índice.
print(analise1$loadings, cutoff = 0, digits = 3)
print(analise1$loadings, cutoff = 0.7, digits = 3)

# Structure mostra a correlação entre variáveis e fatores.
print(analise1$Structure, cutoff = 0, digits = 3)
print(analise1$Structure, cutoff = 0.7, digits = 3)

# Conclusão

# As variáveis fidelidade e cobrança total possuem uma forte relação, que é positiva.
# Clientes que pagam mais tendem a ser mais fiéis a marca.
# A cobrança mensal tem relevância menor para a fidelidade.
# Iss NÃO é análise de causalidade, mas sim de relação entre as variáveis.

# a análise fatorial, apesar de ser um procedimento matematicamente intensivo, é altamente subjetiva. 
# Você precisa fazer escolhas sobre:

# • O tipo de método de extração a ser usado (eixo principal ou componentes principais).
# • O número de fatores a serem extraídos.
# • O método de rotação de fatores a ser usado ao procurar uma estrutura simples (e interpretabilidade).
# • A interpretação dos fatores.

# Além disso, o resultado da sua análise fatorial (e a interpretação resultante dos fatores) será
# altamente dependente das variáveis que você seleciona para inclusão na análise. A análise fatorial 
# é um excelente método para avaliar construções latentes subjacentes mas, no cerne, é simplesmente 
# um método de analisar grandes matrizes de correlação. Se você selecionar diversas variáveis altamente 
# relacionadas, não deverá dcar surpreso se elas se agrupam para formar um fator!


