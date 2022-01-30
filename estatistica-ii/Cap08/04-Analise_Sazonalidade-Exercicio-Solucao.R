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
?lubridate::hour
df_UKgrid$Hora <- hour(df_UKgrid$Horario)


# Criando uma coluna para armazenar o dia da semana em formato abreviado
df_UKgrid$Dia_Semana <- wday(df_UKgrid$Horario, label = TRUE, abbr = TRUE)


# Criando uma coluna para armazenar o mês em formato abreviado
df_UKgrid$Mes <- factor(month.abb[month(df_UKgrid$Horario)], levels = month.abb)


# Dataset com as novas colunas
View(df_UKgrid)


# 1- Qual a média e desvio padrão de consumo por hora?
df_UKgrid_media_horaria <- df_UKgrid %>% 
  dplyr::group_by(Hora) %>%
  dplyr::summarise(Media = mean(Consumo, na.rm = TRUE), Desvio_Padrao = sd(Consumo, na.rm = TRUE)) 

View(df_UKgrid_media_horaria)


# 2- Mostre em um único Plot a média e desvio padrão de consumo por hora
plot_ly(df_UKgrid_media_horaria) %>%
  add_lines(x = ~ Hora, y = ~ Media, name = "Média") %>%
  add_lines(x = ~ Hora, y = ~ Desvio_Padrao, name = "Desvio Padrão", yaxis = "y2",
            line = list(color = "red", dash = "dash", width = 4)) %>%
  layout(
    title = "Média e Desvio Padrão de Consumo Por Hora e Por Dia de Semana", 
    yaxis = list(title = "Média"),
    yaxis2 = list(overlaying = "y", side = "right", title = "Desvio Padrão"),
    xaxis = list(title = "Hora do Dia"),
    legend = list(x = 0.05, y = 0.9),
    margin = list(l = 50, r = 50)
)


# 3- Qual a média e desvio padrão de consumo às 6 horas e 18 horas por dia da semana?
View(df_UKgrid)
df_UKgrid_dia_semana <- df_UKgrid %>% 
  dplyr::filter(Hora == 6 | Hora == 18) %>%
  dplyr::group_by(Hora, Dia_Semana) %>%
  dplyr::summarise(Media = mean(Consumo, na.rm = TRUE), Desvio_Padrao = sd(Consumo, na.rm = TRUE)) 

View(df_UKgrid_dia_semana)


# 4- Mostre em um único Plot a média de consumo às 6 horas e 18 horas por dia da semana.

# Converte a coluna Hora para fator, a fim de poder criar o plot.
df_UKgrid_dia_semana$Hora <- factor(df_UKgrid_dia_semana$Hora)
View(df_UKgrid_dia_semana)
str(df_UKgrid_dia_semana)

# Plot
plot_ly(data = df_UKgrid_dia_semana, 
        x = ~ Dia_Semana, 
        y = ~ Media, 
        type = "bar", 
        color = ~ Hora,
        colors = "Set1") %>%
  layout(title = "Demanda Média Horária Por Dia da Semana",
         yaxis = list(title = "Média"), 
         xaxis = list(title = "Dia da Semana"))


# 5- Qual a média e desvio padrão de consumo às 6 horas e 18 horas por mês?
df_UKgrid_mes <- df_UKgrid %>% 
  dplyr::filter(Hora == 6 | Hora == 18) %>%
  dplyr::group_by(Hora, Mes) %>%
  dplyr::summarise(Media = mean(Consumo, na.rm = TRUE), Desvio_Padrao = sd(Consumo, na.rm = TRUE)) 

View(df_UKgrid_mes)

# 6- Mostre em um único Plot a média de consumo às 6 horas e 18 horas por mês.

# Converte a coluna Hora para fator, a fim de poder criar o plot.
df_UKgrid_mes$Hora <- factor(df_UKgrid_mes$Hora)
View(df_UKgrid_mes)

# Plot
plot_ly(data = df_UKgrid_mes, 
        x = ~ Mes, 
        y = ~ Media, 
        type = "bar",
        color = ~ Hora,
        colors = "Set1") %>%
  layout(title = "Média de Consumo Por Hora e Por Mês",
         yaxis = list(title = "Média"), 
         xaxis = list(title = "Mês"))



