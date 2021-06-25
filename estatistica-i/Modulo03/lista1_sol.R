# Solução Lista 1 de Exercícios em R

# Imports
install.packages("tidyverse")
library(tidyverse)

# Diretório de trabalho
setwd("~/git/curso_dsa/estatistica-i/Modulo03")
getwd()

# Carrega o dataset
data <- read_csv("hour.csv")

# Calcula média, mediana e moda

# Média
lapply(data, mean)

# Mediana
lapply(data, median)

# Moda
md <- lapply(data, table)
lapply(md, max)

# Calcula a temperatura (coluna temp) média por dia da semana (coluna weekday).
data %>% 
  group_by(weekday) %>% 
  summarise(media_temp = mean(temp))

# Cria um histograma na coluna temp.
data %>% 
  ggplot(aes(x = temp)) + 
  geom_histogram(bins = 30)
