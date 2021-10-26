# Ambientes em R 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap03")
# getwd()


# Trabalhando Com Ambientes - Definição e Ambiente Global

# Considere por um momento como o seu computador armazena arquivos. 
# Cada arquivo é salvo em uma pasta e cada pasta é salva em outra pasta, que forma um sistema de 
# arquivos hierárquico. Se o seu computador deseja abrir um arquivo, ele deve primeiro procurar o 
# arquivo neste sistema de arquivos.

# Você pode ver seu sistema de arquivos abrindo uma janela do Windows Explorer, Finder ou File Explorer.
# (dependendo do seu SO) 

# A Linguagem R usa um sistema semelhante para salvar objetos R. 
# Cada objeto é salvo dentro de um ambiente, que é um objeto parecido com uma lista que se assemelha a uma 
# pasta no seu computador. Cada ambiente está conectado a um ambiente pai, um ambiente de nível superior, 
# que cria uma hierarquia de ambientes.

# Ambientes podem ser pensados como uma coleção de objetos (funções, variáveis etc.). 
# Um ambiente é criado quando acionamos o interpretador R pela primeira vez. 
# Qualquer variável que definimos, está agora neste ambiente.

# O ambiente de nível superior disponível para nós no prompt de comando R é o ambiente global 
# chamado R_GlobalEnv. O ambiente global também pode ser chamado de .GlobalEnv nos códigos R.

# Podemos usar a função ls() para mostrar quais variáveis e funções estão definidas no ambiente atual. 
# Além disso, podemos usar a função environment() para obter o ambiente atual.
environment()
.GlobalEnv
ls()

a <- 2
b <- 5
f <- function(x) x <- 0
ls()


# Trabalhando Com Ambientes - Ambientes e Escopo de Objetos

# Observe que x (no argumento da função) não está neste ambiente global. 
# Quando definimos uma função, um novo ambiente é criado.

# No exemplo acima, a função f cria um novo ambiente dentro do ambiente global.
# Na verdade, um ambiente possui um frame, com todos os objetos definidos, e um ponteiro para o 
# ambiente pai.

# Portanto, x está no frame do novo ambiente criado pela função f. 
# Esse ambiente também terá um ponteiro para R_GlobalEnv.
f <- function(x){
    x <- 0
    print("Dentro de f")
    print(x)
    print(environment())
    print(ls())
}

f(5)
x
environment()


# Lembre-se de que este exemplo é apenas uma metáfora. 
# Os ambientes em R existem na memória RAM do computador e não no seu sistema de arquivos. 
# Além disso, ambientes R não são tecnicamente salvos um dentro do outro. Cada ambiente está conectado 
# a um ambiente pai, o que facilita a pesquisa na árvore dos ambientes em R. 
# Mas essa conexão é unidirecional: não há como olhar para um ambiente e dizer quais são seus "filhos". 
# Portanto, você não pode pesquisar na árvore de ambientes em R. 
# De outras formas, o sistema de ambientes em R funciona de maneira semelhante a um sistema de arquivos.

# Mas você pode carregar um pacote como um ambiente e listar de onde os objetos são criados.
library(ggplot2)
as.environment("package:ggplot2")

# O ambiente pai topo da hierarquia é o ambiente vazio (a classe principal de ambientes)
parent.env(emptyenv())
ls(emptyenv())
ls(globalenv())


# Trabalhando Com Ambientes - Regras de Escopo em Ambientes

# R segue um conjunto especial de regras para procurar objetos. 
# Essas regras são conhecidas como regras de escopo em R e você já conheceu algumas delas:

# 1- R procura objetos no ambiente ativo atual.
# 2- Quando você trabalha na linha de comando, o ambiente ativo é o ambiente global. 
# Portanto, R procura objetos que você chama na linha de comando no ambiente global.

# Aqui está uma terceira regra que explica como R encontra objetos que não estão no ambiente ativo:

# 3- Quando R não encontra um objeto em um ambiente, R procura no ambiente pai do ambiente, 
# o pai do pai e assim por diante, até que R encontre o objeto ou atinja o ambiente vazio.
var1 <- 10
f2 <- function(x){
  x <- x + 1
  print(x)
  print(var1)
}

f2(10)
ls()


# Trabalhando Com Ambientes - Criando Ambientes, Ambientes de Pacotes R e Caminho de Pesquisa

# A maioria dos ambientes não é criada por você (por exemplo, com new.env()), 
# mas sim pelo interpretador da linguagem R. Mas podemos criar ambientes se necessário.

# A tarefa de um ambiente é associar ou vincular um conjunto de nomes a um conjunto de valores. 
ambiente1 <- new.env()
ambiente1$elementoa <- FALSE
elementoa <- TRUE
ambiente1$elementob <- "a"
ambiente1$elementoc <- 2.3
ambiente1$elementod <- 1:3

ls()
ls(ambiente1)

resultado <- ambiente1$elementoc * ambiente1$elementod
resultado
ls()
ls(ambiente1)


# Cada pacote anexado por library() ou require() se torna um dos pais do ambiente global. 
# O pai imediato do ambiente global é o último pacote que você anexou, o pai desse pacote é 
# o penúltimo pacote que você anexou e assim por diante.

# Se você seguir todos os pais de volta, verá a ordem em que cada pacote foi anexado. 
# Isso é conhecido como caminho de pesquisa, porque todos os objetos nesses ambientes podem ser 
# encontrados no espaço de trabalho interativo de nível superior. 

# Você pode ver os nomes desses ambientes com base::search() ou os próprios ambientes com 
# rlang::search_envs():
search()
base::search()

library(rlang)
search_envs()
ls('package:stats')


# Obs: Se um objeto não tiver nomes apontando para ele, ele será excluído automaticamente pelo 
# coletor de lixo. Este processo é chamado de gc (garbage collector).

# Visualizando os ambientes
show_env <- function(){
  a <- 1
  b <- 2
  c <- 3
  list(ambiente_interno = environment(), 
       ambiente_pai = parent.env(environment()), 
       objetos = ls.str(environment()))
}

show_env()


# Trabalhando Com Ambientes - Namespaces

# O ambiente pai de um pacote varia de acordo com a ordem que outros pacotes foram carregados. 
# Isso parece preocupante: O pacote encontrará funções diferentes se os pacotes forem carregados 
# em uma ordem diferente? 

# O objetivo dos namespaces é garantir que isso não aconteça e que todos os pacotes funcionem da 
# mesma maneira, independentemente dos pacotes anexados pelo usuário. Por exemplo:
sd

# A função sd() é calculada a partir da função var(), portanto, você pode se preocupar que o 
# resultado de sd() seja afetado por qualquer função chamada var() no ambiente global ou em um 
# dos outros pacotes anexados. 

# Todas as funções de um pacote estão associadas a um par de ambientes: o ambiente do pacote, que você 
# aprendeu anteriormente, e o ambiente do Namespace.

# É assim que você, usuário R, encontra uma função em um pacote anexado, usando ::. Seu pai é 
# determinado pelo caminho de pesquisa, ou seja, a ordem na qual os pacotes foram anexados.

# O ambiente do pacote controla como encontramos a função. 
# O Namespace controla como a função encontra suas variáveis.

sessionInfo()

find("pi")
pi

pi <- 3
pi

conflicts()

base::pi
pi





