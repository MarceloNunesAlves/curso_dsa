# Análise de Sazonalidade - Distribuição das Unidades de Frequência

# Outra abordagem para analisar padrões sazonais em dados de séries temporais é plotando a 
# distribuição das unidades de frequência usando histograma ou gráficos de densidade. 

# Isso nos permitirá examinar se cada unidade de frequência possui uma distribuição exclusiva que 
# pode distingui-la do resto das unidades. Usaremos o pacote ggplot2 para plotar o gráfico de densidade 
# de cada unidade de frequência usando o objeto geométrico geom_density (geom). Esse geom aplica 
# o método de estimativa de densidade do kernel para suavizar o gráfico do histograma. 

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap08")

# Pacotes
library(TSstudio)
library(dplyr)
library(zoo)
library(xts)
library(UKgrid)
library(lubridate)
library(ggplot2)

# Carregando a série temporal e convertendo para dataframe
data(USgas)
?USgas
ts_info(USgas)
df_USgas <- data.frame(Ano = floor(time(USgas)),  
                       Mes = cycle(USgas), 
                       Consumo = as.numeric(USgas))

# Ajustando o mês para o tipo fator
df_USgas$Mes <- factor(month.abb[df_USgas$Mes], levels = month.abb)
View(df_USgas)

# Plot
ggplot(df_USgas, aes(x = Consumo)) + 
  geom_density(aes(fill = Mes)) + 
  ggtitle("Estimativa de Densidade Por Mês") +
  ylab('Densidade') +
  facet_grid(rows = vars(as.factor(Mes)))


# Este gráfico acima é um excelente exemplo do uso de ferramentas de visualização de dados para contar 
# histórias (storytelling). 

# A forma do gráfico de densidade de cada mês nos fornece informações sobre as características de cada 
# mês (ou unidade de frequência). Podemos ver alguma indicação de um padrão sazonal na série, pois os 
# gráficos de densidade não se sobrepõem (com exceção de alguns meses consecutivos, como maio e junho). 
# Além disso, podemos ver que, por alguns meses, o formato das distribuições é mais plano com caudas longas 
# (principalmente durante os meses de inverno - novembro, dezembro e janeiro). Isso pode ser resultado da 
# volatilidade de alguns fatores; por exemplo, uma combinação de padrões climáticos juntamente com a 
# elasticidade ou sensibilidade da série para mudanças no clima. No caso do consumo de gás natural, há uma 
# maior elasticidade durante os meses de inverno devido à dependência dos sistemas de aquecimento desse 
# recurso, que não existe durante o verão.

# No entanto, não se esqueça do efeito da tendência ou do crescimento de ano para ano 
# (a série USgas teve uma tendência linear desde o ano de 2010), pois não a removemos da série. 
# Vamos repetir esse processo; desta vez, vamos decompor a série USgas antes de plotá-la. 
# Aplicaremos um método simples para decompor a série usando a função decompose() para calcular a 
# tendência da série e então subtraí-la da série.
  
# Decompondo a série e extraindo a tendência
?decompose
decompose(USgas)$trend
df_USgas$Consumo_detrend <- as.numeric(df_USgas$Consumo - decompose(USgas)$trend)
class(df_USgas)
View(df_USgas)

# Plot
ggplot(df_USgas, aes(x = Consumo_detrend)) + 
  geom_density(aes(fill = Mes)) + 
  ggtitle("Estimativa de Densidade Por Mês") +
  facet_grid(rows = vars(as.factor(Mes)))


# Ferramentas de Visualização de Padrões Sazonais

# TSstudio
library(TSstudio)

?ts_seasonal
?ts_heatmap

ts_seasonal(USgas, type = "normal")
ts_seasonal(USgas, type = "cycle")
ts_seasonal(USgas, type = "box")
ts_seasonal(USgas, type = "all")
ts_heatmap(USgas, color = "Reds")

# Carregando o conjunto de dados (Padrão sazonal múltiplo)
?UKgrid
?extract_grid
UKgrid_ts <- extract_grid(type = "xts", columns = "ND", aggregate = "hourly", na.rm = TRUE)

# Informações sobre a série
ts_info(UKgrid_ts)

# Plots
?ts_quantile

ts_quantile(UKgrid_ts)
ts_quantile(UKgrid_ts, period = "weekdays", n = 2)
ts_quantile(UKgrid_ts, period = "monthly", n = 2)


# Forecast
library(forecast)

?ggseasonplot

ggseasonplot(USgas, year.labels = TRUE, continuous = TRUE)
ggseasonplot(USgas, polar = TRUE)





