# Padrões de Sazonalidade

# Existe um padrão sazonal em uma série temporal sempre que podemos vincular um evento 
# repetido da série a uma unidade de frequência específica, por exemplo, a temperatura 
# média no Rio de Janeiro durante o mês de Março ou o número médio de passageiros no metrô 
# de São Paulo entre 8h e 9h. 

# Portanto, existe uma forte relação entre o padrão sazonal e a frequência da série.

# Quando a sazonalidade existe nos dados da série temporal, podemos classificá-la em uma 
# das seguintes categorias: 

# Padrão sazonal único: sempre que houver apenas um padrão sazonal dominante na série.
# Padrão sazonal múltiplo: se houver mais de um padrão sazonal dominante na série.

# Normalmente, é mais provável que vários padrões sazonais ocorram sempre que a série 
# tiver uma frequência alta (por exemplo, diariamente, a cada hora, meia hora e assim 
# por diante), pois há mais opções para agregar a série a uma frequência mais baixa. 

# Um exemplo típico de sazonalidade múltipla é a demanda horária de eletricidade, que pode 
# ter vários padrões sazonais, pois a demanda é derivada da hora do dia, do dia da semana 
# ou dos padrões anuais, como clima ou quantidade de luz do dia durante todo o dia. 

# Por outro lado, quando a frequência da série é mais baixa (por exemplo, mensalmente, 
# trimestralmente, etc.), é mais provável que tenha apenas um padrão sazonal dominante em 
# oposição a uma série de alta frequência, pois há menos opções de agregação para outro 
# tipo de frequências. 

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap08")

# Pacotes
install.packages("UKgrid")
library(TSstudio)
library(UKgrid)
library(zoo)


# Carregando o conjunto de dados (Padrão sazonal único)
?USgas
data(USgas)

# Informações sobre a série 
ts_info(USgas)

# Plot da série
ts_plot(USgas, 
        title = "Consumo Mensal de Gás Natural nos EUA", 
        Ytitle = "Consumo",
        Xgrid = TRUE,
        Ygrid = TRUE) 


# Carregando o conjunto de dados (Padrão sazonal múltiplo)
?UKgrid
?extract_grid
UKgrid_ts <- extract_grid(type = "xts", columns = "ND", aggregate = "hourly", na.rm = TRUE)

# Informações sobre a série
ts_info(UKgrid_ts)

# Plot da série
ts_plot(UKgrid_ts, 
        title = "Demanda Nacional Por Eletricidade Por Hora", 
        Ytitle = "Megawatts",
        Xgrid = TRUE,
        Ygrid = TRUE) 

