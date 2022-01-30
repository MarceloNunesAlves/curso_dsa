# Representação de Datas no Formato Numérico e de String


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")


# Definindo duas datas
data1 <- as.Date("1970-01-01")
data2 <- Sys.Date()
data3 <- Sys.time()

# Convertendo as datas para o formato numérico (em dias)
class(data1)
as.numeric(data1)

# Objeto Date - número de dias desde 01/01/1970
class(data2)
as.numeric(data2)

# Objeto time - número de segundos desde 01/01/1970
class(data3)
as.numeric(data3)


# Armazenando time como string
time_str <- "2018-12-31 20:59:59"
class(time_str)

# Convertendo a string para objeto time POSIXct 
time_posix_ct1 <- as.POSIXct(time_str)
class(time_posix_ct1)

# Aqui os 2 objetos
time_str
time_posix_ct1

# Testando se os dois objetos são iguais
identical(time_str, time_posix_ct1)

# Armazenando uma representação numérica do objeto time
time_numeric <- 1546318799
class(time_numeric)

# Convertendo o objeto time numérico em um objeto POSIXct
time_posix_ct2  <- as.POSIXct(time_numeric, origin = "1970-01-01")

# Visualizando os dois objetos
print(c(time_posix_ct1, time_posix_ct2))

# Testando se os dois objetos são iguais
identical(time_posix_ct1, time_posix_ct2)

# Armazenando o objeto time como uma string
time_US_str <- "Monday, December 31, 2018 08:59:59 PM"
class(time_US_str)

# Converte o time no formato POSIXct
time_posix_ct3 <- as.POSIXct(time_US_str, format = "%A, %B %d, %Y %I:%M:%S %p")
time_posix_ct3

# Testando se os dois objetos são iguais
identical(time_posix_ct1, time_posix_ct2, time_posix_ct3)


