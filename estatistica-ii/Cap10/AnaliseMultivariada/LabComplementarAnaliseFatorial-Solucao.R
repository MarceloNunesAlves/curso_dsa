# Análise Fatorial - Solução do Lab

# Lab Complementar - Data Science Aplicada em Psicologia
# Psicometria e Análise de Personalidade em R

# Definição do Problema

# Leia o manual em pdf com a definição completa do problema no item de aprendizagem:
# Lab Complementar - Data Science Aplicada em Psicologia - Psicometria e Análise de Personalidade em R

# Dataset

# Leia o manual em pdf com a definição doo dataset no item de aprendizagem:
# Lab Complementar - Data Science Aplicada em Psicologia - Psicometria e Análise de Personalidade em R

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap10")

# Pacotes
install.packages('psych')
install.packages('GPArotation')
library(psych)
library(GPArotation)
options(warn = -1)

# Carregando os dados
?bfi
data("bfi")
dim(bfi)
View(bfi)

# Como não queremos que nossa análise seja influenciada por gênero, educação ou idade, vamos excluir as 
# 3 últimas variáveis.
df_psico <- bfi[1:25]
dim(df_psico)
View(df_psico)

# Casos completos
# complete.cases() retorna verdadeiro se não houver valor ausente
sum(complete.cases(df_psico))

# Removemos os valores ausentes
df_psico <- na.omit(df_psico)
dim(df_psico)
View(df_psico)

# 1-O dataset é adequado para análise fatorial? Justifique.

# Avaliando a Fatorabilidade dos Dados

# Teste de Esfericidade de Bartlett
cortest.bartlett(df_psico)

# Análise:
# O teste de Bartlett foi estatisticamente significativo, sugerindo que a matriz de correlação observada 
# entre os itens não é uma matriz identidade. Isso realmente não é uma indicação particularmente 
# poderosa de que você tem um conjunto de dados fatorável.  Tudo o que realmente diz é que pelo 
# menos algumas das variáveis estão correlacionadas entre si.

# Medida de Adequacidade da Amostra de Kaiser-Meyer-Olkin (KMO)
KMO(df_psico)

# Análise:
# O KMO geral para nossos dados é 0,85, o que é excelente - isso sugere que podemos prosseguir com 
# nossa análise fatorial.

# 2-Qual o número ideal de fatores para a análise? Justifique

# Determinando o Número de Fatores
fa.parallel(df_psico)

# A análise paralela sugere 6 fatores.

# 3-Para a Análise Fatorial recomendamos o uso do método de fatoração PA.
# O método baseado no PCA apresenta diferenças significativas? Justifique

analise_v1_pa <- fa(df_psico, nfactors = 6, fm = "pa", max.iter = 100,  rotate = "oblimin")
fa.diagram(analise_v1_pa)

analise_v1_pca <- principal(df_psico, nfactors = 6, rotate = "oblimin")
fa.diagram(analise_v1_pca)

# Como você pode ver, o sexto fator tem apenas uma variável e isso provavelmente representa uma 
# superextração. Vamos dar uma olhada o que acontece com cinco fatores.

analise_v2_pa <- fa(df_psico, nfactors = 5, fm = "pa", max.iter = 100,  rotate = "oblimin")
fa.diagram(analise_v2_pa)

analise_v2_pca <- principal(df_psico, nfactors = 5, rotate = "oblimin")
fa.diagram(analise_v2_pca)

# A solução de cinco fatores é mais interpretável e, de fato, parece replicar a estrutura fatorial 
# esperada de forma mais clara. Seguiremos com a análise baseada em fator principal (pa).

# 4-Qual o percentual de variância explicado pelos fatores para cada variável?

# A comunalidade de cada variável é a porcentagem de variação que pode ser explicada 
# pelos fatores. O ideal é que um único fator explique o máximo de variância de uma variável.
print(analise_v2_pa$communality)

# 5-Qual o percentual de variância explicado por cada fator?

percentual_var_fator <- 100 * analise_v2_pa$e.values[1:5] / length(analise_v2_pa$e.values)
percentual_var_fator







