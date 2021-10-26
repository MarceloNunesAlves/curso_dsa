# Dynamic Lookup 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# O escopo léxico determina onde, mas não quando procurar valores de variáveis. 
# R procura pelas variáveis quando a função é executada, não quando a função é criada. 
# Juntas, essas duas propriedades nos dizem que a saída de uma função pode ser diferente dependendo 
# dos objetos fora do ambiente da função:

# Criando a função - R não procura se a variável x existe neste momento
print(x)
func1 <- function() x + 1

# Atribuindo um valor a x
x <- 150
print(x)

# Agora sim R vai buscar pelo valor da variável x
func1()

# Outro teste
x <- 200
func1()


# Se você cometer um erro de ortografia no seu código, não receberá uma mensagem de erro ao criar a função. 
# E, dependendo das variáveis definidas no ambiente global, você pode nem receber uma mensagem de erro 
# ao executar a função.

# Para detectar esse problema, use codetools::findGlobals(). 
# Esta função lista todas as dependências externas dentro de uma função:
codetools::findGlobals(func1)

# Podemos ainda zerar manualmente o environment da função usando emptyenv(), 
# um environment que não contém nada:
environment(func1) <- emptyenv()
func1()

# O problema e sua solução revelam porque esse comportamento aparentemente indesejável existe: 
# R se baseia no escopo léxico para encontrar tudo, desde o óbvio, como mean(), até o menos óbvio, 
# como + ou até {}. Isso confere às regras de escopo de R uma simplicidade bastante interessante

