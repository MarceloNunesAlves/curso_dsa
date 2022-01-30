# Análise Estatística Para Data Science II

# Mini-Projeto 7

# Market Basket Analysis Para Recomendações de Compras aos Clientes

# Leia a definição do projeto com a fonte de dados no Capítulo 13 do curso.

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap13")

# Pacotes
library(dplyr)
library(arules)

# Carregando os dados
products <- read.csv('dados/products.csv')
order_products_train <- read.csv('dados/order_products__train.csv')

# Prepara os dados - Gerando Transações
tabela_compras <- order_products_train %>% 
  group_by(product_id) %>% 
  left_join(products, by = "product_id")

dim(tabela_compras)
View(tabela_compras)

# Gera o arquivo de transações (usuários - pedidos)
write.csv(tabela_compras, file = "dados/transactions.csv")

# Carrega o arquivo no formato de transações
?read.transactions
transacoes <- read.transactions("dados/transactions.csv", 
                                format = "single", 
                                sep = ",",
                                cols = c(2,6))

dim(transacoes)
summary(transacoes)
inspect(transacoes[1:3])

# Cria as regras de associação
?apriori
regras <- apriori(transacoes, parameter = list(support = 0.001, confidence = 0.25))
summary(regras)
inspect(regras[1:10])

# Fim





