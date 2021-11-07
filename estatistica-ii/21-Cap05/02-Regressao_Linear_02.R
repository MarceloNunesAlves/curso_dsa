# Gerando Relatório do Modelo de Regressão Para Apresentação e Interpretação

# Definindo o diretório de trabalho
# setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap05")
# getwd()

# Pacotes para geração de relatórios em formato HTML
library(sjPlot) 

# Carregando o dataset
vendas <- read.csv("dados/vendas.csv") 
View(vendas)

# Visualizando o dataset em formato HTML
?tab_df
tab_df(vendas, title = "Dataset de Vendas", alternate.rows = TRUE) 

# Criando um modelo de regressão
modelo_reg <- lm(Valor_Venda ~ Estrategia + Cliente + Vendedor, data = vendas) 

# Interpretando o resultado com summary
summary(modelo_reg)

# Interpretando o resultado com relatório HTML
?tab_model
tab_model(modelo_reg) 


