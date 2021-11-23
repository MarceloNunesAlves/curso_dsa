# Visualização de Séries Temporais


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")

# Pacotes
library(TSstudio)
library(dplyr)

# Carregando o conjunto de dados
?US_indicators
data(US_indicators)
str(US_indicators)
View(US_indicators)
class(US_indicators)

# Extraindo todas as linhas e 2 colunas do conjunto de dados
data_df <- US_indicators[, c("Date", "Vehicle Sales")] 
str(data_df)

# Transformando a data em índice do dataframe
data_df <- data_df %>% arrange(Date)
head(data_df)
class(data_df)

# Preparando os dados para transformar o dataframe em Série Temporal
library(lubridate)

# Incluindo as colunas de ano e mês no dataframe
data_df$ano <- year(data_df$Date)
data_df$mes <- month(data_df$Date)
View(data_df)

# Extraindo o início do ciclo
first_cycle_number <- data_df$ano[which.min(data_df$Date)]
first_cycle_unit <- data_df$mes[which.min(data_df$Date)]
print(c(first_cycle_number, first_cycle_unit))

# Criando a Série Temporal
data_ts <- ts(data = data_df$'Vehicle Sales',
             start = c(first_cycle_number, first_cycle_unit),
             frequency = 12)

View(data_ts)

# Comparando a data no dataframe e na série temporal
head(data_df$Date, 5)
head(time(data_ts), 5)

# Comparando os dados no dataframe e na série temporal
head(data_df$'Vehicle Sales')
head(data_ts)
identical(data_df$'Vehicle Sales', as.numeric(data_ts))


# Visualização de Séries Temporais

# Plot com o pacote base da Linguagem R
?plot.ts

plot.ts(data_ts, 
        main = "Total de Venda de Veículos Por Mês",
        ylab = "Milhares de Veículos",
        xlab = "Tempo"
)

# Plot com dygraphs
library(dygraphs)  

dygraph(data_ts, 
        main = "Total de Venda de Veículos Por Mês",
        ylab = "Milhares de Veículos") %>% 
  dyRangeSelector()

# Plot com TSstudio
library(TSstudio)

ts_plot(data_ts,
        title = "Total de Venda de Veículos Por Mês",
        Ytitle = "Milhares de Veículos",
        slider = TRUE
)


