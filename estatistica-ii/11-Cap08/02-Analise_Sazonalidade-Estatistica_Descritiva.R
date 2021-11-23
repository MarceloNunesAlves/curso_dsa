# Análise de Sazonalidade - Estatística Descritiva

# Considerando a série temporal USgas do pacote TSStudio, responda à seguinte pergunta:

# Qual é a Média Mensal de Consumo de Gas nos EUA?

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap08")

# Pacotes
library(TSstudio)
library(dplyr)
library(plotly)
library(zoo)

# Carregando o dataset
data(USgas)
ts_info(USgas)
class(USgas)
View(USgas)

# Transformanfo o objeto ts em um dataframe
df_USgas <- data.frame(year = floor(time(USgas)),  
                       month = cycle(USgas), 
                       USgas = as.numeric(USgas))

class(df_USgas)
View(df_USgas)
names(df_USgas) <- c('Ano', 'Mes', 'Consumo')
View(df_USgas)

# Configurando mês de forma abreviada e em string e transformando em tipo fator
?month.abb
df_USgas$Mes <- factor(month.abb[df_USgas$Mes], levels = month.abb)
View(df_USgas)
str(df_USgas)

# Sumarizando a série por sua unidade de frequêcia
df_USgas_sumario <- df_USgas %>% 
  group_by(Mes) %>%
  summarise(mean = mean(Consumo), sd = sd(Consumo))

names(df_USgas_sumario) <- c('Mes', 'Media', 'Desvio_Padrao')
View(df_USgas_sumario)

# Plot
plot_ly(data = df_USgas_sumario,
        x = ~ Mes,
        y = ~ Media,
        type = "bar",
        name = "Mean") %>%
  layout(title = "Média Mensal de Consumo de Gas nos EUA",
         yaxis = list(title = "Média", range = c(1500, 2700)))


