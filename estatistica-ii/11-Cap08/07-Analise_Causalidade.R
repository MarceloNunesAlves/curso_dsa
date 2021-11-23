# Análise de Causalidade em Séries Temporais 

# O uso das defasagens (lags) da série para prever o valor futuro da série é benéfico sempre que a série apresenta 
# padrões repetidos estáveis ao longo do tempo. Um excelente exemplo desse tipo de série é o consumo de gás 
# natural dos EUA, pois possui um forte padrão sazonal e um padrão consistente de tendência (ou crescimento). 

# No entanto, a principal armadilha desse método é que ele falhará sempre que as alterações nas séries derivarem 
# de fatores exógenos. Nesses casos, o uso apenas de atrasos (lags) passados pode levar a resultados enganosos, pois os 
# atrasos não necessariamente conduzem às mudanças na série. O objetivo da análise de causalidade, no contexto 
# da análise de séries temporais, é identificar se existe uma relação de causalidade entre a série que desejamos 
# prever e outros fatores exógenos em potencial. O uso desses fatores externos como direcionadores do modelo de 
# previsão (sempre que existir) poderia fornecer previsões precisas e robustas (em vez de usar apenas a observação 
# anterior da série). 

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap08")

# A função de correlação cruzada (CCF) é a função irmã da ACF e mede o nível de correlação entre duas séries 
# e suas defasagens de maneira bastante semelhante. No exemplo a seguir, analisaremos a relação entre as vendas 
# totais de veículos (USVSales) e a taxa de desemprego (USUnRate) nos EUA para entender se há uma relação de 
# causa e efeito entre os dois. 

# Autocorrelação - correlação de uma série com sua defasagem
# Correlação cruzada - correlação entre duas séries diferentes

# Pacote
library(TSstudio)
library(plotly)

# Série 1
data(USUnRate)
ts_info(USUnRate)

# Plot da série
ts_plot(USUnRate,
        title = "Taxa Mensal de Desemprego nos EUA",
        Ytitle = "Taxa de Desemprego (%)",
        Xtitle = "Ano")

# Coletando uma janela da série entre 1976 e 2018
janela_serie1 <- window(USUnRate, start = c(1976,1), end = c(2018,6))

# Plot da janela da série
ts_plot(janela_serie1,
        title = "Taxa Mensal de Desemprego nos EUA",
        Ytitle = "Taxa de Desemprego (%)",
        Xtitle = "Ano")

# Série 2
data(USVSales)
ts_info(USVSales)

# Plot
ts_plot(USVSales,
        title = "Taxa Mensal de Venda de Veículos nos EUA",
        Ytitle = "Milhares de Unidades Vendidas",
        Xtitle = "Ano")

# Coletando uma janela da série entre 1976 e 2018
janela_serie2 <- window(USVSales, start = c(1976,1), end = c(2018,6))

# Plot da janela da série
ts_plot(janela_serie2,
        title = "Taxa Mensal de Venda de Veículos nos EUA",
        Ytitle = "Milhares de Unidades Vendidas",
        Xtitle = "Ano")

# Plot das duas janelas simultaneamente
plot_ly(x = time(janela_serie2), 
        y = janela_serie2, 
        type = "scatter", 
        mode = "line", 
        name = "Total de Vendas de Veículos") %>%
  add_lines(x = time(janela_serie1), 
            y = janela_serie1,
            name = "Taxa de Desemprego", 
            yaxis = "y2") %>%
  layout(
    title = "Total Mensal de Vendas de Veículos x Taxa de Desemprego nos EUA", 
    yaxis2 =  list(
      overlaying = "y",
      side = "right",
      title = "Percentual",
      showgrid = FALSE
    ),
    yaxis = list(title = "Milhares de Unidades", showgrid = FALSE),
    legend = list(orientation = 'h'),
    margin = list(l = 50, r = 50, b = 50, t = 50, pad = 2)
  )


# Correlação Cruzada
?ccf
ccf(x = janela_serie2, y = janela_serie1, lag.max = 36)

library(forecast)
?ggCcf
ggCcf(janela_serie2, janela_serie1, lag.max = 36)

# Da mesma forma que a saída ACF, cada barra no gráfico CCF representa o nível de correlação entre as séries 
# principais e os atrasos da outra série. O atraso 0 representa a correlação direta entre as duas séries, onde 
# as defasagens negativas e positivas representam a correlação entre a taxa de desemprego e as defasagens 
# anteriores e posteriores da série de vendas de veículos, respectivamente. 

# O principal aspecto a ser observado no gráfico é que a taxa de desemprego está mais correlacionada com os 
# atrasos anteriores, em oposição aos atrasos posteriores nas vendas de veículos. A correlação mais alta entre as 
# duas séries foi observada com o lag -5 das vendas de veículos e também não estava muito longe do lag sazonal 
# (ou seja, lag 12). 

# É difícil (e provavelmente até errado) concluir a partir dos resultados que as vendas de veículos conduzem 
# explicitamente as mudanças na taxa de desemprego. No entanto, há alguma indicação de uma relação de causalidade, 
# que pode ser derivada do nível de correlação e do bom senso, dado o tamanho da indústria de veículos nos EUA 
# e seu impacto histórico na economia. Como alternativa, você pode traçar o relacionamento entre as vendas de 
# veículos nos EUA e os lags da taxa de desemprego com a função ccf_plot do pacote TSstudio. Esta função funciona 
# de maneira semelhante à função ts_lags:

?ccf_plot
ccf_plot(x = janela_serie2, y = janela_serie1, lags = 0:12)




