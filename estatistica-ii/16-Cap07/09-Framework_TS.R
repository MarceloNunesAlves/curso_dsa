# Framework Avançado Para Manipulação de Séries Temporais Regulares e Irregulares
# Classes zoo e xts

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")

##### Trabalhando com a classe zoo ##### 

# Pacotes
library(TSstudio)
library(zoo)

# Dataset
?EURO_Brent
data(EURO_Brent)
ts_info(EURO_Brent)
class(EURO_Brent)

# Detalhes da série
frequency(EURO_Brent)
View(cycle(EURO_Brent))
start(EURO_Brent)
end(EURO_Brent)

# Índice da sére
head(time(EURO_Brent), 12)
head(index(EURO_Brent))
class(index(EURO_Brent))
attributes(index(EURO_Brent))

# Manipulando os índices
index(EURO_Brent) <- as.Date(index(EURO_Brent))
View(EURO_Brent)
class(index(EURO_Brent))

# Manipulando datas
datas <- seq.Date(from = as.Date("2019-01-01"), length.out = 12, by = "month")
head(datas)
class(datas)

?as.yearmon
data_yearmon <- as.yearmon(datas)
head(data_yearmon)

# Criando séries temporais do tipo zoo

# Carregando o dataset original
data(US_indicators)
str(US_indicators)
class(US_indicators)

# Criando a série 1
?zoo
veiculos_ts1 <- zoo(x = US_indicators$'Vehicle Sales', frequency = 12)
class(veiculos_ts1)
class(index(veiculos_ts1))
frequency(veiculos_ts1)
View(veiculos_ts1)

# Criando a série 2
veiculos_ts2 <- zoo(x = US_indicators$'Vehicle Sales', 
                    order.by = US_indicators$Date, 
                    frequency = 12)

View(veiculos_ts2)
class(index(veiculos_ts2))
frequency(veiculos_ts2)

# Criando a série 3
?USgas
data(USgas)
class(USgas)
View(USgas)

# Convertendo de ts para zoo
?as.zoo
USgas_zoo <- as.zoo(USgas)

ts_info(USgas)
class(index(USgas))

ts_info(USgas_zoo)
class(index(USgas_zoo))

# Verificando se a série é regular

# As séries temporais irregulares: são dados de séries temporais em que os intervalos de 
# tempo entre as observações da série são desigualmente espaçados. 

# As séries temporais estritamente regulares: são as séries temporais em que todas as 
# observações da série são igualmente espaçadas. 

?is.regular

class(EURO_Brent)
is.regular(EURO_Brent, strict = TRUE)

class(veiculos_ts1)
is.regular(veiculos_ts1, strict = TRUE)

is.regular(veiculos_ts2, strict = TRUE)
is.regular(USgas_zoo, strict = TRUE)


##### Trabalhando com a classe xts ##### 

# Pacotes
library(TSstudio)
library(xts)

# A classe xts é um objeto zoo com atributos adicionais.
# xts = eXtensible time series
?xts

# Carregando o dataset original
data(US_indicators)

veiculos_xts_1 <- xts(x = US_indicators[,c("Vehicle Sales", "Unemployment Rate")], 
                      frequency = 12,
                      order.by = US_indicators$Date)

View(veiculos_xts_1)
class(veiculos_xts_1)
periodicity(veiculos_xts_1)
indexClass(veiculos_xts_1)
head(.indexmon(veiculos_xts_1), 12)

veiculos_xts_2 <- veiculos_xts_1$'Vehicle Sales'[1:12]
ts_info(veiculos_xts_2)
class(veiculos_xts_2)

veiculos_xts_3 <- veiculos_xts_1$'Vehicle Sales'["1976"]
ts_info(veiculos_xts_3)

veiculos_xts_4 <- veiculos_xts_1$'Vehicle Sales'["1976-01/06"]
ts_info(veiculos_xts_4)


# Merge de séries temporais
data(Michigan_CS)
data(EURO_Brent)

ts_info(Michigan_CS)
ts_info(EURO_Brent)

?merge.xts
xts_merge_outer <- merge.xts(Michigan_CS = Michigan_CS, 
                             EURO_Brent = EURO_Brent, 
                             join = "outer" )

ts_info(xts_merge_outer)
View(xts_merge_outer)
head(xts_merge_outer["1987"])




