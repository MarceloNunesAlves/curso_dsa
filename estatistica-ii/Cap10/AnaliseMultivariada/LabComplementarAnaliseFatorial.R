# Análise Fatorial

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






