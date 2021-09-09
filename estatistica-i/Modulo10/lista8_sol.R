# Solução Lista 8 de Exercícios em R

# Variável x1
x1 <- 1:300


# Exercício 1 - Crie uma amostra aleatória de x1.
?sample
print(sample(x1))


# Exercício 2 - Crie uma amostra aleatória de x1 de tamanho 30.
print(sample(x1, size=30, replace=FALSE))  


# Exercício 3 - Crie uma amostra aleatória de x1 de tamanho 320 com substituição.
print(sample(c(x1), size=320, replace=TRUE))


# Exercício 4 - E se executarmos o exercício 3, mas sem substituição, o que acontece? Por quê?
print(sample(c(x1), size=320, replace=FALSE))


# Exercício 5 - A variável x2 é uma lista de 3 elementos. Crie uma amostra de tamanho 1000 sendo:
# 30% de probabilidade de ocorrência para o elemento 1
# 60% de probabilidade de ocorrência para o elemento 2
# 10% de probabilidade de ocorrência para o elemento 3
x2 <- 1:3
print(sample(x2, size=1000, replace=TRUE, prob=c(.30,.60,.10)))


# Exercício 6 - Crie um barplot representando graficamente o percentual de cada elemento criado na amostra do exercício 5.
barplot(table(sample(x2, size=1000, replace=TRUE, prob=c(.30,.60,.10))))


# Exercício 7 - Usando o dataset mtcars, crie uma amostra aleatória de 5 carros.
set.seed(123)
View(mtcars)
index <- sample(1:nrow(mtcars), 5)
index
mtcars[index,]


# Exercício 8 - Considere o dataset abaixo chamado dados. 
# Crie um gráfico que represente cada elemento da amostra. 
# Use o ggplot2.
install.packages("ggplot2")
library("ggplot2")
valores = c(rep("A",50), rep("B",35), rep("C",15))
valores
dados = as.data.frame(table(valores))
dados

grafico = ggplot(dados, aes(x=valores, y=Freq, fill=valores)) + 
  geom_bar(stat="identity") +
  geom_text(aes(label=Freq),vjust=1.6) +
  theme(legend.position = "none")

print(grafico)


# Exercício 9 - Crie uma amostra do dataframe dados criado no item anterior, 
# sendo que a probabilidade de cada um dos 3 elementos deve ser a frequência de cada elemento.
print(sample(dados$valores, replace = TRUE, prob = dados$Freq, 10))


# Exercício 10 - Considere o dataframe abaixo. 

# a) Crie uma função que gere uma amostra aleatória dos dados.
# b) Usando sample_frac() do pacote dplyr extraia uma amostra com 33% das linhas do dataframe
df = data.frame(matrix(rnorm(20), nrow=10))
df

# a)
randomRows = function(df,n){
  return(df[sample(nrow(df),n),])
}

randomRows(df)
randomRows(df, 5)

# b)
install.packages("dplyr")
library(dplyr)
df %>% sample_frac(0.33)
df %>% sample_frac(0.50)



