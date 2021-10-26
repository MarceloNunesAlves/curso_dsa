# Pesquisas em Datasets com Mais de 10 Milhões de Registros  

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# R é uma linguagem orientada a vetores e a maioria das coisas que você faz em R é otimizada 
# para isso, mas e se você precisar de algo menos típico ... E se você precisar encontrar um 
# elemento específico em um conjunto de dados? Há muitas opções para fazer isso em R, 
# mas quando seu conjunto de dados tem alguns milhões de linhas ou mais, as pesquisas podem 
# ser extremamente lentas. Isso é especialmente problemático em aplicativos Shinny, 
# em que o usuário deve receber um feedback sobre sua ação em uma fração de segundos. 
# Caso contrário, o usuário pode ficar realmente frustrado ao usar seu aplicativo!

# Instalando pacotes
install.packages("tibble")
install.packages("stringi")
library(tibble)
library(stringi)

# Função para gerar dados randômicos
random_string_column <- function(n) {
  stringi::stri_rand_strings(n = n, length = 8)
}

# Função para gerar dataframe com dados randômicos
random_data_frame <- function(n) tibble(
  col1 = random_string_column(n),
  col2 = random_string_column(n)
)

# Gerando o dataframe com 10 milhões de registros
data <- random_data_frame(10^7)

# Função para calcular o tempo de execução
time <- function(...) {
  time_measurement <- system.time(eval(...))
  time_measurement[["user.self"]]
}

# Função de benchmark
benchmark <- function(..., n = 100) {
  times <- replicate(n, ...)
  c(min = min(times), max = max(times), mean = mean(times))
}

# Função para seleção randômica
select_random_key <- function() {
  data[sample(1:nrow(data), 1), ]$col1
}


# Usando dplyr
install.packages("dplyr")
library(dplyr)

# Pesquisa por um valor dentro do conjunto de dados
benchmark({
  key_to_lookup <- select_random_key()
  time(data %>% filter(col1 == key_to_lookup))
})

# Em média, encontrar um único elemento usando o filtro leva 108 ms em média (na minha máquina). 
# Isso pode não parecer muito, mas na verdade isso é muito lento - especialmente se você 
# quiser fazer várias dessas operações de cada vez.
# Por que o filtro é tão lento? O dplyr não sabe nada sobre o nosso conjunto de dados. 
# A única maneira de encontrar elementos correspondentes é procurar linha por linha e 
# verificar se os critérios são correspondidos. Quando o conjunto de dados fica grande, 
# isso simplesmente deve levar tempo. Vamos tentar outra alternativa.


# Usando data.table
install.packages("data.table")
library(data.table)

# Converte o dataframe para um objeto data.table
data_table <- data.table(data)

# Pesquisa por um valor dentro do conjunto de dados
benchmark({
  key_to_lookup <- select_random_key()
  time(data_table[col1 == key_to_lookup])
})

# No pior dos casos, demorou quase 170 ms, em média, para encontrar um elemento!

# Você pode estar pensando: talvez seja apenas dplyr e data.table? 
# Talvez filtrar usando operadores internos seja mais rápido?
# Vamos tentar então.

# Usando filtro como índice
benchmark({
  key_to_lookup <- select_random_key()
  time(data[data$col1 == key_to_lookup,])
})

# Demorou quase 97.8 ms, em média, para encontrar um elemento!

# Usando which
benchmark({
  key_to_lookup <- select_random_key()
  time(data[which(data$col1 == key_to_lookup),])
})

# Demorou quase 86.4 ms, em média, para encontrar um elemento!

# Ainda o mesmo problema de lentidão. 
# Filtros de dataframes e which também usam pesquisa linear, de modo que poderíamos 
# esperar que eles não fossem notavelmente mais rápidos que dplyr :: filter.

# E por que não usar hash tables?

# O problema de pesquisas eficientes obviamente não é específico em R. 
# Uma das abordagens é usar uma tabela de hash. Em suma, a tabela de hash é uma estrutura 
# de dados muito eficiente, com tempo de pesquisa constante. 
# É implementado na maioria das linguagens de programação modernas e amplamente utilizado 
# em muitas áreas. 

# Se você precisar de uma tabela de hash em R, poderá usar uma estrutura de dados 
# construída em R: environments. Environments são usados para manter a vinculação de 
# variáveis a valores. Internamente, eles são implementados como uma tabela de hash. 

# Antes de podermos usar uma tabela de hash, precisamos criá-la. 
# Construir um environment com 10 ^ 7 elementos é extremamente lento: leva mais de uma hora. 
# Para 10 ^ 6 elementos, leva cerca de 5 minutos

environment_source <- setNames(as.list(data$col2), data$col1)
time(as.environment(environment_source))
View(environment_source)

# Data.table indexes

# É uma pena que não possamos usar tabelas de hash para grandes conjuntos de dados. 
# No entanto, quando a coluna que você está pesquisando é um número ou uma string, 
# existe outra opção. Você pode usar índices ordenados do pacote data.table.

# O índice mantém uma versão ordenada de nossa coluna, o que leva a pesquisas muito mais rápidas. 
# Encontrar um elemento em um conjunto classificado com pesquisa binária tem um tempo de 
# execução logarítmico - complexidade de O (log n). 
# Na prática, o índice pode ser implementado de maneiras diferentes, mas geralmente o tempo 
# necessário para criar um índice é O (n * log n), que na prática é frequentemente rápido o suficiente.

# Vamos medir o tempo necessário para criar o índice para o conjunto de dados:
time(setkey(data_table, col1))

# E então testamos:
benchmark({
  key_to_lookup <- select_random_key()
  time(data_table[.(key_to_lookup), nomatch = 0L])
})

# Uau! Em média nosso registro é encontrado em 10.8 ms. 
# Uma diferença incrível em relação a todos outros métodos.



