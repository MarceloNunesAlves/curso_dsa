# Análise de Correlação em Séries Temporais - Análise de Defasagens

# O objetivo da Análise de Defasagens é identificar e quantificar a relação entre uma série e suas 
# defasagens. Essa relação é normalmente medida calculando a correlação entre os dois e com o uso de 
# ferramentas de visualização de dados. 

# O nível de correlação entre uma série e seus atrasos é derivado das características da série. 
# Por exemplo, você deve esperar que a série tenha uma forte correlação com suas defasagens sazonais 
# (por exemplo, defasagens 12, 24 e 36 quando a frequência da série for mensal) quando a série tiver 
# fortes padrões sazonais. Isso deve fazer sentido, pois a direção da série é impactada por seu 
# padrão sazonal. Outro exemplo é o preço de uma ação ao longo do tempo, que, nesse caso, deve ser 
# correlacionado com os atrasos mais recentes. Nos exemplos a seguir, usaremos as séries USgas, 
# EURO_Brent e USVSales, cada uma com características diferentes para demonstrar o padrão de 
# correlação associado a cada tipo. 

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap08")

# Pacote
library(TSstudio)

# Carrega a série temporal
# Forte padrão sazonal
data("USgas")
?USgas
ts_plot(USgas)

# Carrega a série temporal
# Não tem padrão sazona ou tendência geral
data("EURO_Brent")
ts_plot(EURO_Brent)

# Carrega a série temporal
# Possui padrões sazonais e cíclicos
data("USVSales")
ts_plot(USVSales)


# Função de Autocorrelação

# Uma maneira de analisar os dados de séries temporais é plotar cada observação contra outra observação que 
# ocorreu algum tempo antes. Por exemplo, você pode plotar yt contra yt-1.

# Isso é chamado de gráfico de atraso (lag plot), porque você está plotando as séries temporais contra defasagens. 
# A função gglagplot() do pacote forecast produz vários tipos de gráficos de defasagem.

library(forecast)
?gglagplot
gglagplot(USgas)

# As correlações associadas aos gráficos de atraso formam o que é chamado de "função de autocorrelação". 
# A autocorrelação é quase a mesma que a correlação de Pearson. No entanto, a autocorrelação é a correlação de 
# uma série temporal com uma cópia atrasada de si mesma.

# A função de autocorrelação (ACF) é o principal método na análise de séries temporais para quantificar o nível 
# de correlação entre uma série e seus atrasos. Esse método é bastante semelhante (matematicamente e logicamente) 
# ao coeficiente de correlação de Pearson, conforme você leu nos manuais em pdf nos itens anteriores neste capítulo.

# Gera correlograma padrão com pacote stats
?acf
acf(USgas, lag.max = 60)

# Gera correlograma usando pacote forecast
library(forecast)
?ggAcf
ggAcf(USgas, lag.max = 60)

# Função customizada com ggplot e acf para o correlograma
library(ggplot2)
ggacf <- function(serie, lagmax) {
  significance_level <- qnorm((1 + 0.95)/2)/sqrt(sum(!is.na(serie)))  
  a <- acf(serie, plot = F, lag.max = lagmax)
  a.2 <- with(a, data.frame(lag, acf))
  g <- ggplot(a.2[-1,], aes(x = lag, y = acf)) + 
    geom_bar(stat = "identity", position = "identity") + xlab('Lag') + ylab('ACF') +
    geom_hline(yintercept = c(significance_level, -significance_level), lty = 3);
  
  # Ajusta a escala
  if (all(a.2$lag%%1 == 0)) {
    g <- g + scale_x_discrete(limits = seq(1, max(a.2$lag)));
  }
  return(g);
}

ggacf(USgas, 60)

# Usaremos o gráfico criado com a função ggAcf() do pacote forecast.

# No gráfico, o eixo vertical indica a autocorrelação e o horizontal a defasagem. 

# A linha tracejada azul indica onde é significativamente diferente de zero. Como é possível ver na imagem, 
# temos diversos valores ACF (barras verticais) acima do limite da linha tracejada azul. Nesses casos, a 
# autocorrelação é diferente de zero, indicando que a série não é aleatória – conforme o esperado.

# Algumas barras verticais estão dentro do limite das linhas tracejadas, Ou seja, a autocorrelação entre 
# a série com alguns de seus lags é igual a zero, indicando que não há correlação.

# Em termos simples: as linhas tracejadas apontam a significância. 
# Se ultrapassa é porque tem correlação.

# Cada barra no gráfico ACF representa o nível de correlação entre a série e seus atrasos em 
# ordem cronológica. Observe que a notação do eixo x é um pouco enganadora, pois as unidades 
# representam os atrasos sazonais (por exemplo, os atrasos 1 e 2 representam os atrasos de 12 e 24). 

# As linhas pontilhadas em azul indicam se o nível de correlação entre a série e cada atraso é 
# significativo ou não. 

# Testando a hipótese nula de que a correlação do atraso com a série é igual a zero, podemos rejeitá-la 
# sempre que o nível de correlação estiver acima ou abaixo das linhas pontilhadas superior e inferior, 
# respectivamente, com um nível de significância de 5%. 

# Caso contrário, sempre que a correlação estiver entre as linhas pontilhadas superior e inferior, 
# deixamos de rejeitar a hipótese nula e, portanto, podemos ignorar esses atrasos (ou assumir que 
# não há correlação significativa entre eles e a série). 

# Como você pode ver no gráfico ACF da série USgas, a série tem uma forte correlação positiva com os atrasos 
# sazonais (que decaem ao longo do tempo) juntamente com uma correlação negativa com os atrasos na meia-estação 
# (por exemplo, atrasos 6, 18, e 30). Isso não deve ser uma surpresa, pois esse comportamento está alinhado 
# com o forte padrão sazonal da série. 

# O correlograma também é utilizado (e talvez até com maior relevância) para analisar os resíduos de um modelo. 
# Quando você faz, por exemplo, uma projeção (forecast) do preço de uma ação, o correlograma do resíduo desse 
# modelo deve estar contido no tracejado azul. Ou seja, os resíduos não podem ter autocorrelação. Caso contrário, 
# sua projeção pode ser melhorada, pois alguma informação relevante no modelo está contida nos resíduos.

# Vamos agora traçar a correlação das séries EURO_Brent e USVSales e revisar como seu padrão de 
# correlação exclusivo se alinha às suas características:

ggAcf(EURO_Brent, lag.max = 60)

# No caso da série EURO_Brent, você pode ver que a correlação da série com seus atrasos está decaindo ao longo 
# do tempo. Quanto mais próximo o atraso, cronologicamente, da série, mais forte é a relação com a série.

ggAcf(USVSales, lag.max = 60)

# O padrão de correlação do USVSales tem uma forma única, resultado da combinação de padrões 
# sazonais e de ciclo da série. Da mesma forma que o USgas, o gráfico de correlação tem uma forma 
# cíclica como resultado do padrão sazonal da série. Por outro lado, a taxa de decaimento do USVSales 
# é mais rápida em comparação com a taxa de USgas devido ao padrão de ciclo da série, que muda a 
# direção da série ao longo do tempo. Como resultado, a série está principalmente correlacionada 
# com o primeiro atraso sazonal. Dito isto, se removermos o ciclo da série (com a decomposição), 
# provavelmente teremos um padrão de correlação semelhante ao USgas.




