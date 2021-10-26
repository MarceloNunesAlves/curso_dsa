# Funções 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# Uma função é um bloco de código organizado e reutilizável usado para executar uma única ação relacionada. 
# Funções fornecem melhor modularidade para seu programa e um alto grau de reutilização de código.

# Help
?sample
?args
args(sample)
args(mean)
args(sd)


# Funções Built-in
abs(-54)
sum(c(1:6))
mean(c(1:6))
round(c(1.4:7.8))


# Funções dentro de funções
a <- (-10)
b <- (17)
mean(c(abs(a), abs(b)))


# Criando funções nomeadas

# Exemplo 1
func01 <- function(x) { 
  x + x 
  }

func01(5)
class(func01)

# Exemplo 2
func02 <- function(a, b) {
  valor = a ^ b
  print(valor)
}

func02(3, 2)

# Exemplo 3
func03 <- function(x) {
  (x ^ 2)
}

func03(5)


# Criando função anônima
View(mtcars)
length(unique(mtcars$cyl))
lapply(mtcars, function(x) length(unique(x)))


# Lista de funções
func04 <- list(
  calcula_metade = function(x) x / 2,
  calcula_dobro = function(x) x * 2
)

func04$calcula_metade(10)
func04$calcula_dobro(10)


# Chamando funções dentro de funções
func04$calcula_dobro(func03(10))


# Escopo de variáveis em funções
func05 <- function() {
  num <- sample(1:6, size = 1) #Local
  num
}

func05()

# Escopo
print(num)
num <- c(1:6)
num #Global


# Funções sem número definido de argumentos
vec1 <- (10:13)
vec2 <- c("a", "b", "c", "d")
vec3 <- c(6.5, 9.2, 11.9, 5.1)
vec4 <- c(1, 2, 3)

func06 <- function(...){
  df = data.frame(cbind(...))
  print(df)
}

func06(vec1)

func06(vec2, vec3)

func06(vec1, vec2, vec3)


# Funções Built-in - Não tente recriar a roda
# Comparação de eficiência entre função vetorizada e função "vetorizada no R"

x <- 1:100000000

# Função que calcula a raiz quadrada de cada elemento de um vetor de números
meu_sqrt <- function(numeros) {
  resp <- numeric(length(numeros))
  for(i in seq_along(numeros)) {
    resp[i] <- sqrt(numeros[i])
  }
  return(resp)
}


system.time(x2a <- meu_sqrt(x))

system.time(x2b <- sqrt(x))


# Comparando as funções
# Sua máquina pode apresentar resultado diferente por conta da precisão 
# de cálculo do processador.
identical(x2a, x2b)


