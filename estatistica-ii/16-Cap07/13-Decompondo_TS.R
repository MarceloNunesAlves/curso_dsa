# Decompondo a Série Temporal em Seus Componentes

# As séries possuem dois tipos principais de componentes:

# Estruturais (ciclo, sazonalidade e tendência)
# Não Estruturais (qualquer tipo de padrão irregular não associado aos componentes estruturais)

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")

# Pacotes
library(TSstudio)
library(zoo)


# Modelo de Decomposição Aditivo e Multiplicativo

# Modelos de Decomposição consistem em, como o próprio nome diz, decompor o modelo que descreve o
# comportamento da série temporal através de seus componentes:

# Valor da série temporal = padrão temporal + erro
# Valor da série temporal = f (Tendência, Sazonalidade, Ciclo, Ruído Aleatório) ou:

# Yt = f (Tt, St, Ct, It)

# Onde: 
# Yt é o valor da série temporal
# Tt é o componente Tendência no período t
# St é o componente de Sazonalidade no período t
# Ct é o componente Ciclo no período t
# It é o componente irregular, ou seja, de erro, Ruído Aleatório, ou padrão subjacente no período t

# O Modelo de Decomposição Aditivo considera que a série temporal é resultante da soma 
# dos componentes: Yt = Tt + St + It

# O Modelo de Decomposição Multiplicativo considera que a série temporal é resultante do 
# produto dos componentes: Yt = Tt x St x It

# Classificamos uma série como aditiva sempre que houver um crescimento na tendência 
# (em relação ao período anterior) ou se a amplitude do componente sazonal permanecer 
# aproximadamente a mesma ao longo do tempo. Por outro lado, classificamos uma série como 
# multiplicativa sempre que o crescimento da tendência ou a magnitude do componente sazonal 
# aumentar ou diminuir em alguma multiplicidade de período para período ao longo do tempo. 

# Exemplos:

# A série mensal de consumo de gás natural dos EUA é um exemplo de uma série aditiva. 
# Você pode perceber facilmente que a amplitude do componente sazonal permanece a mesma 
# (ou quase igual) ao longo do tempo:

# Plot de uma série aditiva
data(USgas)

ts_plot(USgas,
        title = "Consumo Mensal de Gas Natural",
        Ytitle = "Consumo",
        Xtitle = "Ano",
        Xgrid = TRUE,
        Ygrid = TRUE)


# Por outro lado, o famoso conjunto de dados AirPassengers, que descreve o total mensal de 
# passageiros de companhias aéreas internacionais entre os anos de 1949 e 1960, é um excelente 
# exemplo para séries multiplicativas. Durante esses anos, logo após a Segunda Guerra Mundial, 
# a melhoria na tecnologia da aviação contribuiu para o rápido crescimento no setor de aviação. 
# Como você pode ver nos dados, a amplitude do componente sazonal aumenta de ano para ano:

# Plot de uma série multiplicativa
data(AirPassengers)

ts_plot(AirPassengers,
        title = "Número de Passageiros Mensais de Companhias Aéreas Entre 1949-1960",
        Ytitle = "Milhares de Passageiros",
        Xtitle = "Ano",
        Xgrid = TRUE,
        Ygrid = TRUE)


# Transformação de Dados da Série Temporal - Log e Box-Cox

# A maioria dos modelos de previsão para séries temporais pressupõe que a variação das séries 
# de entrada permaneça constante ao longo do tempo. Essa suposição normalmente vale para uma 
# série com uma estrutura aditiva. No entanto, falha quando a série tem uma estrutura multiplicativa. 

# A abordagem típica para lidar com uma série com uma estrutura multiplicativa é aplicando uma 
# transformação de dados nas séries de entrada. As abordagens de transformação de dados mais comuns 
# para dados de séries temporais são transformação de log e transformação Box-Cox.

# Para a fórmula da transformação Box-Cox, acesse:
# https://en.wikipedia.org/wiki/Power_transform

# Pacote
install.packages("forecast")
library(forecast)

# Dados
data(AirPassengers)
ts_info(AirPassengers)

# Extrai o valor de lambda
# O valor de lambda minimiza o coeficiente de variação da série 
? BoxCox.lambda
ts_AirPassenger_lamda <- BoxCox.lambda(AirPassengers)
ts_AirPassenger_lamda

# Aplica a transformação BoxCox
?BoxCox
ts_AirPassenger_transform <- BoxCox(AirPassengers, lambda = ts_AirPassenger_lamda)
ts_info(ts_AirPassenger_transform)

# Plot
ts_plot(ts_AirPassenger_transform,
        title = "Número de Passageiros Mensais de Companhias Aéreas Entre 1949-1960 Com Transformação Box-Cox",
        Ytitle = "Milhares de Passageiros - Normalizado",
        Xtitle = "Ano",
        Xgrid = TRUE,
        Ygrid = TRUE)


# Decomposição da Série com Moving Average Function
# Decomposição Clássica

# Carregando os dados
data(USVSales)
ts_info(USVSales)
ts.plot(USVSales)

# Decompondo a série temporal
?decompose
ts_decomposed <- decompose(USVSales)

# Detalhes da TS decomposta
str(ts_decomposed)
class(ts_decomposed)

# Plot
plot(ts_decomposed)


# Carregando outra série
data(AirPassengers)
ts_info(AirPassengers)
ts.plot(AirPassengers)

# Decompondo a TS
ts_air_decompose <- decompose(AirPassengers, type = "multiplicative")
plot(ts_air_decompose)





