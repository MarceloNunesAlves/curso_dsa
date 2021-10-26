# Funções com Lista de Argumentos 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()


# Função com argumentos fixos
func1 <- function(arg1, arg2) {
  list(arg1, arg2)
}

# Função com lista de argumentos 
func2 <- function(arg, ...) {
  print(list(arg))
  func1(...)
}

# Testando func1
func1(100)
func1(100, 200)
func1(100, 200, 300)

# Testando func2
func2(100, 200)
func2(100, 200, 300)
func2(100, 200, 300, 400)


# Função com lista de argumentos e lista
func3 <- function(...) {
  list(...)
}

func3(100)
func3(100, 200, 300)
func3(100, 200, 300, 400)


