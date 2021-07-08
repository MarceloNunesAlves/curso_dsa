# Solução Lista 3 de Exercícios em R

# Diretório de trabalho
setwd("~/Dropbox/DSA/AnaliseEstatisticaI/Modulo04/Lista3")
getwd()


# Carrega o dataset
data <- read.csv("dataset.csv")
View(data)
str(data)

# 1-	Qual o tempo médio de atendimento?
duration = data$tempo_telefone
mean(duration)


# 2-	Qual a mediana do tempo de atendimento?
duration = data$tempo_telefone
median(duration)

# 3-	Qual o desvio padrão e variância do tempo de atendimento?
duration = data$tempo_telefone
sd(duration)
var(duration)

# 4-	Quais os quartis e percentis 32, 57 e 98 do tempo de atendimento?
duration = data$tempo_telefone
quantile(duration)  
quantile(duration, c(.32, .57, .98)) 

# 5-	Qual o intervalo interquartil do tempo de atendimento?
IQR(duration)    

# 6-	Crie um boxplot que represente as medidas anteriores.
boxplot(duration, horizontal=TRUE) 

# 7- Calcule a covariância entre o tempo de atendimento e o total de clientes.
duration = data$tempo_telefone    
clientes = data$clientes       
cov(duration, clientes) # Indica uma relação linear positiva entre as duas variáveis.

# 8-	Calcule a Frequência Absoluta da variável tempo de atendimento.
duration = data$tempo_telefone
range(duration) 

# Frequência Absoluta
breaks = seq(1.5, 5.5, by=0.5)    
breaks 
duration.cut = cut(duration, breaks, right=FALSE)
duration.freq = table(duration.cut)
duration.freq 
cbind(duration.freq) 

# 9-	Crie um histograma que represente sua resposta no item anterior.
duration = data$tempo_telefone
hist(duration, right=FALSE)

colors = c("red", "yellow", "green", "violet", "orange", "blue", "pink", "cyan") 
hist(duration, right=FALSE, col=colors, main="Tempo de Atendimento x Total de Clientes", xlab="Duração em Minutos")   

# 10-	Calcule a Frequência Relativa e Acumulada da variável tempo de atendimento.
duration = data$tempo_telefone
breaks = seq(1.5, 5.5, by=0.5) 

# Relativa
duration.cut = cut(duration, breaks, right=FALSE) 
duration.freq = table(duration.cut)
duration.freq
duration.relfreq = duration.freq / nrow(data)
duration.relfreq 

options(digits=1) 
duration.relfreq 
cbind(duration.freq, duration.relfreq) 

# Acumulada
duration.cumfreq = cumsum(duration.freq)
duration.cumfreq 
cbind(duration.cumfreq) 

# 11-	Crie um gráfico de linha para a Frequência Acumulada.
cumfreq0 = c(0, cumsum(duration.freq)) 
plot(breaks, cumfreq0, main="Tempo de Atendimento x Total de Clientes", xlab="Duração em Minutos",  ylab="Total Clientes") 
lines(breaks, cumfreq0)  

# 12-	Crie um gráfico de dispersão para representar a relação entre as duas variáveis no dataset.
duration = data$tempo_telefone    
clientes = data$clientes       
plot(duration, clientes, xlab="Tempo de Atendimento", ylab="Total Clientes")



