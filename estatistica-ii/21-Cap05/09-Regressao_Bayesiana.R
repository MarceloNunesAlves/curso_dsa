# Trabalhando com Regressão Bayesiana

# A mecânica da regressão linear bayesiana segue a mesma lógica que foi descrita 
# no capítulo até aqui. A única diferença real é que especificaremos uma distribuição 
# para os resíduos, que serão distribuídos de acordo com uma distribuição gaussiana, 
# com 0 de média e uma certa variância. Esses resíduos terão origem na subtração dos 
# valores reais, menos os esperados. Esses valores esperados serão iguais à soma de 
# vários coeficientes vezes determinadas variáveis. Em um contexto de regressão linear, 
# queremos construir inferências sobre os coeficientes. Mas aqui (como já mencionamos), 
# estimaremos uma densidade para cada posterior (incluindo os coeficientes).

# É muito importante destacar novamente que não estimamos um parâmetro, mas uma densidade 
# para cada parâmetro. Podemos usar a média, o percentil 50 ou a moda de cada distribuição 
# como uma métrica de relatório, mas não temos um parâmetro verdadeiro.

# Definindo o diretório de trabalho
# setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap05")
# getwd()


# Pacotes
install.packages("devtools")
library(devtools)

# Instala o pacote a partir do código fonte
# Seu sistema operacional vai precisar de um compilador C++
# MacOS (xcode), Linux (gcc), Windows (Microsoft C++ Redistributable)
devtools::install_github("stan-dev/rstan", ref = "develop", subdir = "rstan/rstan")
library(rstan)

# No exemplo a seguir, ajustaremos um modelo de regressão linear bayesiano ao nosso 
# conjunto de dados de preços de casas. O objetivo é modelar os preços das casas em 
# termos de diversas variáveis, como o tamanho da propriedade, o número de banheiros, 
# o número de quartos, o número de entradas, o tamanho da varanda e o tamanho da entrada 
# da casa. 

# Neste exemplo, não seremos muito específicos sobre os anteriores, mas sabemos que todas 
# essas variáveis devem ter um impacto positivo. 

# Uma possibilidade natural é usar uma distribuição gama(), que é naturalmente limitada 
# por zero.

# Carrega os dados
dados = read.csv("dados/precos_casas.csv") 
View(dados)

# Define o modelo
modelo = " 

data { 
real y[481]; 
real x[481,6]; 
} 

parameters { 
real beta[6]; 
real sigma; 
real alpha; 
} 

model { 
beta  ~ gamma(3,1); 
for (n in 1:481) 
    y[n] ~ normal(alpha + beta[1]*x[n,1] + beta[2]*x[n,2] + beta[3]*x[n,3] + beta[4]*x[n,4] + beta[5]*x[n,5] +   
beta[6]*x[n,6], sigma); 
} 
" 

# Primeiro criamos um modelo de regressão linear frequentista para comparar com o modelo bayesiano
reg_lin_freq <- lm(preco_casa ~ tamanho + numero_banheiros + numero_quartos + numero_entradas + tamanho_varanda + tamanho_entrada, data = dados)  
summary(reg_lin_freq)

# Definimos as variáveis
xy = list(y = dados[,1], x = dados[,2:7]) 

# Criamos o modelo de regressão linear bayesiana
?stan
reg_lin_bayes = stan(model_code = modelo, 
                     data = xy, 
                     warmup = 500, 
                     iter = 5000, 
                     chains = 3, 
                     cores = 2, 
                     thin = 1,
                     verbose = FALSE) 

# Plot das distribuições dos coeficientes
traceplot(reg_lin_bayes) 

# Sumário do modelo
summary(reg_lin_bayes) 

# Densidades
stan_dens(reg_lin_bayes) 


