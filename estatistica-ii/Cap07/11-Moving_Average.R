# Moving Average Function

# Conforme vimos até aqui, a Moving Average Function tem como objetivo suavizar a série temporal.
# Usamos a suavização para remover ruído da série, decompor a série e fazer previsões.

# A Moving Average Function tem dois componentes:

# Rolling Window
# Moving Average

############ Para a Rolling Window, temos 2 tipos: ############ 

# One-sided
# Two-sided

# Considere uma série com valores A, B, C, D, E

# Rolling Window de comprimento 3

# One-sided:

# Exemplo: Primeira passada da rolling window => A, B, C
# Exemplo: Segunda passada da rolling window => B, C, D 
# Exemplo: Terceira passada da rolling window => C, D, E

# Two-sided:

# Exemplo: Primeira passada da rolling window => -, A, B (A+1) 
# Exemplo: Segunda passada da rolling window => A (B-1), B, C (B+1)
# Exemplo: Terceira passada da rolling window => B (C-1), C, D (C+1)
# Exemplo: Quarta passada da rolling window => C (D-1), D, -

############ Para a Moving Average, temos 2 tipos: ############ 

# Média Aritmética Simples (Simple Moving Average)
# Média Ponderada (onde damos um peso para as observações da série temporal)

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")

############ Simple Moving Average ############ 

# Pacotes
library(TSstudio)
library(zoo)

# Carregando os dados
data(USgas)
ts_info(USgas)
ts_plot(USgas)

data(USVSales)
ts_info(USVSales)
ts_plot(USVSales)

# Plot da série de forma mais detalhada
ts_plot(USVSales,
        title = "Total de Venda de Veículos Por Mês nos EUA",
        Ytitle = "Milhares de Unidades",
        Xtitle = "Anos",
        Xgrid = TRUE,
        Ygrid = TRUE)

# Simple Moving Average - One-sided
?ts_ma
ts_ma(USgas, n_left = 3, n = NULL)
ts_ma(USgas, n_left = 6, n = NULL)

# Simple Moving Average - Two-sided
ts_ma(USVSales, n_left = 6, n_right = 5, n = NULL)
ts_ma(USVSales, n_left = 6, n_right = 5, n = c(2,5), multiple = TRUE, margin = 0.04)

# Criando duas séries, one-side e two-side de ordem 12
one_sided_12 <- ts_ma(USVSales, n_left = 11, n = NULL, plot = FALSE)
two_sided_12 <- ts_ma(USVSales, n_left = 6, n_right = 5, n = NULL, plot = FALSE)

# Ajusta os dados para o plot
one_sided <- one_sided_12$unbalanced_ma_12
two_sided <- two_sided_12$unbalanced_ma_12

# Faz o merge das 3 séries por coluna usando cbind
ma_ts <- cbind(USVSales, one_sided, two_sided)

# Cria o plot
ts_plot(ma_ts,
        Xgrid = TRUE,
        Ygrid = TRUE,
        type = "single",
        title = "MA One-Sided vs. MA Two-Sided - Order 12")


