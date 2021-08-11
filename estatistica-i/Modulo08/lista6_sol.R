# Solução Lista 6 de Exercícios em R

##################### Exercício 1  ###############################

# Solução: A variável aleatória X pode assumir o conjunto de valores x = {40, 60, 75, 100, 120}. 
# A função de densidade de probabilidade para a variável aleatória X é P (X = x | n = 5) = 1/5 para x = 40, 60, 75, 100, 120.

lampadas <- c(40, 60, 75, 100, 120)
n <- length(lampadas)
mediaWattsLampadas <- (1/n) * sum(lampadas)
varWattsLampadas <- (1/n) * sum((lampadas - mediaWattsLampadas) ^ 2)
medidas <- c(mediaWattsLampadas, varWattsLampadas)
medidas

# O valor esperado de X é E [X] = 79 e a variância de X é Var [X] = 804.

 
##################### Exercício 2  ###############################

# Existem várias abordagens para resolver o problema com R. 
# Deve-se perceber que as seguintes declarações são todas equivalentes: 
# P (X >= 6) = P (X = 6) + P (X = 7) + P (X = 8) + P (X = 9) + P (X = 10)
# P (X >= 6) = 1 - P (X <= 5) 
# P (X >= 6) = 1 - [P (X = 5) + P (X = 4) + ··· + P (X = 0)]

# Para encontrar P (X >= 6) com R, calcule as probabilidades individuais com dbinom (6:10, 10, 0,33) 
# e, em seguida, some-as com o comando sum(). 
# Outra solução é encontrar 1 - P (X <= 5), que é realizado com 1 - pbinom(5, 10, 0,33) ou 1 - sum(dbinom (5: 0, 10, 0,33)).
?dbinom
sum(dbinom(6:10, 10, 0.33))          # P(X >= 6)
1 - pbinom(5, 10, 0.33)              # 1 - P(X <= 5)
pbinom(5, 10, 0.33, lower = FALSE)   # P(X >= 6)
1 - sum(dbinom(5:0, 10, 0.33))       # 1 - P(X <= 5)
 

##################### Exercício 3  ###############################
?ppois

# Qual é a probabilidade de haver mais de sete acidentes nesta oficina durante o mês de maio?
ppois(q = 7, lambda = 4, lower = FALSE)    # P(X > 7|4)
1 - ppois(q = 7, lambda = 4)               # P(X > 7|4)

# Qual é a probabilidade de não mais do que três acidentes ocorrerem durante os meses de maio e junho?
ppois(q = 3, lambda = 8)                   # P(X <= 3|8)


##################### Exercício 4  ###############################

# Item a - haverá zero chamadas durante um período de um minuto.
dpois(x = 0, lambda = 2)

# Item b - haverá menos de cinco chamadas em um período de um minuto.
ppois(q = 4, lambda = 2)

# Item c - haverá menos de seis chamadas em uma hora.
# Observe que o período de tempo muda de um minuto a uma hora (60 minutos). 
# Consequentemente, o número médio de chamadas em uma hora é lambda = 2 * 60 = 120.
ppois(q = 5, lambda = 120)


##################### Exercício 5  ###############################

# Solução: Deixe a variável aleatória X representar o número de pneus com defeito 
# examinados antes de obter quatro pneus com defeitos.
# Em outras palavras, X ~ NB (4, 0,90) e segue-se que:
dnbinom(2, 4, 0.9)  # P(X = 2 | 4, 0.9)










