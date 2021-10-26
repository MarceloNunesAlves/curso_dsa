# Naming Masking 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# Name Masking - Revisando o Conceito de Escopo Léxico

x <- 100
y <- 200

func1 <- function() {
  x <- 1
  y <- 2
  c(x, y)
}

func1()


x <- 2

func2 <- function() {
  y <- 1
  c(x, y)
}

func2()

# Isso não altera o valor previamente definido para y:
y


# Podemos criar função dentro de função, o que torna a questão ainda mais complicada.
x <- 1
y <- 4

func3 <- function() {
  y <- 2
  i <- function() {
    y <- 3
    z <- 3
    c(x, y, z)
  }
  i()
}

func3()


# Name Masking - Definindo o Problema
x <- 1:5
x
func4 <- function(x, fun) { fun(x) }

func4(x, fun=mean)

mean <- "teste"

func4(x, fun=mean)


# Name Masking - Apresentando Uma Solução
func5 <- function(x, fun) {
  # Se 'fun' não é uma função, tente obter uma função a partir do próprio nome do argumento
  if (!is.function(fun)) {
    fun <- get(as.character(substitute(fun)), mode="function")
  }
  fun(x)
}

func5(x, fun=mean)
mean <- "teste"
func5(x, fun=mean)

?mean
func5(x, fun=base::mean)
func5(x, fun="mean")








