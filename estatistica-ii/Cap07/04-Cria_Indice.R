# Criando Índices do Tipo Data e Tempo


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")


# Criando índice diário com objeto de data
indice_diario <- seq.Date(from = as.Date("2017-01-01"), 
                          to = as.Date("2019-12-31"), 
                          by = "day")

View(indice_diario)


# Criando índice diário de 3 dias de incremento com objeto de data
indice_diario_3 <- seq.Date(from = as.Date("2017-01-01"), 
                          to = as.Date("2019-12-31"), 
                          by = "3 days")

View(indice_diario_3)
str(indice_diario_3)


# Criando índice com objeto time
index_horario <- seq.POSIXt(from = as.POSIXct("2019-06-01"), by = "hours", length.out = 48)
View(index_horario)
str(index_horario)




