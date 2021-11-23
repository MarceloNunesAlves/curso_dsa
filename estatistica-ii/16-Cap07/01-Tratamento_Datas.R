# Trabalhando com Manipulação de Datas e Tempo


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")


# A Classe Date em R representa a data no formato calendário ISO 8601
# Formato: yyyy-m-d

# A função Sys.Date() obtém a data atual do sistema
data_atual <- Sys.Date() 
data_atual
class(data_atual)

# As Classes POSIXct e POSIXlt em R representam a data no formato calendário ISO 8601
# Formato: yyyy-m-d HH:MM:SS

# A função Sys.time obtém a data e hora atuais do sistema
time_ct <- Sys.time() 
time_ct
class(time_ct)

# Convertendo o objeto POSIXct em POSIXlt
time_lt <- as.POSIXlt(time_ct)
time_lt
class(time_lt)

# A diferença entre POSIXct e POSIXlt está na forma como as datas são armazenadas no sistema.
unclass(time_ct)
unclass(time_lt)


# Criando objetos do tipo Date
data_1 <- as.Date("2019-6-14")
data_1
class(data_1)

# Criando objetos do tipo POSIXct e POSIXlt
time_ct <- as.POSIXct("2019-6-14 14:03:45", tz = "EST")
time_ct
class(time_ct)

time_lt <- as.POSIXlt("2019-6-14 14:03:45", tz = "EST")
time_lt
class(time_lt)
unclass(time_lt)
unclass(time_lt)$sec
unclass(time_lt)$hour


# Manipulando diferentes formatos de datas
dataframe_datas <- read.csv("dados/dataset1.csv", stringsAsFactors = FALSE)
View(dataframe_datas)
str(dataframe_datas)

# Formatando a data no formato brasileiro
dataframe_datas$Formato_Brasileiro_novo <- as.Date(dataframe_datas$Formato_Brasileiro)
View(dataframe_datas)
class(dataframe_datas$Formato_Brasileiro_novo)

# O pacote Lubridate nos ajuda com isso
install.packages("lubridate")
library(lubridate)

# A função dmy() ajuda datas em qualquer formato para o formato Date em R
?dmy
dataframe_datas$Formato_Brasileiro_novo <- dmy(dataframe_datas$Formato_Brasileiro)
View(dataframe_datas)
class(dataframe_datas$Formato_Brasileiro_novo)

dmy(11092018)
dmy("11092018")
dmy("11/09/2018")
dmy("11.09.2018")

# A função ymd_hms faz a mesma coisa para datas no formato de tempo
ymd_hms(20180911144923)
ymd_hms(20180911144923, tz = "America/Sao_Paulo")

# Outra alternativa para armazenar a data no formato brasileiro em R é usar o parâmetro format
as.Date("29-03-2019", format = "%d-%m-%Y")

# Formato US
?as.Date()
dataframe_datas$Formato_US[1]  
dataframe_datas$Formato_US_novo <- as.Date(dataframe_datas$Formato_US, format = "%m/%d/%Y") 
View(dataframe_datas)

# Formato US Longo
dataframe_datas$Formato_US_Longo[1] 
dataframe_datas$Formato_US_Longo_novo <- as.Date(dataframe_datas$Formato_US_Longo, 
                                                 format = "%A, %B %d, %Y")
View(dataframe_datas)

# Formato Brasileiro Longo
dataframe_datas$Formato_Brasileiro_Longo[1] 
dataframe_datas$Formato_Brasileiro_Longo_novo <- as.Date(dataframe_datas$Formato_Brasileiro_Longo, 
                                                         format = "%B %d, %Y, %A")
View(dataframe_datas)

# Precisamos ajustar o locale para o idioma pt_BR
Sys.getlocale()
Sys.setlocale("LC_ALL","pt_BR.UTF-8")
Sys.setenv(LANG = "pt_BR.UTF-8")
Sys.getlocale()

dataframe_datas$Formato_Brasileiro_Longo[1] 
dataframe_datas$Formato_Brasileiro_Longo_novo <- as.Date(dataframe_datas$Formato_Brasileiro_Longo, 
                                                         format = "%B %d, %Y, %A")
View(dataframe_datas)




