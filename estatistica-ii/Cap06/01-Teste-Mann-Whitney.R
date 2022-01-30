# Teste Mann-Whitney

# O Teste de Mann-Whitney-Wilcoxon é um teste não paramétrico que testa se a 
# hipótese nula de qualquer elemento escolhido aleatoriamente no grupo A 
# tem a mesma probabilidade de ser maior ou menor que um item aleatório respectivo 
# do grupo B. 

# Uma maneira diferente de fazer esse teste é pensar nisso como um teste para 
# determinar se as distribuições dos grupos A e B são iguais. 

# A única suposição forte que esse teste exige é que as observações de ambos os 
# grupos sejam independentes.

# O teste não paramétrico não requer pressupostos distributivos e funciona bem quase 
# sempre. Obviamente, se ambas as distribuições são gaussianas com a mesma variância, 
# o teste t regular é melhor - isso deriva do fato de que o teste t é uniformemente 
# o mais poderoso.

# H0 - As distribuições são diferentes.
# H1 - As distribuições não são diferentes.

# Carregando os dados
dataset1 = read.csv("dados/alturas.csv") 
str(dataset1)
View(dataset1)

# Convertendo a variável preditora para o tipo fator
dataset1$Amostra = as.factor(dataset1$Amostra) 
str(dataset1)

# Executando o teste
?wilcox.test
wilcox.test(Altura ~ Amostra, data = dataset1) 

# Não rejeitamos a hipótese nula de que as distribuições são diferentes.

# Checando as distribuições
?subset

X_subset_1 <- subset(dataset1, select = Altura, subset = Amostra == 1, drop = TRUE)
View(X_subset_1)
str(X_subset_1)
hist(X_subset_1)

X_subset_2 <- subset(dataset1, select = Altura, subset = Amostra == 2, drop = TRUE)
View(X_subset_2)
str(X_subset_2)
hist(X_subset_2)

