# Estatística Spearman Rank

# O coeficiente de correlação entre X e Y que costumamos usar é obtido dividindo a covariância 
# de X, Y pelo produto das variâncias de X e Y. Portanto, é restrito a ficar entre -1 e 1. 

# Quando a correlação é -1 , significa que há uma forte relação negativa entre as variáveis. 
# Quando é 1, significa que há um forte relacionamento positivo; 
# E quando é 0, significa que não há relação entre as variáveis. 

# Mas há uma suposição implícita que geralmente ignoramos: o coeficiente de correlação assume 
# que existe uma relação linear. Portanto, é fácil imaginar muitos casos em que pode haver um 
# relacionamento, mas não linear. 

# A estatística Spearman Rank não testa correlação no sentido tradicional (se um valor maior 
# que a média de X está associado linearmente a um valor maior que a média de Y). Mas, no 
# sentido de que existe uma relação monotônica entre X e Y (se esse relacionamento é 
# linear ou não linear).

options(warn = -1)

# Definindo duas variáveis sem relação linear
x = seq(1,100) 
y = 20/(1+exp(x-50)) 

# Plot da relação entre as variáveis
plot(x,y) 

# Teste de correlação com método spearman
?cor.test
cor.test( ~ x + y, method = "spearman", conf.level = 0.95) 

# Teste de correlação com método pearson
cor.test( ~ x + y, method = "pearson", conf.level = 0.95) 

# Como Spearman mede se o relacionamento é monotônico (e, neste caso, todas as observações 
# satisfazem isso em relação à anterior), é basicamente igual a -1. 

# Claro, o relacionamento não é linear, e é por isso que Pearson é -0,88.


# Definindo duas variáveis sem relação linear e com ruído nos dados
x = seq(1,100) 
y = sapply(x,function(x){(runif(1)-0.5)*10 + 20/(1+exp(x-50))})  

# Plot da relação entre as variáveis
plot(x,y) 

# Teste de correlação com método spearman
cor.test( ~ x + y, method = "spearman", conf.level = 0.95) 

# Teste de correlação com método pearson
cor.test( ~ x + y, method = "pearson", conf.level = 0.95) 

# Agora, como podemos ver, o coeficiente de Pearson é quase o mesmo de antes, mas o 
# de Spearman é reduzido substancialmente. Intuitivamente, isso acontece porque, se 
# tivéssemos que traçar uma linha que passasse por esses pontos, ela não teria mudado de 
# maneira alguma devido ao ruído extra (então a Pearson's continuaria a mesma). 

# Mas o coeficiente de Spearman é bem diferente, captura como o relacionamento é monotônico. 
# Se cada variável se comportar de maneira mais irregular, mesmo que a forma geral ainda não 
# seja linear, não poderíamos dizer que o relacionamento é monotônico. É por isso que 
# Spearman pode ser visto como o desvio que temos de um caso perfeito em que o relacionamento 
# é 100% monotônico.

# A estatística de Spearman é essencialmente construída tomando-se a correlação entre 
# os ranks. O coeficiente de Pearson sempre pode ser calculado, mas, para derivar faixas 
# de confiança como as que vemos aqui, os dados precisam ser normais e lineares (ambas as 
# suposições são violadas neste caso). 

# No entanto, Spearman não exige nenhuma premissa distributiva. 

# Como tomamos correlações apenas para fins descritivos, e porque geralmente queremos ver 
# quanta relação linear existe nos dados, geralmente preferimos o coeficiente de Pearson. 
# No entanto, se quisermos ver quão monotônica é a relação, devemos usar a estatística 
# de Spearman.

# Quando Usar Spearman ou Pearson?

# Existem dois casos muito importantes em que queremos usar Spearman em vez de 
# Pearson: Usamos Spearman se tivermos valores discrepantes (outliers); Nesse caso, os 
# resultados da Pearson podem mudar muito devido a apenas alguns valores anormais. 
# O segundo caso é se uma ou ambas as variáveis são medidas em uma escala ordinal 
# (quando podemos classificar as variáveis, mas não podemos especificar sua magnitude), 
# por exemplo, se tivermos níveis de educação e salários. 

# Como as fileiras (ranks) são usadas, e não o número real, Spearman pode lidar 
# com esses casos, enquanto Pearson não. Isso é mostrado no seguinte exemplo:

# Definindo duas variáveis
salario = c(10,50,45,87,69,100) 
nivel_educacional = c(1,2,3,4,5,6) 

salario = c(10,50,45,87,69,1000) 
nivel_educacional = c(1,2,3,4,5,6) 

salario = c(10,50,45,87,69,10000) 
nivel_educacional = c(1,2,3,4,5,6) 

# Teste de correlação com método spearman
cor.test( ~ salario + nivel_educacional, method = "spearman", conf.level = 0.95) 

# Teste de correlação com método pearson
cor.test( ~ salario + nivel_educacional, method = "pearson", conf.level = 0.95) 


