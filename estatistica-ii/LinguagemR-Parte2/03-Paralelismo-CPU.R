# Paralelismo em R - CPU

# Quando você tem uma lista de tarefas repetitivas, pode acelerar o trabalho adicionando mais 
# poder de computação. Cada tarefa que é completamente independente das outras, é candidata para 
# ser executada em paralelo, cada uma em seu próprio núcleo. 

# Por exemplo, vamos criar um loop simples que usa amostragem com substituição para fazer uma análise 
# baseada em bootstrap. Nesse caso, selecionamos as colunas Sepal.Length e Species no conjunto 
# de dados íris, em um subconjunto de 100 observações e, em seguida, iteramos em 10.000 ensaios, 
# cada vez que reamostramos as observações com substituição. 

# Em seguida, executamos uma regressão logística ajustando as espécies em função do comprimento 
# e registramos os coeficientes para cada tentativa a ser retornada.

df1 <- iris[which(iris[,5] != "setosa"), c(1,5)]
View(df1)
ensaios <- 10000
resultado <- data.frame()

?system.time
?proc.time

system.time({
  ensaio <- 1
  while(ensaio <= ensaios) {
    ind <- sample(100, 100, replace = TRUE)
    result1 <- glm(df1[ind,2] ~ df1[ind,1], family = binomial(logit))
    r <- coefficients(result1)
    resultado <- rbind(resultado, r)
    ensaio <- ensaio + 1
  }
})

# User Time fornece o tempo gasto na CPU pelo processo atual (ou seja, a sessão R atual).

# System Time fornece o tempo de CPU gasto pelo kernel (o sistema operacional) em nome do processo atual.

# Elapsed Time (Tempo Decorrido) é o tempo total cobrado da(s) CPU(s) pela expressão.

# Normalmente, user time e elapsed time são relativamente próximos. Mas eles podem variar em algumas outras 
# situações. Por exemplo:
  
# Se o elapsed time > user time, isso significa que a CPU aguarda algumas outras operações.
# Se o elapsed time < user time, isso significa que sua máquina possui vários núcleos e pode usá-los

# O problema desse loop acima é que executamos cada teste sequencialmente, o que significa que 
# apenas um dos nossos 8 cores nesta máquina está em uso (na sua máquina isso poderá ser diferente). 

# Para explorar o paralelismo, precisamos ser capazes de despachar nossas tarefas como funções, 
# com uma tarefa indo para cada processador. 

# Para fazer isso, precisamos converter nossa tarefa em uma função e, em seguida, usar a 
# família apply() de funções R para aplicar essa função a todos os membros de um conjunto. 

# Em R, o uso da família apply geralmente é mais rápido que o código equivalente em um loop. 
# Aqui está o mesmo código reescrito para usar lapply(), que aplica uma função a cada um dos 
# membros de uma lista (nesse caso, os testes que queremos executar):

df2 <- iris[which(iris[,5] != "setosa"), c(1,5)]
ensaios <- seq(1, 10000)

func1 <- function(ensaio) {
  ind <- sample(100, 100, replace = TRUE)
  result1 <- glm(df2[ind,2] ~ df2[ind,1], family = binomial(logit))
  r <- coefficients(result1)
  res <- rbind(data.frame(), r)
}

system.time({
  resultados <- lapply(ensaios, func1)
})

# Praticamente não tivemos um ganho de performance, mas ainda podemos melhorar substancialmente 
# usando paralelização!


# Paralelização

# Ao paralelizar tarefas, pode-se:

# 1- Usar os vários núcleos em um computador local através de funções como mclapply (ou outros pacotes em R)
# 2- Usar vários processadores em máquinas locais (e remotas) usando makeCluster e clusterApply

# Na abordagem 2, é necessário copiar manualmente os dados e o código para cada membro do cluster usando 
# o clusterExport. Isso é trabalho extra, mas às vezes ter acesso a um grande cluster vale a pena

# Paralelizando com mclapply

# A biblioteca parallel pode ser usada para enviar tarefas (codificadas como chamadas de função) para cada 
# um dos núcleos de processamento em sua máquina, em paralelo. Isso é feito usando a função parallel::mclapply, 
# que é análoga a lapply, mas distribui as tarefas para vários processadores. 

# A função mclapply reúne as respostas de cada uma dessas chamadas de função e retorna uma lista de respostas 
# que tem o mesmo tamanho da lista ou vetor de dados de entrada (um retorno por item de entrada).

library(parallel)
library(MASS)

num_reps <- rep(100, 40)

func2 <- function(reps) kmeans(Boston, 4, nstart = reps)

numCores <- detectCores()
numCores

system.time(
  resultados <- lapply(num_reps, func2)
)

system.time(
  resultados <- mclapply(num_reps, func2, mc.cores = numCores)
)

# Agora vamos demonstrar com nosso exemplo de bootstrap:

df2 <- iris[which(iris[,5] != "setosa"), c(1,5)]
ensaios <- seq(1, 10000)

func1 <- function(ensaio) {
  ind <- sample(100, 100, replace = TRUE)
  result1 <- glm(df2[ind,2] ~ df2[ind,1], family = binomial(logit))
  r <- coefficients(result1)
  res <- rbind(data.frame(), r)
}

system.time({
  resultados <- mclapply(ensaios, func1, mc.cores = numCores)
})

# INCRÍVEL, NÃO? MELHORAMOS A PERFORMANCE DE FORMA SIGNIFICATIVA E ISSO PODE SER UM 
# DIFERENCIAL EM PROJETOS DE DATA SCIENCE.


# Paralelizando com foreach e doParallel

for (i in 1:3) {
  print(sqrt(i))
}

# O método foreach é semelhante, mas usa o operador sequencial %do% para indicar uma expressão a ser executada. 
# Observe a diferença na estrutura de dados retornada.

install.packages("foreach")
library(foreach)

foreach (i=1:3) %do% {
  sqrt(i)
}

# Além disso, o foreach suporta um operador de paralelização %dopar% do pacote doParallel. 
# Isso permite que cada iteração através do loop use núcleos diferentes ou máquinas diferentes em um cluster. 
# Aqui, demonstramos o uso de todos os núcleos na máquina atual.

install.packages("doParallel")
library(foreach)
library(doParallel)

# Usando multicore
registerDoParallel(numCores)  

foreach (i=1:3) %dopar% {
  sqrt(i)
}

# Para simplificar a saída, o foreach possui o parâmetro .combine que pode simplificar os valores de retorno
foreach (i=1:3, .combine=c) %dopar% {
  sqrt(i)
}

# Retornando um dataframe
foreach (i=1:3, .combine=rbind) %dopar% {
  sqrt(i)
}

# Vamos usar o conjunto de dados iris para fazer bootstrap em paralelo.

df3 <- iris[which(iris[,5] != "setosa"), c(1,5)]
ensaios <- 10000

system.time({
  r <- foreach(icount(ensaios), .combine=rbind) %dopar% {
    ind <- sample(100, 100, replace = TRUE)
    result1 <- glm(df3[ind,2] ~ df3[ind,1], family = binomial(logit))
    coefficients(result1)
  }
})

# E agora vamos comprar com a mesma execução mas de forma serial

system.time({
  r <- foreach(icount(ensaios), .combine=rbind) %do% {
    ind <- sample(100, 100, replace = TRUE)
    result1 <- glm(df3[ind,2] ~ df3[ind,1], family = binomial(logit))
    coefficients(result1)
  }
})




