# Manipulação de Séries Temporais - Script 2


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")

# Pacote TSstudio
install.packages("TSstudio")
library(TSstudio)

# Carrega a série temporal multivariada
?Coffee_Prices
data(Coffee_Prices)

# Plot da série
ts_plot(Coffee_Prices)

# Visualiza a classe
class(Coffee_Prices)

# Visualiza a série
View(Coffee_Prices)

# Propriedades da série
frequency(Coffee_Prices)
deltat(Coffee_Prices)
head(time(Coffee_Prices))
head(cycle(Coffee_Prices))


# Criando Série Temporal univariada
dados1 = rnorm(60, 300)
exemplo_ts <- ts(data = dados1, start = c(2010, 1), end = c(2019, 12), frequency = 12)
class(exemplo_ts)
View(exemplo_ts)
plot.ts(exemplo_ts)


# Criando Série Temporal multivariada

# Gera as séries individuais
set.seed(140)
x = rnorm(100, 10)
y = rnorm(100, 30)
z = rnorm(100, 500)

dados2 = data.frame(x, y, z)

class(dados2)

# Converte o dataframe em um objeto mts
?ts
exemplo_mts <- ts(dados2, frequency = 12, start = c(1960, 4), names = c('Serie1', 'Serie2', 'Serie3'))
class(exemplo_mts)
View(exemplo_mts)
plot.ts(exemplo_mts)










