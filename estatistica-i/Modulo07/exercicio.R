# Uma lâmpada é selecionada aleatoriamente de uma caixa que contém uma lâmpada de 40
# watts, uma lâmpada de 60 watts, uma lâmpada de 75 watts, uma lâmpada de 100 watts e uma
# lâmpada de 120 watts. Escreva a função de probabilidade para a variável aleatória que
# representa a potência da lâmpada selecionada aleatoriamente e determine a média e a
# variância dessa variável aleatória.

lampadas<-c(40,60,75,100,120)
n<-5
p <- 1/n
media_X <- p * sum(lampadas)
var_X <- p * sum((lampadas-media_X)^2)

# Calcule a probabilidade de obter 6 ou mais “caras” em 10 lançamentos de uma moeda
# ponderada, onde a probabilidade de obter uma “cara” em qualquer tentativa é de 0,33.

p<-0.33
x<-6
n<-10

# Distribuição binomial P(X>=6)
sum(dbinom(6:10, 10, 0.33))
# Ou
dbinom(6, 10, 0.33)+dbinom(7, 10, 0.33)+dbinom(8, 10, 0.33)+dbinom(9, 10, 0.33)+dbinom(10, 10, 0.33)
# Ou
recfunction <- function(val) {
  if(val > 0){
    return (val * recfunction(val - 1))
  }else{
    return (1)
  }
}

x <- 6
p_6 <- (recfunction(n)/(recfunction(x)*recfunction(n-x)))*(p^x)*((1-p)^(n-x))
x <- 7
p_7 <- (recfunction(n)/(recfunction(x)*recfunction(n-x)))*(p^x)*((1-p)^(n-x))
x <- 8
p_8 <- (recfunction(n)/(recfunction(x)*recfunction(n-x)))*(p^x)*((1-p)^(n-x))
x <- 9
p_9 <- (recfunction(n)/(recfunction(x)*recfunction(n-x)))*(p^x)*((1-p)^(n-x))
x <- 10
p_10 <- (recfunction(n)/(recfunction(x)*recfunction(n-x)))*(p^x)*((1-p)^(n-x))
p_6+p_7+p_8+p_9+p_10

# Mais acidentes são registrados nas oficinas de reparo de carrocerias durante os meses de maio
# e junho do que no resto do ano. Suponha que uma oficina particular tenha uma média de
# quatro acidentes por mês. Qual é a probabilidade de haver mais de sete acidentes nesta oficina
# durante o mês de maio? Assuma que o número de carros atendidos na oficina siga
# uma distribuição de Poisson.

med <- 4
x <- 7
ppois(q=x, lambda=med, lower=FALSE)

# Qual é a probabilidade de não mais do que três acidentes ocorrerem durante os meses de maio e junho?

med <- 4 * 2 # Dois meses
x <- 3
ppois(q=x, lambda=med)

# Chamadas telefônicas para um número local 911 são conhecidas por seguir uma distribuição de Poisson com uma média de duas chamadas por minuto. Calcule a probabilidade de que:
# (a) haverá zero chamadas durante um período de um minuto.
dpois(x=0, lambda=2)

# (b) haverá menos de cinco chamadas em um período de um minuto.
ppois(q=4, lambda=2)

# (c) haverá menos de seis chamadas em uma hora.
ppois(q=5, lambda=2*60)

