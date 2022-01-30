# Operações com Datas


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")


# Pacote Lubridate
install.packages("lubridate")
library(lubridate)

# Intervalo de Datas
data_inicio_evento <- dmy("13-07-2019")
data_fim_evento <- dmy("24-09-2019")

intervalo <- interval(data_inicio_evento, data_fim_evento)
intervalo
class(intervalo)
as.period(intervalo)

# Intervalo de Datas
intervalo <- dmy("01-04-2019") %--% dmy("30-04-2019") 
intervalo

# Número de dias
intervalo / ddays(2)              

# Número de minutos
intervalo / dminutes(1) 


# Somando Datas

data <- dmy(25032019)
data

# Somando 1 dia
data + ddays(1)

# Somando 1 ano
data + dyears(1)

# Somando 1 mês
data + months(1)  


# Criando Datas Recorrentes

reuniao <- dmy("16-05-2019")
reunioes <- reuniao + weeks(1:5)
reunioes


