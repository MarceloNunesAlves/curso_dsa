# Instala e carrega o pacote Rmisc
install.packages("Rmisc")
library(Rmisc)

# Carrega o dataset
dados <- iris
View(dados)

#Exercício 1 - Calcule a média da coluna Sepal.Length.
mean(dados$Sepal.Length)

#Exercício 2 - Usando a função CI() calcule o intervalo de confiança de 95%.
CI(dados$Sepal.Length, ci = 0.95)

#Exercício 3 - O intervalo de confiança calculado no Exercício 2 é amostral ou populacional? Por quê? Como interpretamos o resultado do Exercício 2?
# É a media da população com 95% de confiança

#Exercício 4 - A partir do dataset original, utilize a função sample() e gere uma amostra aleatória de 15 registros. Esta será nossa Amostra 1.
amostra_1 <- sample(dados$Sepal.Length, 15)

#Exercício 5 - Usando a função CI() calcule o intervalo de confiança de 95% da amostra gerada no Exercício 4. Como interpretamos o resultado?
CI(amostra_1, ci = 0.95)

#Exercício 6 - Crie uma amostra de 120 registros a partir do dataset original. Esta será nossa Amostra 2.
amostra_2 <- sample(dados$Sepal.Length, 120)

#Exercício 7 - Usando a função CI() calcule o intervalo de confiança de 95% da amostra gerada no Exercício 6.
CI(amostra_2, ci = 0.95)

#Exercício 8 - Comparando as médias e os intervalos de confiança das amostras com 1 e 2, quais são as suas conclusões?
#Com uma amostra de 120 registro se aproximou mais do intervalo de confiança com todos os dados.

#Extra - by Graxa
quantile(amostra_2, c(.025, .975))
quantile(dados$Sepal.Length, c(.025, .975))
