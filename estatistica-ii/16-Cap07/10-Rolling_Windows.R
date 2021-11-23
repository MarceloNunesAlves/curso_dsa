# Rolling Windows

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap07")

# Pacotes
library(TSstudio)
library(zoo)

# Carregando os dados
data(EURO_Brent)
?EURO_Brent

# Visualizando a série
ts_info(EURO_Brent)
View(EURO_Brent)
ts_plot(EURO_Brent)

# Rolling Window de comprimento 3
# Nesse caso, serão consideradas 3 séries: t-1, t, t+1

# Considere uma série com valores A, B, C e D
# Exemplo: Primeira passada da rolling window => -, A, B (A+1)
# Exemplo: Segunda passada da rolling window => A (B-1), B, C (B+1)
# Exemplo: Terceira passada da rolling window => B (C-1), C, D (C+1)
# Exemplo: Quarta passada da rolling window => C (D-1), D, -

?rollapply
media_preco_mensal <- rollapply(EURO_Brent, width = 3, FUN = mean)

View(media_preco_mensal)
class(media_preco_mensal)
ts_info(media_preco_mensal)

EURO_Brent_merge_mensal <- merge.zoo(EURO_Brent, media_preco_mensal)
View(EURO_Brent_merge_mensal)

# Lag (Defasagem)
?lag
?stats::lag

ts_info(EURO_Brent)
lag_mensal_3 <- lag(EURO_Brent, k = -3)
View(lag_mensal_3)
class(lag_mensal_3)
ts_info(lag_mensal_3)

# Merge
EURO_Brent_merge <- merge.zoo(EURO_Brent, lag_mensal_3)
View(EURO_Brent_merge)

lag_mensal_3 <- lag(EURO_Brent, k = 3)
ts_info(lag_mensal_3)
EURO_Brent_merge <- merge.zoo(EURO_Brent, lag_mensal_3)
View(EURO_Brent_merge)


