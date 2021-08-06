# Solução Lista 5 de Exercícios em R

# Diretório de trabalho
setwd("~//git/curso_dsa/estatistica-i/Modulo07/2-lista5_sol.R")
getwd()

# 1- Em 100 lançamentos de moeda, qual é a probabilidade de ter o mesmo lado subindo 10 vezes seguidas?

# Número de tentativas (quanto maior esse número, melhor nossas estimativas)
n <- 100000L

# Número de flips da moeda
nflips <- 100L

# Comparação
comparison <- 10L

# Acompanhar o resultado "sucesso"
num_succe <- 0L

# Executando o experimento
for (i in 1:n) {
  num_succe <- num_succe +
    (max(rle(rbinom(nflips, 1, 0.5))$lengths) >= comparison)
}

# Probabilidade estimada
num_succe / n


# 2- Seis crianças estão na fila. Qual é a probabilidade de que elas estejam em ordem alfabética por nome? 
# Suponha que duas crianças não tenham o mesmo nome exato.

# Número de tentativas
n <- 5e5L

# Número de crianças 
kids <- 1L:6L

# Acompanhar o resultado "sucesso"
num_succe <- 0L

# Executando o experimento
for (i in 1L:n) {
  num_succe <- num_succe + identical(sample(kids, size = 6), 1L:6L)
}

# Probabilidade estimada
num_succe / n

# Solução alternativa
1 / factorial(6)


# 3- Lembra das  crianças  da  última  pergunta?  Existem  três  meninos  e  três  meninas.  
# Qual  a probabilidade de todas as garotas virem primeiro?

# Número de tentativas
n <- 5e5L

# Número de crianças 
kids <- 1L:6L

# Acompanhar o resultado "sucesso"
num_succe <- 0L

# Lembre-se que o sucesso é quando todas as meninas vêm em primeiro lugar, 
# o que também significa a soma de os primeiros três elementos são iguais a seis.

# Executando o experimento
for (i in 1L:n) {
  num_succe <- num_succe + (sum(sample(kids, size = 3)) == 6L)
}

# Probabilidade estimada
num_succe / n

# Solução alternativa
factorial(3)^2 / factorial(6)


# 4- Em  seis  lançamentos  de  moeda,  qual  é  a  probabilidade  de  ter  um  lado  diferente  em  cada jogada, 
# ou seja, você nunca ganha duas coroas ou duas caras seguidas?

# Número de tentativas
n <- 1e5L

# Número de flips da moeda
nflips <- 6L

# Acompanhar o resultado "sucesso"
num_succe <- 0L

# Nós deixamos 1 representar "coroas" e 0 "não caras"
for (i in 1:n) {
  num_succe <- num_succe +
    (max(rle(rbinom(nflips, 1, 0.5))$lengths) == 1L)
}
?rle
?rbinom

# Probabilidade estimada
num_succe / n

# Solução alternativa
(1/2)^5


# 5- Uma mão aleatória de cinco cartas é distribuída de um baralho padrão. 
# Qual é a chance de um flush (todas as cartas são do mesmo naipe)?

# Defina um baralho de cartas e saiba que aqui estamos apenas preocupados com o naipe.
deck <- rep(c("C","D", "S", "H"), times = rep(13, 4))

# Número de tentativas
n <- 3e5L

# Acompanhar o resultado "sucesso"
num_succe <- 0L

# Executando o experimento
for (i in 1L:n) {
  num_succe <- num_succe +
    (length(unique(sample(deck, 5L))) == 1L)
}

# Probabilidade estimada
num_succe / n

# Solução alternativa
4 * choose(13, 5) / choose(52, 5)
?choose


# 6- Numa  mão  aleatória  de  treze  cartas  de  um  baralho  normal,  
# qual  é  a  probabilidade  de  que nenhuma das cartas seja um ás e nenhuma seja um coração (♥)?

# Construa um baralho completo.
deck <- matrix(c(rep(as.character(1:13),   times = 4),
                 rep(c("C","D", "S", "H"), times = rep(13, 4))),
               nrow = 52L,
               dimnames = list(NULL, c("number", "suit")))

# Número de tentativas
n <- 2e5L

# Acompanhar o resultado "sucesso"
num_succe <- 0L

# Executando o experimento
for (i in 1L:n) {
  
  # Lança uma mão aleatória
  
  hand <- deck[sample(1L:52L, 13L), ]
  
  # Verifique se 'nenhum é o coração' e prossiga para a próxima mão
  
  if (!any(hand[, "suit"] == "H")) {
    
    # Verifique também que não há ás
    
    if (!any(hand[, "number"] == "1")) {
      num_succe <- num_succe + 1L
    }
  }
}

# Probabilidade estimada
num_succe / n

# Solução alternativa
choose(36, 13) / choose(52, 13)


# 7- Em  quatro  festas,  cada  uma  com  13,  23,  33  e  53  pessoas,  respectivamente,  
# qual  a probabilidade de que pelo menos duas pessoas participem de um aniversário em cada festa? 
# Suponha que não haja dias bissextos, que todos os anos sejam 365 dias e que os nascimentos sejam distribuídos 
# uniformemente ao longo do ano.

# Dias possíveis para nascer 
days_pos <- 1L:365L

# Quantidade de pessoas nas festas 
groups <- c(13, 23, 33, 53)

# Número de tentativas
n <- 1e5L

# Acompanha os "sucessos", ou seja, duas pessoas na festa compartilham um aniversário
num_succe <- vector(mode = "numeric", length = 4)
names(num_succe) <- paste0("party_size_", groups)

# Executa a simulação e adiciona a num_succe cada vez que houver uma duplicata em cada grupo
for (i in 1L:n) {
  a <- lapply(groups, function(x) sample(days_pos, size = x, replace = TRUE))
  num_succe <- num_succe + sapply(a, function(x) any(duplicated(x)))
}

# Probabilidade estimada
num_succe / n


# 8- Qual é a probabilidade de lucro se custa 15 reais para participar?

# Número de tentativas
n <- 1e5L

# Número máximo de lances
max_throws <- 1000L

# Acompanha os "sucessos"
num_succe <- 0L

# Custo
cost_game <- 15L

# Define a função de lançamento de moedas
coin_throw <- function() {
  rbinom(1, 1, 0.5)
}

# Executa a simulação
for (i in 1L:n) {
  for (throw in 1L:max_throws) {
    if(coin_throw() == 0L) {
      num_succe <- num_succe + (2^throw > cost_game)
      break
    }
  }
}

# Probabilidade estimada
num_succe / n

# Solução alternativa
throws_needed <- min(which(2^(1:1000) > cost_game)) - 1
1 - sum(1/2^(1:throws_needed))


# 9- De volta ao lançamento de moedas. Qual é a probabilidade do padrão cara-cara-coroa aparecer antes do cara-cara?

# Número de tentativas
n <- 1e5L

# Acompanha os "sucessos"
num_succe <- 0L

# Define a função de lançamento de moedas
coin_throw <- function() {
  rbinom(1, 1, 0.5)
}

# Define uma função para a simulação do problema
hht_vs_thh <- function() {
  
  # Vetor dos últimos três lances. Não precisa armazenar mais.
  
  last_three <- vector(mode = "numeric", length = 3)
  
  # Definição de vitória / derrota
  
  win <- c(1, 1, 0)
  loss <- c(0, 1, 1)
  
  # Preencha os três primeiros
  
  for (i in 1L:3L) {
    last_three[i] <- coin_throw()
  }
  
  # Comece a verificar e adicionar mais um lance se nenhum vencedor
  
  while (TRUE) {
    if (identical(last_three, win)) {
      value <- 1L
      break
    } else if (identical(last_three, loss)) {
      value <- 0L
      break
    }
    
    # Jogue mais uma vez
    
    last_three[1:2] <- last_three[2:3]
    last_three[3] <- coin_throw()
  }
  return(value)
}

# Executa a simulação
for (i in 1:n) {
  num_succe <- num_succe + hht_vs_thh()
}

# Probabilidade estimada
num_succe / n


# 10- Qual é a probabilidade de ganhar o carro se você usar a estratégia de primeiro escolher uma porta aleatória 
# e depois trocar de porta todas as vezes?

# Número de tentativas
n <- 1e5L

# O que pode estar atrás das portas
possible_rewards <- c("G", "G", "C")

# Nome das portas 1, 2, 3
num_door <- 1L:3L

# Acompanha os "sucessos"
num_succe <- 0L

# Executa a simulação
for (i in 1:n) {
  
  # O que está por trás das portas é randomizado
  
  behind_doors <- sample(possible_rewards)
  
  # Você escolhe uma porta aleatoriamente
  
  chos_door <- sample(num_door, size = 1)
  
  # As portas que você não escolheu
  
  remain_doors <- setdiff(num_door, chos_door)
  
  # Portas restantes que têm uma cabra
  
  remain_goat_doors <- intersect(which(behind_doors == "G"), remain_doors)
  
  # Anfitrião seleciona aleatoriamente uma porta com cabra para mostrar a você
  
  if (length(remain_goat_doors) == 1L) {
    host_door <- remain_goat_doors
  } else {
    host_door <- sample(remain_goat_doors, 1)
  }
  
  # Sua estratégia é escolher a porta que não é aquela que o anfitrião lhe mostrou e 
  # não a que você escolheu inicialmente e que você é bem sucedido se um carro estiver lá
  
  num_succe <- num_succe + (behind_doors[-c(chos_door, host_door)] == "C")
}

# Probabilidade estimada
num_succe / n

# Solução alternativa
2/3





