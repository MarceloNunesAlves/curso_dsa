# Estimativa Não Paramétrica Para ANOVA

# O teste de Mann-Whitney-Wilcoxon que apresentamos anteriormente, pode ser estendido a 
# vários grupos (e não apenas 2). 

# Para Análise de Variância unidirecional (ANOVA), o teste usado é chamado Kruskal-Wallis; 
# Temos a função kruskal.test() em R. 

# Para ANOVA bidirecional não paramétrica, o teste Scheirer-Ray-Hare pode ser usado; 
# no entanto, a documentação é escassa e não é usada com frequência.

# Pacotes
# Windows precisa do RTools, Mac precisa do Xcode, Linux precisa do gcc
install.packages("devtools")
install.packages("FSA")
library(FSA) 

# Este conjunto de dados contém medidas de peso de animais, o que depende do tipo de alimento 
# que eles receberam e o lote (categoria) dos animais.

# Como Kruskal-Wallis aceita apenas ANOVA unidirecional, podemos usar apenas uma das variáveis. 
# Precisamos desconsiderar a variável categoria e modelar apenas o tipo de alimento. 

# H0 - Todos os tipos de alimento produzem o mesmo peso.
# H1 - Todos os tipos de alimento não produzem o mesmo peso.

# Carregando os dados
dataset2 = read.csv("dados/pesos_animais.csv") 
View(dataset2)
str(dataset2)

# Teste
?kruskal.test
kruskal.test(Peso ~ Tipo_Alimento, data = dataset2)

# Como podemos ver, rejeitamos a hipótese nula de que todos os tipos de alimentos 
# produzem o mesmo peso.


# Dunn's Test

# Depois que sua ANOVA inicial encontrar uma diferença significativa em três ou mais médias, 
# o Teste de Dunn poderá ser usado para identificar quais médias específicas são significativas 
# em relação às outras. 

# O teste de comparação múltipla de Dunn é um teste não paramétrico post hoc 
# (ou seja, é executado após uma ANOVA). É um teste "sem distribuição" que não pressupõe 
# que seus dados venham de uma distribuição específica. 

# É um dos testes de comparação múltipla menos poderosos e pode ser um teste muito 
# conservador, especialmente para um número maior de comparações. 

# Depois de rejeitarmos a hipótese nula, precisamos descobrir quais são as comparações 
# estatisticamente significativas. Esse é um problema de comparação múltipla e os valores-p 
# precisam ser ajustados. 

# Isso pode ser feito através do teste de Dunn. Como pode ser verificado abaixo, 
# todas as comparações são estatisticamente significativas e o A-C é realmente o maior. 
# A diferença mais relevante é A - C, conforme mostrado no código a seguir:

?dunnTest
dunnTest(Peso ~ Tipo_Alimento, data = dataset2) 





