# Operações com Vetores 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# Um dos recursos essenciais da linguagem R é sua capacidade robusta de manipular e processar 
# operações estatísticas complexas com uma estratégia otimizada.

# R lida com cálculos complexos usando essas estruturas de dados:
  
# Vetores (1D) - Uma estrutura de dados básicos.
# Matrizes (2D) - Uma estrutura de duas dimensões de números ou outros tipos de objetos matemáticos. 
# Arrays (nD) - Um estrutura com qualquer número de dimensões.
# Listas (Heterogêneo) - As listas armazenam coleções de objetos.
# DataFrames (Heterogêneo) - Gerados pela combinação de múltiplos vetores, de forma que cada vetor se torne uma coluna separada.

# Vetores

# Vetores Atômicos
c(100,200,300)
v <- 1:5
v
seq(2,4, by = 0.4)
length(c("aa", "bb", "cc", "dd", "ee", "ff"))
vetor <- c('cachorro',3,'gato','rato',7,12,9,'frango', TRUE)
vetor
typeof(vetor)


# Operações com vetores
mode(vetor)
vetor[2] + vetor[5]
as.numeric(vetor[2]) + as.numeric(vetor[5])
x <- c(1,4,7,NA,12,19,15,21,20)
x
mean(x)
mean(x, na.rm=TRUE)
x[!is.na(x)]
typeof(x)
is.atomic(x)


# Indexação de Vetores e Subsetting

# Vetor de inteiros positivos - indica os elementos selecionados
# Vetor de inteiros negativos - Indica elementos rejeitados
# Vetor de cadeias de caracteres - Usado apenas para vetores com elementos nomeados
# Vetor de Valores lógicos - Eles são o resultado das condições avaliadas.

vec = c(15,30,20,73,91,41) 
vec[c(1,5,6,9)]
vec[2:5]
vec[-2]
vec[vec < 40]






