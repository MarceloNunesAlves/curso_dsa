# Orientação a Objetos em R 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap03")
# getwd()

# Estudaremos o conceito de objetos e classes na linguagem R.

# Podemos usar programação orientada a objetos (POO) em R. De fato, tudo em R é um objeto.

# Um objeto é uma estrutura de dados com alguns atributos e métodos que atuam em seus atributos.

# Classe é um blueprint para o objeto. Podemos pensar na classe como um esboço (protótipo) de uma casa. 
# Ela contém todos os detalhes sobre pisos, portas, janelas, etc. 
# Com base nessas descrições, construímos a casa.

# Cada casa é o objeto. Como muitas casas podem ser feitas a partir de uma descrição, podemos criar muitos 
# objetos a partir de uma classe. Um objeto também é chamado de instância de uma classe e o 
# processo de criação desse objeto é chamado de instanciação.

# Enquanto a maioria das linguagens de programação possui um sistema de classe única, 
# R possui três sistemas de classe: S3, S4 e, mais recentemente, sistemas de classe Reference.

# Eles têm suas próprias características e peculiaridades e escolher um sobre o outro é uma questão de 
# preferência. Abaixo, apresentamos uma breve introdução a eles.

# S3 e S4 são os dois sistemas importantes na Programação Orientada a Objetos em R.

# Classe S3

# Com a ajuda da classe S3, você pode aproveitar sua capacidade de implementar a função genérica OO. 
# O S3 é diferente das linguagens de programação convencionais, como Java, C++ e C#, que implementam 
# o envio de mensagens OO. Isso facilita a implementação do S3. Na classe S3, a função genérica faz a 
# chamada para o método S3 é muito casual e não possui nenhuma definição formal de classes.
# S3 requer muito menos conhecimento por parte do programador.

# Classe S4

# A classe S4 é um pouco semelhante à S3, mas é mais formal. 
# Difere do S3 de duas maneiras diferentes. Primeiramente, no S4, existem definições formais de classe 
# que fornecem descrição e representação de classes. Além disso, possui funções auxiliares especiais 
# para definir métodos e genéricos. O S4 também facilita a criação de vários objetos. 
# Isso significa que as funções enéricas são capazes de selecionar métodos com base na classe 
# composta por vários argumentos.


################# Classe S3 ################# 

# Criando Classe S3
lista1 <- list(nome = "Bob", idade = 25, nota = 4.0)
lista1
class(lista1) <- "estudante"
lista1


# Usando um construtor para criar uma classe
estudante <- function(nome, idade, nota) {
  
  # Checando condições
  if(nota > 10 || nota < 0)  stop("Nota precisa estar entre 0 e 10")
  
  # Lista de atributos da classe
  valores <- list(nome = nome, idade = idade, nota = nota)
  
  # Definindo a classe
  attr(valores, "class") <- "estudante"
  valores
}

aluno1 <- estudante("Paulo", 26, 9)
aluno1

aluno2 <- estudante("Maria", 28, 11)

aluno1$nota <- 9.5
aluno1

aluno3 <- estudante("Maria", 28, 8)
aluno3

aluno3$idade <- 35
aluno3
aluno1

# Criando um método para a classe estudante
print.estudante <- function(obj) {
  cat(obj$nome, "\n")
  cat(obj$idade, "anos de idade\n")
  cat("Nota:", obj$nota, "\n")
}

aluno1
aluno3


################# Classe S4 ################# 

# A classe S4 é definida usando a função setClass().

# Na terminologia R, as variáveis na classe S4 são chamadas de slots. 
# Ao definir uma classe, precisamos definir o nome e os slots (junto com a classe do slot).
?setClass
setClass("estudante", slots = list(nome="character", idade="numeric", nota="numeric"))

aluno4 <- new("estudante", nome="Bob", idade=23, nota=7.5)
aluno4
isS4(aluno4)

# A setClass retorna um generator
estudante <- setClass("estudante", slots = list(nome="character", idade="numeric", nota="numeric"))
estudante

# Alterando os valores dos slots:
aluno4@nota <- 9
aluno4

slot(aluno4, "nome") <- "Zico"
aluno4

# Criando um método para Classe S4
showMethods(show)

setMethod("show",
          "estudante",
          function(object) {
            cat(object@nome, "\n")
            cat(object@idade, "anos de idade\n")
            cat("Nota:", object@nota, "\n")
          }
)

aluno4





