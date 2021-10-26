# Usando Bootstrap Para Estimar o Intervalo de Confiança de Um Modelo de Regressão Linear 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# Criando um modelo linear (ignorando medidas repetidas!)
# Prevemos o peso dos frangos com base nas variáveis tempo e dieta
?ChickWeight
View(ChickWeight)
?lm
modelo1 <- lm(weight ~ Time * Diet, data = ChickWeight)
modelo1

# Criamos o dataframe para servir como dados de teste (Estamos interessados em Tempo = 15)
dados_teste <- data.frame(Time = 15, Diet = levels(ChickWeight$Diet))
View(dados_teste)

# Previsões a partir do modelo
?predict
previsoes <- predict(modelo1, dados_teste, se = TRUE)
View(previsoes)

# Inspecione os SEs estimados:
previsoes$se.fit

# Agora fazemos o mesmo usando o bootstrap. 
# Ao inicializar, nós fazemos uma nova amostra de nossos dados, ajustamos o modelo e repetimos. 
# Isso é bastante fácil de escrever com lapply ou similar, mas também podemos usar o bootCase do pacote car.

# Carrega o pacote car
# install.packages("car")
library(car)

# Boostrap do modelo 999 vezes, aplicando uma função a cada vez. 
# Neste caso, prevemos a partir do modelo.
?bootCase
bootfit1 <- bootCase(modelo1, function(x) predict(x, dados_teste), B = 999)
View(bootfit1)

# Ao inspecionar o bootfit1, verá que é uma matriz com 999 linhas e quatro colunas (as Dietas).
# Obtenha os desvios padrão por coluna:
apply(bootfit1, 2, sd)

# Esses quatro valores são o SE do valor previsto do peso do frango no Tempo = 15. 
# Em comparação com os que calculamos com o método de previsão acima, eles são muito maiores.
# Particularmente no caso de variância não constante, os SEs calculados por predict (e lm) 
# são muito pequenos (tecnicamente este é o caso quando a variância aumenta, o que é bem típico).

# Quando suas suposições de regressão forem violadas e você não conseguir encontrar uma solução, 
# use o bootstrap, pois os erros padrão calculados serão válidos.

# Finalmente, repetimos o experimento anterior usando um modelo de efeitos mistos. 
# A abordagem é idêntica, apenas os detalhes são diferentes. 
# Isso pode demorar um pouco em uma máquina mais lenta.

# Pacotes
# install.packages("lme4")
# install.packages("lmerTest")
library(lme4)
library(lmerTest)

# Os mesmos frangos foram pesados, então temos uma estrutura clara de efeitos aleatórios 
# (porque as pesagens não são observações independentes). 
# Suponha que eu esteja interessado em peso no tempo = 15 por algum motivo e queira testar se 
# as dietas têm um efeito significativo no peso naquele momento. 
# Se eu estivesse interessado apenas no tempo = 0, eu poderia estudar a intercepção ajustada do modelo 
# e, se estivesse interessado em alguma média centralizada, poderia usar meios de mínimos quadrados. 
# Mas neste caso eu posso usar a função predict().

# Recriamos o modelo
# Modelos mistos lineares (Linear mixed models) são uma extensão de modelos lineares simples 
# para permitir efeitos fixos e aleatórios, e são particularmente usados quando não há independência 
# nos dados, como surge de uma estrutura hierárquica. Por exemplo, os alunos podem ser amostrados de 
# dentro de salas de aula ou pacientes de dentro de consultórios médicos.
?lmer
modelo2 <- lmer(weight ~ Time * Diet + (Time|Chick), data = ChickWeight)

# bootMer do pacote lme4 é semelhante ao bootCase do pacote car
# Certifique-se de definir re.form = NA para gerar apenas previsões usando os efeitos fixos.
bootfit2 <- bootMer(modelo2, FUN = function(x) predict(x, dados_teste, re.form=NA), nsim=999)

# O elemento $t contém as previsões geradas pelo bootMer.
apply(bootfit2$t, 2, sd)

# Mais uma vez, os erros padrão das previsões são ainda maiores. 
# Isso faz sentido porque incluímos o efeito de frango aleatório no modelo. 
# A incerteza adicionada vem do fato de que os frangos diferem muito em peso no tempo = 15, 
# e essa incerteza tem um efeito sobre as estimativas dos efeitos fixos também 
# (o que, por sua vez, afeta o peso previsto dos frangos no tempo = 15).

# Finalmente, em vez de apenas prever no Tempo = 15, agora é fácil prever o intervalo inteiro dos dados, 
# para que possamos traçar intervalos de confiança em torno da previsão.

# Primeiro, precisamos de uma função que trace um polígono se dermos três vetores: 
# X, y1 (a parte superior do intervalo de previsão) e y2 (a extremidade inferior). 

# Scales
library(scales)

# Função para adicionar um polígono se tivermos um vetor X e dois vetores Y de mesmo comprimento.
addpoly <- function(x,y1,y2,col=alpha("lightgrey",0.8),...){
  ii <- order(x)
  y1 <- y1[ii]
  y2 <- y2[ii]
  x <- x[ii]
  polygon(c(x,rev(x)), c(y1, rev(y2)), col=col, border=NA,...)
}

# Vamos refazer o bootstrap, pois desta vez queremos previsões para todos os valores de Tempo. 
# Se chamarmos predict sem um argumento de dados, ele preverá todos os valores X usados ao ajustar o modelo.
bb <- bootMer(modelo2, FUN = function(x) predict(x, re.form = NA), nsim=500)

# Calcumaos quantiles de previsões de replicações de bootstrap.
# Estes representam o intervalo de confiança da média em qualquer valor de tempo.
ChickWeight$lci <- apply(bb$t, 2, quantile, 0.025)
ChickWeight$uci <- apply(bb$t, 2, quantile, 0.975)
ChickWeight$weightpred <- predict(modelo2, re.form=NA)

# Vamos apenas plotar uma dieta para ilustração
dat <- subset(ChickWeight, Diet == "1")

# Plot
with(dat, {
  plot(Time,weight)
  addpoly(Time, lci, uci)
  lines(Time, weightpred)
})
