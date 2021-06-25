# Estudo de Caso 1 - Análise de Dados em Operadoras de Cartão de Crédito 

# Define pasta de trabalho
setwd("~/git/curso_dsa/estatistica-i/Modulo03/Exercicio")

# Instala e carrega os pacotes
install.packages("mlbench")
install.packages("caret")
install.packages("e1071")
library(mlbench) 
library(caret)
library(e1071)

# Carrega o dataset
mydata <- read.csv("dataset.csv") 
View(mydata)

# Quais as 3 cores dos veículos mais vendidos?
agg <- aggregate(mydata$cor, by=list(Category=mydata$cor), FUN=length)
agg <- head(agg[order(agg$x, decreasing = TRUE), ], n=3)
agg

# De qual ano são os veículos mais vendidos?
agg3 <- aggregate(mydata$ano, by=list(Category=mydata$ano), FUN=length)
agg3 <- agg3[order(agg3$x, decreasing = TRUE), ]
agg3

# Crie um barplot para apresentar sua resposta no item 2.
barplot(height=agg$x, names=agg$Category)

# Qual o percentual de vendas de veículos com transmissão automática?
agg4 <- aggregate(mydata$transmissao, by=list(Category=mydata$transmissao), FUN=length)
auto <- agg4[agg4$Category=='AUTO',]$x
total <- sum(agg4$x)
perc <- auto*100/total
perc

# Crie um Pie Chart para representar sua resposta no item 4.
ggplot(agg4, aes(x="", y=agg4$x, fill=agg4$Category)) +
  geom_bar(stat="identity", width=1) +
  coord_polar("y", start=0)

# Qual o percentual de venda de veículos por modelo?
agg5 <- aggregate(mydata$modelo, by=list(Category=mydata$modelo), FUN=length)
total <- sum(agg5$x)
agg5['perc'] <-  agg5$x * 100 / total
agg5

# Calcule o percentual de vendas por preço de veículo e o percentual acumulado.
agg6 <- aggregate(mydata$preco, by=list(Category=mydata$preco), FUN=length)
total <- sum(agg6$x)
agg6['perc'] <-  agg6$x * 100 / total
agg6

# Liste o total de veículos vendidos por ano e por tipo de transmissão
agg7 <- aggregate(mydata$transmissao, by=list(Category=mydata$transmissao,mydata$ano), FUN=length)
agg7 <- agg7[order(agg7$x, decreasing = TRUE), ]
agg7

summary(agg7)
