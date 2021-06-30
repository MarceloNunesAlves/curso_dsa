setwd("~/git/curso_dsa/estatistica-i/Modulo04/Exercicio")

mydata <- read.csv("dataset.csv") 

# Qual o tempo médio de atendimento
mean(mydata$tempo_telefone)

# Qual a medianado tempo de atendimento?
median(mydata$tempo_telefone)

# Qual o desvio padrão e variância do tempo de atendimento?
desvios <- (mydata$tempo_telefone - mean(mydata$tempo_telefone))
desvios_padrao <- sqrt(sum(desvios)^2/(length(mydata)-1))
desvios_padrao
sd(mydata$tempo_telefone)

variancia <- sum(desvios)^2/(length(mydata)-1)
variancia

#Quais os quartis e percentis 32, 57 e 98 do tempo de atendimento?

Q1 <- quantile(mydata$tempo_telefone, probs = 0.25)
Q1
Q2 <- quantile(mydata$tempo_telefone, probs = 0.50)
Q2
Q3 <- quantile(mydata$tempo_telefone, probs = 0.75)
Q3

perc_32 <- quantile(mydata$tempo_telefone, probs = 0.32)
perc_32
perc_57 <- quantile(mydata$tempo_telefone, probs = 0.57)
perc_57
perc_98 <- quantile(mydata$tempo_telefone, probs = 0.98)
perc_98
