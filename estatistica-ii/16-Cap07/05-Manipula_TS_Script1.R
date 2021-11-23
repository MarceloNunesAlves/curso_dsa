# Manipulação de Séries Temporais - Script 1


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")


# Pacote Quandl
# https://www.quandl.com
install.packages("Quandl")
library(Quandl)

# Carrega a série temporal
dataset_serie_temporal1 <- Quandl(code = "FRED/NATURALGAS",
                                  collapse = "quarterly",
                                  type = "ts",
                                  end_date = "2018-12-31")

class(dataset_serie_temporal1)
View(dataset_serie_temporal1)

# Plot da série
# Obs: Um pé cúbico é equivalente a exatamente 0,028316846592 quilolitros ou metros cúbicos.
plot.ts(dataset_serie_temporal1,
        main = "Consumo Trimestral de Gas Natural nos EUA",
        ylab = "Bilhão de Pés Cúbicos")

# Verificando detalhes da série
is.ts(dataset_serie_temporal1) 
length(dataset_serie_temporal1)

# Propriedades da série
head(cycle(dataset_serie_temporal1), 32)
head(time(dataset_serie_temporal1), 32)
frequency(dataset_serie_temporal1)
deltat(dataset_serie_temporal1)

start(dataset_serie_temporal1)
end(dataset_serie_temporal1)


# O pacote TSstudio
install.packages("TSstudio")
library(TSstudio)

ts_info(dataset_serie_temporal1)


