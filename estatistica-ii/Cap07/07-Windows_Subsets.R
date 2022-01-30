# Extraindo Subsets (Windows) de Séries Temporais


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")

# Pacotes
library(Quandl)
library(TSstudio)

# Carregando a série
Serie_NGC <- Quandl(code = "FRED/NATURALGAS",
                    collapse = "quarterly",
                    type = "ts",
                    end_date = "2017-12-31")

# Detalhes da série
class(Serie_NGC)
start(Serie_NGC)
end(Serie_NGC)
frequency(Serie_NGC)
plot(Serie_NGC)

# Extraindo subsets da série
?subset
?window

# Extraindo todos os registros de 2006 - trimestres de 1 a 4 em 2006
window(Serie_NGC, start = c(2006, 1), end = c(2006, 4))

# Extraindo todos os registros que ocorreram no trimestre 4 de cada ano a partir de 2002
# Frequency = 1 retorna os dados anualmente
window(Serie_NGC, start = c(2002, 4), frequency = 1)

# Extraindo todos os registros que ocorreram no trimestre 3 entre os anos de 2007 e 2013
window(Serie_NGC, start = c(2007, 3), end = c(2013, 3), frequency = 1)


# Agregação de Séries Temporais
?aggregate

# Total por ano em todas as séries (de 2000 a 2017)
Serie_NGC_Ano <- aggregate(Serie_NGC, nfrequency = 1, FUN = "sum")
Serie_NGC_Ano
ts_info(Serie_NGC_Ano)

# Média por ano entre 2007 e 2013
subset1 <- window(Serie_NGC, start = c(2007, 1), end = c(2013, 4), frequency = 4)
class(subset1)
subset1

Serie_NGC_Media_Tri <- aggregate(subset1, nfrequency = 1, FUN = "mean")
Serie_NGC_Media_Tri
ts_info(Serie_NGC_Media_Tri)







