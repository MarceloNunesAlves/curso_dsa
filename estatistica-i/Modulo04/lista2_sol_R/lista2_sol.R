# Solução Lista 2 de Exercícios em R

# Diretório de trabalho
setwd("~/Dropbox/DSA/AnaliseEstatisticaI/Modulo03/Lista2")
getwd()

# Carrega o dataset
data <- read.csv("dataset.csv")
View(data)
str(data)

# 1-	Quais as 3 cores dos veículos mais vendidos?
tabcor <- table(data$cor)
tabcor

# Melhorando a resposta do item 1
library(tidyverse)

data %>% 
  count(cor) %>% 
  top_n(3,n) %>% 
  arrange(desc(n))

# 2-	De qual ano são os veículos mais vendidos?
data$ano <- as.factor(data$ano)
tabano <- table(data$ano)
tabano

# Melhorando a resposta do item 2
data %>% 
  count(ano) %>% 
  top_n(3,n) %>% 
  arrange(desc(n))

# 3-	Crie um barplot para apresentar sua resposta no item 2.
barplot(tabcor, main="Counts")

# Melhorando a resposta do item 3
data %>% 
  count(ano) %>% 
  top_n(3,n) %>% 
  ggplot(aes(x = ano, y = n)) + 
  geom_bar(stat = "identity") +
  labs(title = "Ano dos veículos mais vendidos") +
  xlab("Ano") +
  ylab("Total de Carros")

# 4- Qual o percentual de vendas de veículos com transmissão automática?
tabcambio <- table(data$transmissao)
tabcambio
relfreq <- prop.table(tabcambio) * 100
relfreq

# Melhorando a resposta do item 4
data %>% 
  group_by(transmissao) %>% 
  summarise(perc_vendas_trans = n()) %>% 
  mutate("%" = round((perc_vendas_trans / sum(perc_vendas_trans)*100),3))

# 5- Crie um Pie Chart para representar sua resposta no item 4.
lbls <- c("Auto", "Manual")
lbls <- paste(lbls,"%",sep="")
pie(relfreq, labels = lbls, col = rainbow(length(lbls)), main="Pie Chart de Veículos Vendidos Por Tipo de Transmissão")

# Melhorando a resposta do item 5
data %>% 
  group_by(transmissao) %>% 
  summarise(perc_vendas_trans = n()) %>% 
  mutate("%" = round((perc_vendas_trans / sum(perc_vendas_trans)*100),2)) %>% 
  ggplot(aes(x = "", y = transmissao, fill = transmissao)) + 
  geom_bar(width = 1, stat = "identity") +
  coord_polar("y", start = 0) +
  geom_text(aes(label = `%`), hjust = .5, vjust = -1.5, color = "white", fontface = "bold") +
  labs(title = "Percentual de vendas de veículos com transmissão automática") +
  xlab("") +
  ylab("Transmissão")

# 6- Qual o percentual de venda de veículos por modelo?

# Alternativa 1
install.packages("janitor")
library(janitor)
tabyl(data$modelo, sort = TRUE)

# Alternativa 2
data %>% 
  group_by(modelo) %>% 
  summarise(perc_vendas_mod = n()) %>% 
  mutate("%" = round((perc_vendas_mod / sum(perc_vendas_mod)*100),2))

# Alternativa 3
install.packages("epiDisplay")
library(epiDisplay)
tab1(data$modelo, sort.group = "decreasing", cum.percent = TRUE)
?tab1


# 7- Calcule o percentual de vendas por preço de veículo e o percentual acumulado.
tabpreco <- table(data$preco)
tabpreco
relfreq <- prop.table(tabpreco) * 100
relfreq
cumsum(relfreq)

# Alternativa
data %>% 
  group_by(preco) %>% 
  summarise(perc_vendas_preco = n()) %>% 
  mutate("freq_Relativa" = round((perc_vendas_preco / sum(perc_vendas_preco)*100),2),
         "freq_Acumulada" = cumsum(freq_Relativa))

# 8 - Liste o total de veículos vendidos por ano e por tipo de transmissão 
# (Dica: uma tabela de contingência faz isso para você com um comando)
tab <- table(data$ano, data$transmissao)
tab
?table

# 9- Imprima um resumo estatístico com o teste do qui-quadrado, graus de liberdade e valor p do resultado do item anterior.
summary(tab)
chisq.test(tab)

# 10 - Crie um barplot a partir do resultado do item 8.
barplot(tab, beside = TRUE, legend.text = rownames(tab), ylab = "Frequência Absoluta")







