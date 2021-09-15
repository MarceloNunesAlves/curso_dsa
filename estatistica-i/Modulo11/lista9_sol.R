# Solução Lista 9 de Exercícios em R

# Instala e carrega o pacote Rmisc
install.packages("Rmisc")
library(Rmisc)

# Carrega o dataset
dados <- iris
View(dados)


# Exercício 1 - Calcule a média da coluna Sepal.Length.
media_coluna <- mean(dados$Sepal.Length)
media_coluna


# Exercício 2 - Usando a função CI() calcule o intervalo de confiança de 95%.
CI(dados$Sepal.Length, ci = 0.95)


# Exercício 3 - O intervalo de confiança calculado no Exercício 2 é amostral ou populacional? 
# Por quê? Como interpretamos o resultado do Exercício 2?

# Intervalo populacional, pois usamos todos os dados sobre o fenômeno.
# Observamos que o intervalo de confiança de 95% está entre 5,709732 e 5,976934.
# A interpretação de maneira intuitiva nos diz que temos 95% de certeza de que a média da 
# população cai no intervalo entre os valores mencionados acima.


# Exercício 4 - A partir do dataset original, utilize a função sample() e gere uma amostra 
# aleatória de 15 registros. Esta será nossa Amostra 1.

# Nosso conjunto de dados tem 150 observações (população), então vamos tirar 15 observações 
# aleatórias (amostra pequena). Esta pequena amostra representará 10% de todo o conjunto de dados.

# Para fazer isso, precisamos encontrar números aleatórios de 15 linhas e criar um subconjunto 
# como índice. Usando a função sample() em R, criamos um conjunto aleatório de 15 números.
set.seed(142)
index_s <- sample(1:nrow(dados), 15)

# Usamos o índice para extrair linhas do datasets original
amostra_pequena <- dados[index_s, ]
View(amostra_pequena)


# Exercício 5 - Usando a função CI() calcule o intervalo de confiança de 95% da amostra gerada 
# no Exercício 4. Como interpretamos o resultado?
CI(amostra_pequena$Sepal.Length, ci = 0.95)

# Nota: Como estamos trabalhando com amostras aleatórias, seus resultados podem ser ligeiramente 
# diferentes.

# Observamos que a média da amostra é menor que a média da população, com uma diferença bastante 
# significativa e que o intervalo de confiança agora é mais largo.


# Exercício 6 - Crie uma amostra de 120 registros a partir do dataset original. Esta será nossa 
# Amostra 2.
index_l <- sample(1:nrow(dados), 120)

# Usamos o índice para extrair linhas do datasets original
amostra_grande <- dados[index_l, ]
View(amostra_grande)


# Exercício 7 - Usando a função CI() calcule o intervalo de confiança de 95% da amostra gerada 
# no Exercício 6. 
CI(amostra_grande$Sepal.Length, ci = 0.95)


# Exercício 8 - Comparando as médias e os intervalos de confiança das amostras com 1 e 2, 
# quais são as suas conclusões?

# A amostra maior oferece um intervalo de confiança mais estreito, pois há maior probabilidade 
# da média amostral ser a média populacional.

# As principais conclusões a serem consideradas dos exemplos acima são que estatísticas da 
# amostra grande estão mais próximas dos parâmetros populacionais do que estatísticas da 
# amostra pequena.

# Assim, quanto maior a amostra, menor o intervalo de confiança. 

# Intuitivamente, quanto mais observações tivermos, melhores serão nossas estimativas.


