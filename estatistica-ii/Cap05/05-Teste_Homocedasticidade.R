# Testando a Homocedasticidade

# Definindo o diretório de trabalho
# setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap05")
# getwd()

##### Primeiro Exemplo ##### 

# No exemplo a seguir, carregaremos um conjunto de dados contendo preços de casas e 
# diversas variáveis. 

# Direcionaremos nossa atenção para a primeira suposição que definimos anteriormente 
# (que os resíduos devem ser homocedásticos: em outras palavras, ter a mesma variância).

# Carregando os dados
dados = read.csv("dados/shopping.csv")
View(dados)

# Criando o modelo
modelo = lm(vendas ~ num_pessoas + desconto, data = dados) 
summary(modelo)

# Podemos direcionar nossa atenção para o primeiro plot (Residuais vs Ajustados). 
# É evidente que a variabilidade aumenta à medida que os valores ajustados aumentam. 
# Isso é uma violação de nossa suposição de homoscedasticidade. 
# A variância não é constante.
plot(modelo) 

# Podemos usar outra ferramenta para nossa análise. 
# O Teste Breusch-Pagan pode ser usado para testar a hipótese nula de que a variância 
# é constante. Usamos a biblioteca lmtest com a função bptest.
# Pacote para teste do modelo
install.packages("lmtest")
library(lmtest)

# Teste
?bptest
bptest(modelo) 

# Obtemos um valor-p muito pequeno
# Rejeitamos a hipótese nula de que os resíduos são homocedásticos.


##### Segundo Exemplo ##### 

# Em análise de variância (ANOVA), há um pressuposto que deve ser atendido que é de 
# os erros devem ter variância comum, ou seja, homocedasticidade. 

# Isso implica que cada variável que se está sendo comparada pelo teste F, 
# deve ter aproximadamente a mesma variância para que a ANOVA tenha validade. 

# Quando este pressuposto não é atendido dizemos que as variâncias não são homogêneas, 
# ou ainda, que existe heterocedasticidade.

# A verificação deste pressuposto também pode ser verificado graficamente através 
# do boxplot para os tratamentos vs resíduos. Se existir homocedasticidade espera-se 
# que os boxplots sejam semelhantes.

# Veja o seguinte exemplo, os dados abaixo são provenientes de um experimento em que 
# se deseja verificar se há diferença entre as práticas parentais com relação a três 
# grupos de crianças. 

# O primeiro grupo é de crianças com síndrome de down, o segundo grupo é de 
# crianças com síndrome de down em que os pais recebem orientção sobre práticas 
# parentais para este grupo especial e o terceiro grupo de crianças que não possuem 
# síndrome de down. 

# Para medir as práticas parentais há um instrumento psicológico que gera um escore 
# em que os resultados estão guardados na variável PP.

# Carregando os dados
estudo <- read.csv2('dados/estudo.csv', h = T)
View(estudo)
str(estudo)

# Visualizando como fator (categoria)
summary(factor(estudo$Grupo))

# ANOVA
?aov
modelo <- aov(estudo$PP ~ estudo$Grupo)
summary(modelo)

# A análise de variância nos diz que não há diferença entre a média dos escores 
# de práticas parentais entre os três grupo de crianças. Mas para que este resultado 
# seja válido precisamos verificar alguns pressupostos tais como independência, 
# normalidade e homocedasticidade dos erros. 

# Como aqui o foco é homocedasticidade, verificaremos apenas este último.

# Como temos um número diferente de crianças em cada grupo iremos usar o 
# Teste de Bartlett. Se houvesse número igual de crianças ou número de 
# repetições iguais em cada tratamento, além do Teste de Bartlett, poderíamos usar o 
# Teste de Hartley. 

# Lembrando que estamos testando a hipótese nula das variâncias serem iguais.

# H0 - A variância dos resíduos é constante
# H1 - A variância dos resíduos não é constante

# Boxplot
# Se existir homocedasticidade espera-se que os boxplots sejam semelhantes.
boxplot(modelo$res ~ estudo$Grupo)

# Teste de Bartlett
?bartlett.test
bartlett.test(modelo$res ~ estudo$Grupo)

# Notamos que o teste confirma o que o boxplot nos sugere, homogeneidade das variâncias.
# Não rejeitamos a hipótese nula.


