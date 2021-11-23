# Análise de Sazonalidade - Exercício

# Neste exercício você vai realizar Análise de Sazonalidade no dataset UKgrid.
# Você deve responder às seguintes perguntas:

# 1- Qual a média e desvio padrão de consumo por hora?
# 2- Mostre em um único Plot a média e desvio padrão de consumo por hora.
# 3- Qual a média e desvio padrão de consumo às 6 horas e 18 horas por dia da semana?
# 4- Mostre em um único Plot a média de consumo às 6 horas e 18 horas por dia da semana.
# 5- Qual a média e desvio padrão de consumo às 6 horas e 18 horas por mês?
# 6- Mostre em um único Plot a média de consumo às 6 horas e 18 horas por mês.


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap08")

# Pacotes
library(TSstudio)
library(dplyr)
library(plotly)
library(zoo)
library(xts)
library(UKgrid)
library(lubridate)


# Carregando o conjunto de dados (Padrão sazonal múltiplo)
?UKgrid
?extract_grid
UKgrid_ts <- extract_grid(type = "xts", columns = "ND", aggregate = "hourly", na.rm = TRUE)


# Informações sobre a série
ts_info(UKgrid_ts)


# Convertendo a série para dataframe
df_UKgrid <- data.frame(Horario = index(UKgrid_ts), Consumo = as.numeric(UKgrid_ts))
str(df_UKgrid)
View(df_UKgrid)


# Criando uma coluna para armazenar a hora



# Criando uma coluna para armazenar o dia da semana em formato abreviado



# Criando uma coluna para armazenar o mês em formato abreviado



# Dataset com as novas colunas
View(df_UKgrid)


# 1- Qual a média e desvio padrão de consumo por hora?



View(df_UKgrid_media_horaria)


# 2- Mostre em um único Plot a média e desvio padrão de consumo por hora
plot_ly(df_UKgrid_media_horaria) %>%



# 3- Qual a média e desvio padrão de consumo às 6 horas e 18 horas por dia da semana?


View(df_UKgrid_dia_semana)


# 4- Mostre em um único Plot a média de consumo às 6 horas e 18 horas por dia da semana.

# Converte a coluna Hora para fator, a fim de poder criar o plot.
df_UKgrid_dia_semana$Hora <- factor(df_UKgrid_dia_semana$Hora)
View(df_UKgrid_dia_semana)
str(df_UKgrid_dia_semana)

# Plot



# 5- Qual a média e desvio padrão de consumo às 6 horas e 18 horas por mês?


View(df_UKgrid_mes)

# 6- Mostre em um único Plot a média de consumo às 6 horas e 18 horas por mês.

# Converte a coluna Hora para fator, a fim de poder criar o plot.
df_UKgrid_mes$Hora <- factor(df_UKgrid_mes$Hora)
View(df_UKgrid_mes)

# Plot




