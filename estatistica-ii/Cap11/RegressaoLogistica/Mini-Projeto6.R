# Mini-Projeto 6 - Quais Fatores Influenciam as Preferências de Voto dos Eleitores Europeus?

# Leia o manual em pdf com a definição do projeto.

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap11/RegressaoLogistica")

# Instalação dos pacotes

# Pacotes para análise e modelagem
install.packages("texreg")
library(tidyverse)
library(tidyr)
library(dplyr)
library(texreg)
library(foreign)
library(readr)
library(ggplot2)


# Pacote com os dados para análise
install.packages("devtools")
devtools::install_github("ropensci/essurvey")
install.packages("essurvey")
library(essurvey)


##### Carregando os Dados ##### 

# https://github.com/ropensci/essurvey
show_countries()
df_ess <- import_rounds(9)


# Use o e-mail que você cadastrou no site: https://www.europeansocialsurvey.org/
set_email("digite_seu_email")
df_ess <- import_rounds(9)


# Carga de dados com recode dos valores missing
df_ess <-
  import_rounds(9) %>%
  recode_missings()


# Resumo dos dados
class(df_ess)
summary(df_ess)
dim(df_ess)
names(df_ess)
View(df_ess)


# Vamos filtrar o dataset e trabalhar com apenas algumas variáveis
df_ess_final <- df_ess[,c("vteurmmb", "cntry", "eduyrs", "uemp3m", "mbtru")]
dim(df_ess_final)
View(df_ess_final)


##### Análise Exploratória ##### 

# Checando por valores missing
sum(is.na(df_ess_final))

# Variável com a resposta se a pessoa deseja ou não a saída do seu país da UE
str(df_ess_final$vteurmmb)
table(df_ess_final$vteurmmb)
class(df_ess_final$vteurmmb)

# Variável com a sigla do país
str(df_ess_final$cntry)
table(df_ess_final$cntry)
class(df_ess_final$cntry)

# Variável representando o tempo total de educação (em anos)
str(df_ess_final$eduyrs)
table(df_ess_final$eduyrs)
summary(df_ess_final$eduyrs)
class(df_ess_final$eduyrs)

# Variável representando se o respondente estava ou não desempregado
str(df_ess_final$uemp3m)
table(df_ess_final$uemp3m)
class(df_ess_final$uemp3m)

# Variável representando a participação em sindicatos
str(df_ess_final$mbtru)
table(df_ess_final$mbtru)
class(df_ess_final$mbtru)

# Plot
ggplot(df_ess_final, aes(x = eduyrs, 
                         y = vteurmmb, 
                         color = uemp3m)) + 
  geom_jitter(width = 0, height = 0.09, alpha = 0.5)


##### Modelagem com Regressão Logística ##### 

# A regressão logística é um modelo linear que transforma a saída do modelo em probabilidades
# através da aplicação da função logit.
?glm
names(df_ess_final)
View(df_ess_final)
modelo_v1 <- glm(vteurmmb ~ cntry + eduyrs + uemp3m + mbtru,
                 data = df_ess_final, 
                 family = binomial(link = "logit"))

summary(modelo_v1)
screenreg(modelo_v1)


# Limpeza - Removendo Valores NA
sum(is.na(df_ess_final))
dim(df_ess_final)
df_ess_final_limpo <- df_ess_final[complete.cases(df_ess_final), ]
sum(is.na(df_ess_final_limpo))
dim(df_ess_final_limpo)


# Segunda versão do modelo
modelo_v2 <- glm(vteurmmb ~ cntry + eduyrs + uemp3m + mbtru,
                 data = df_ess_final_limpo, 
                 family = binomial(link = "logit"))

summary(modelo_v2)
screenreg(modelo_v2)
View(df_ess_final_limpo)


# Aplicando Transformações nas Variáveis
table(df_ess_final$vteurmmb)
table(df_ess_final$cntry)
table(df_ess_final$eduyrs)
table(df_ess_final$uemp3m)
table(df_ess_final$mbtru)

# Transformando as variáveis

# Cria uma cópia do dataframe
df_ess_clean <- df_ess_final_limpo

# Ajustando os valores das variáveis do tipo fator

df_ess_clean$vteurmmb <- as.character(df_ess_clean$vteurmmb)
df_ess_clean$vteurmmb[df_ess_clean$vteurmmb == "Remain member of the European Union"] <- "Remain"
df_ess_clean$vteurmmb[df_ess_clean$vteurmmb == "Leave the European Union"] <- "Leave"
df_ess_clean$vteurmmb[df_ess_clean$vteurmmb == "Would submit a blank ballot paper"] <- "Other"
df_ess_clean$vteurmmb[df_ess_clean$vteurmmb == "Would spoil the ballot paper"] <- "Other"
df_ess_clean$vteurmmb[df_ess_clean$vteurmmb == "Would not vote"] <- "Other"
df_ess_clean$vteurmmb[df_ess_clean$vteurmmb == "Not eligible to vote"] <- "Other"
df_ess_clean$vteurmmb <- as.factor(df_ess_clean$vteurmmb)
table(df_ess_clean$vteurmmb)

df_ess_clean$uemp3m <- as.character(df_ess_clean$uemp3m)
df_ess_clean$uemp3m <- as.factor(df_ess_clean$uemp3m)
table(df_ess_clean$uemp3m)

df_ess_clean$mbtru <- as.character(df_ess_clean$mbtru)
df_ess_clean$mbtru[df_ess_clean$mbtru == "Yes, currently"] <- "Yes"
df_ess_clean$mbtru[df_ess_clean$mbtru == "Yes, previously"] <- "Yes"
df_ess_clean$mbtru <- as.factor(df_ess_clean$mbtru)
table(df_ess_clean$mbtru)

# Obs: Leia os manuais em pdf no Capítulo 11 do curso com os detalhes 
# do funcionamento da Regressão Logística.

# Terceira versão do modelo
modelo_v3 <- glm(vteurmmb ~ cntry + eduyrs + uemp3m + mbtru,
                 data = df_ess_clean, 
                 family = binomial(link = "logit"))

summary(modelo_v3)
screenreg(modelo_v3)

# Quarta versão do modelo
modelo_v4 <- glm(vteurmmb ~ eduyrs + uemp3m + mbtru,
                 data = df_ess_clean, 
                 family = binomial(link = "logit"))

summary(modelo_v4)
screenreg(modelo_v4)

# Previsões
df_ess_clean$pps1 <- predict(modelo_v4, newdata = df_ess_clean, type = "response")
df_ess_clean$evs1 <- ifelse(df_ess_clean$pps1 > 0.5, yes = 1, no = 0)
View(df_ess_clean)

# Qual a probabilidade de um cidadão com 13 anos de educação, desempregado e que não participa
# de sindicatos votar pela saída do seu país da União Européia?
pessoa1 <- predict(modelo_v4,
                   newdata = data.frame(eduyrs = 13, uemp3m = 'Yes', mbtru = 'No'),
                   type = "response")

pessoa1

# Qual a probabilidade de um cidadão com 20 anos de educação, empregado e que não participa
# de sindicatos votar pela saída do seu país da União Européia?
pessoa2 <- predict(modelo_v4,
                   newdata = data.frame(eduyrs = 20, uemp3m = 'No', mbtru = 'No'),
                   type = "response")

pessoa2 

# Plot
perfil_educacional <- data.frame(eduyrs = seq(from = 0, to = 54, by = .5),
                                 uemp3m =  'No', 
                                 mbtru = 'No')
View(perfil_educacional)

# Previsões
perfil_educacional$predicted_probs <- predict(modelo_v4, 
                                              newdata = perfil_educacional, 
                                              type = "response")
View(perfil_educacional)

# Plot: Perfil de Voto Pelo Tempo de Educação
ggplot(perfil_educacional, 
       aes(x = eduyrs, y = predicted_probs)) + 
  geom_line(alpha = 0.5) + 
  ylab("Probabilidade de Votar Pela Saída da UE") + 
  xlab("Número de Anos de Educação") + 
  ggtitle("Perfil de Voto Pelo Tempo de Educação")




