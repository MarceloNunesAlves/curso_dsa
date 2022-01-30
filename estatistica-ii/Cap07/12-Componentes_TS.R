# Componentes de Séries Temporais

# As séries possuem dois tipos principais de componentes:

# Estruturais (ciclo, sazonalidade e tendência)
# Não Estruturais (qualquer tipo de padrão irregular não associado aos componentes estruturais)

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")

# Pacotes
library(TSstudio)
library(zoo)
library(dplyr)

##### Ciclo #####

# A definição do ciclo em uma série temporal é derivada da ampla definição de ciclo em macroeconomia. 
# Um ciclo pode ser descrito como uma sequência de eventos repetíveis ao longo do tempo, onde o 
# ponto inicial de um ciclo está no mínimo local da série e o ponto final no próximo mínimo local.
# E o ponto final de um ciclo é o ponto inicial do ciclo seguinte.

# Além disso, diferentemente do padrão sazonal, os ciclos não ocorrem necessariamente em intervalos 
# de tempo igualmente espaçados e sua duração pode mudar de ciclo para ciclo.

# Carregando os dados
data(USUnRate)
ts_info(USUnRate)

# Extraindo uma janela dos dados
?stats::window
desemprego <- window(USUnRate, start = c(1992,3))
ts_info(desemprego)

# Plot
ts_plot(desemprego,
        title = "Taxa Mensal de Desemprego",
        Ytitle = "Taxa de Desemprego (%)",
        Xtitle = "Ano",
        Xgrid = TRUE,
        Ygrid = TRUE)


##### Tendência #####

# Uma tendência, se existir nos dados da série temporal, representa a direção geral da série, 
# para cima ou para baixo, ao longo do tempo. Além disso, uma tendência pode ter um crescimento 
# linear ou exponencial (ou próximo a um), dependendo das características da série. 

# Usaremos dados simulados para demonstrar diferentes tipos de tendências, antes de começar a 
# trabalhar com dados da vida real.

# Gerando dados aleatórios para uma série temporal sem tendência
set.seed(1234)
ts_sem_tendenca <- ts(runif(200, 5,5.2), start = c(2000,1), frequency = 12)

# Série com tendência linear positiva
ts_tend_linear_positiva <- ts_sem_tendenca + 1:length(ts_sem_tendenca) / (0.5 * length(ts_sem_tendenca))

# Série com tendência linear negativa
ts_tend_linear_negativa <- ts_sem_tendenca - 1:length(ts_sem_tendenca) / (0.5 * length(ts_sem_tendenca))

# Série com tendência exponencial
ts_trend_exponencial <- ts_sem_tendenca + exp((1:length(ts_sem_tendenca) -1 ) / (0.5 * length(ts_sem_tendenca))) - 1

# Merge das séries
library(xts)
serie_final <- merge(TS_Sem_Tendencia = as.xts(ts_sem_tendenca),
                     TS_Tendencia_Linear_Positiva = as.xts(ts_tend_linear_positiva),
                     TS_Tendencia_Linear_Negativa = as.xts(ts_tend_linear_negativa),
                     TS_Tendencia_Exponencial = as.xts(ts_trend_exponencial))

# Plot
ts_plot(serie_final,
        type = "single",
        Xgrid = TRUE,
        Ygrid = TRUE,
        title = "Tendências",
        Ytitle = "Valor",
        Xtitle = "Ano")


##### Sazonalidade #####

# O componente sazonal (ou sazonalidade) é outro padrão comum nos dados de séries temporais. 
# Se existir, representa uma variação repetida na série, que está relacionada às unidades de 
# frequência da série (por exemplo, os meses do ano para uma série mensal). Um dos exemplos comuns 
# de séries com forte padrão de sazonalidade é a demanda por eletricidade ou gás natural. Nesses 
# casos, o padrão sazonal é derivado de uma variedade de eventos sazonais, como padrões climáticos, 
# estação do ano e horas de luz solar.

# Além disso, uma série pode ter mais de um padrão sazonal. Um exemplo clássico disso é a demanda 
# de eletricidade, que poderia ter três padrões diferentes de sazonalidade: horário, semanal e mensal.

# Gerando dados aleatórios para uma série temporal sem tendência
set.seed(1234)
ts_sem_tendenca <- ts(runif(200, 5,5.2), start = c(2003,1), frequency = 12)

# Definindo um padrão sazonal
padrao_sazonal <- sin(1.8 * pi * (1:length(ts_sem_tendenca)) / frequency(ts_sem_tendenca))

# Criando a série temporal com sazonalidade
ts_sazonal <- ts_sem_tendenca + padrao_sazonal

# Plot
ts_plot(ts_sazonal,
        title = "Padrão Sazonal Sem Tendência",
        Xgrid = TRUE,
        Ygrid = TRUE,
        Ytitle = "Valor",
        Xtitle = "Ano")

# Adicionando sazonalidade às séries com tendências
Sazonal_Tendencia_Positiva <- ts_tend_linear_positiva + padrao_sazonal
Sazonal_Tendencia_Negativa <- ts_tend_linear_negativa - padrao_sazonal
Sazonal_Tendencia_Exponencial <- ts_trend_exponencial + padrao_sazonal

# Merge
serie_final_sazonal <- merge(TS_Sazonal_Tendencia_Positiva = as.xts(Sazonal_Tendencia_Positiva),
                             TS_Sazonal_Tendencia_Negativa = as.xts(Sazonal_Tendencia_Negativa),
                             TS_Sazonal_Tendencia_Exponencial = as.xts(Sazonal_Tendencia_Exponencial))


ts_plot(serie_final_sazonal,
        type = "single",
        Xgrid = TRUE,
        Ygrid = TRUE,
        title = "Padrão Sazonal Com Tendência",
        Ytitle = "Valor",
        Xtitle = "Ano") 








