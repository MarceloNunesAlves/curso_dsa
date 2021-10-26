# Operações com Arrays e Matrizes 

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


# Matrizes
mat1 <- matrix(1:4, nrow = 2, ncol = 2) 
mat1
mat2 <- matrix(4:7, nrow = 2, ncol = 2)
mat2
mat3 = matrix(1:12, ncol=3, byrow=TRUE)
mat3

# Atributos
mat4 <- matrix(1:6, ncol = 3, nrow = 2)
mat4
length(mat4)
nrow(mat4)
ncol(mat4)
dim(mat4)
rownames(mat4) <- c("A", "B")
colnames(mat4) <- c("a", "b", "c")
mat4

# Indexação
mat1[1,2]
mat2[2,1]
mat2[2,2] <- 20 
mat2[mat2 == 4] <- 0 
mat1[2, ]
mat1[, 2] 
mat4[A,b]
mat4['A','b']

# Operações
mat1 + mat2 
mat1 - mat2    
4 * mat1   
(mat1/mat2)  
t(mat1)     
diag(4)

# Adicionando linhas e colunas
mat5 = matrix(1:12, nrow = 3, ncol = 3)
mat5
mat6 <- cbind(mat5, c(1,2,3))
mat6
mat7 <- rbind(mat5, c(1,2,3))
mat7


# Arrays
x <- array(1:20, dim=c(4,5))   
x
i <- array(c(1:3,3:1), dim=c(3,2))
i
x[i] <- 0     
x

# Array de 3 dimensões
arr1 <- array(
  1:24,
  dim = c(4, 3, 2),
  dimnames = list(
    c("um", "dois", "tres", "quatro"),
    c("um", "dois", "tres"),
    c("um", "dois")
  )
)
arr1
class(arr1)
dim(arr1)
arr1[4, 3, 2]

# Array criado a partir de vetores
vec1 <- c(1,2,4)    
vec2 <- c(15,17,27,3,10,11)
arr2 <- array(c(vec1,vec2), dim = c(3,3,2))
arr2

vetor1 <- c(2,9,6)
vetor2 <- c(10,15,13,16,11,12)
column.names <- c("COLUNA1","COLUNA2","COLUNA3")
row.names <- c("LINHA1","LINHA2","LINHA3")
matrix.names <- c("Matriz1","Matriz2")
arr3 <- array(c(vetor1,vetor2),
                dim = c(3,3,2),
                dimnames = list(row.names,column.names,matrix.names))
print(arr3)
print(arr3[3,,2])
print(arr3[1,3,1])
print(arr3[,,2])

# Operações com arrays
?apply
soma_por_linha <- apply(arr3, c(1), sum)
print(soma_por_linha)

soma_por_coluna <- apply(arr3, c(2), sum)
print(soma_por_coluna)




