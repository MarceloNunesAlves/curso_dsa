library(MASS)

dados <- birthwt

dados_mae_fuma <- dados[dados$smoke==1,]
dados_mae_nao_fuma <- dados[dados$smoke==0,]

t.test(bwt ~ smoke, data = dados)

# Hipose nula é rejeitada, pois o p-value está abaixo do nivel de significancia (alfa=0,05) 