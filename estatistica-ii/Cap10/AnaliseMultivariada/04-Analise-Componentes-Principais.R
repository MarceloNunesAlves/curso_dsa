# Projeto de Análise Multivariada - Por Que os Clientes Cancelam Seus Planos de Assinatura Mensal?

# Análise de Componentes Principais

# A Análise de Componentes Principais ou PCA (Principal Component Analysis) é uma técnica de análise 
# multivariada que pode ser usada para analisar inter-relações entre um grande número de variáveis 
# e explicar essas variáveis em termos de suas dimensões inerentes (Componentes).

# O objetivo é encontrar um meio de condensar a informação contida em diversas variáveis originais 
# em um conjunto menor de variáveis estatísticas (componentes) com uma perda mínima de informação.

# O número de componentes principais se torna o número de variáveis consideradas na análise, 
# mas geralmente as primeiras componentes são as mais importantes já que explicam a maior parte 
# da variação total.

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap10")

# Pacotes
install.packages('PerformanceAnalytics')
install.packages("mnormt")
install.packages('psych')
install.packages('GPArotation')
library(PerformanceAnalytics)
library(psych)
library(GPArotation)
library(car)
options(warn = -1)

# Carregando os dados
clientes <- read.csv("dados/clientes.csv")
dim(clientes)
str(clientes)
View(clientes)

# Checando por valores NA
sapply(clientes, function(x) sum(is.na(x)))

# Removemos os registros com valores NA
clientes <- clientes[complete.cases(clientes),] 
sapply(clientes, function(x) sum(is.na(x)))
dim(clientes)
str(clientes)

# Criamos um dataframe a partir das 3 variáveis quantitativas
names(clientes)
clientes_var_num <- data.frame(clientes$Fidelidade, clientes$CobrancaMensal, clientes$CobrancaTotal)
str(clientes_var_num)
View(clientes_var_num)

# Vamos verificar a correlação entre as variáveis
?chart.Correlation
chart.Correlation(clientes_var_num, method = c("pearson"), histogram = TRUE, pch = "19", cex = 0.7)

# Aplicando o PCA
?prcomp
modelo_pca <- prcomp(clientes_var_num, scale = TRUE)
modelo_pca

# Verificando o percentual de variância explicada em cada componente
covar <- modelo_pca$sdev ^ 2
names(covar) <- paste("PC", 1:3, sep = "")
propvar <- covar/sum(covar)
propvar

# O PC1 explica 73% da variância e PC2 explica 25% da variância.
# PC1 e PC2 juntos explicam aproximadamente 98% da variância das 3 variáveis.
# Podemos usar apenas PC1 e PC2 para qualquer análise posterior.

# Sumário do modelo
summary(modelo_pca)

# Valores originais
View(clientes_var_num)

# Valores das observações após aplicar o PCA
View(modelo_pca$x)

# Plot da variância explicada por cada componente
plot(modelo_pca)

# Identificando os Scores para cada cliente
names(clientes)
cliente_pca <- cbind(data.frame(clientes$ClienteChurn), modelo_pca$x)
View(cliente_pca)

# Plot dos scores de PC1 e PC2
plot(cliente_pca$PC1, 
     cliente_pca$PC2, 
     pch = ifelse(cliente_pca$Churn == "Yes", 1, 16),
     xlab = "PC1", 
     ylab = "PC2", 
     main = "Dataset Reduzido a PC1 & PC2",
     col = c(1, 2))

abline(h=0)
abline(v=0)
?legend
legend("bottomleft", legend = c("Sim", "Não"), pch = c(1,16), col = c(1, 2))

# Médias de scores para todos os componentes de cada classe da variável alvo
# Observe que duas médias são significantemente diferentes 
cliente_pca_media <- aggregate(cliente_pca[,-1], by = list(Churn = clientes$ClienteChurn), mean)
View(cliente_pca_media)

# Vamos ajustar o shape
cliente_pca_media <- cliente_pca_media[rev(order(cliente_pca_media$Churn)),]
cliente_pca_media
cliente_pca_media_t <- t(cliente_pca_media[,-1])
cliente_pca_media_t
colnames(cliente_pca_media_t) <- t(as.vector(cliente_pca_media[1]))
View(cliente_pca_media_t)

# Observe que para o PC3 a diferença entre as médias é muito pequena, indicando que
# esse componente é indiferente para o cancelamento ou não da assinatura.
# PC1 e PC2 tem diferenças significativas nas médias, indicando que fazem a diferença
# no cancelamento da assinatura.

# Desvio padrão dos scores para todos os componentes de cada classe da variável alvo
cliente_pca_sd <- aggregate(cliente_pca[,-1], by = list(clientes$ClienteChurn), sd)
cliente_pca_sd_t <- t(cliente_pca_sd[,-1])
colnames(cliente_pca_sd_t) <- t(as.vector(cliente_pca_sd[1]))
cliente_pca_sd_t

# Teste t

# Na Análise de Componentes Principais (PCA), os primeiros poucos componentes principais possivelmente 
# revelam padrões sistemáticos interessantes nos dados, enquanto os últimos podem refletir ruído aleatório. 

# O analista pode se perguntar quantos componentes principais são estatisticamente significativos. 
# É o que vamos responder com o teste t.

# A significância estatística é usada para fornecer evidências a respeito da plausibilidade da hipótese 
# nula, a hipótese de que não há nada além de chance aleatória no relacionamento dos dados.

# H0 = a diferença entre as médias é igual a zero (chance aleatória no relacionamento dos dados).
# H1 = a diferença entre as médias não é igual a zero (algum outro fator explica o relacionamento dos dados)..

# Um valor-p baixo (normalmente ≤ 0,05) indica forte evidência contra a H0; portanto, você rejeita a H0.
# Um valor-p alto (> 0,05) indica evidência fraca contra a H0; portanto, você falha em rejeitar a H0.

View(cliente_pca)
?t.test
t.test(PC1 ~ clientes$ClienteChurn, data = cliente_pca)
t.test(PC2 ~ clientes$ClienteChurn, data = cliente_pca)
t.test(PC3 ~ clientes$ClienteChurn, data = cliente_pca)
t.test(PC1+PC2 ~ clientes$ClienteChurn, data = cliente_pca)
t.test(PC1+PC2+PC3 ~ clientes$ClienteChurn, data = cliente_pca)
t.test(PC2+PC3 ~ clientes$ClienteChurn, data = cliente_pca)
t.test(PC1+PC3 ~ clientes$ClienteChurn, data = cliente_pca)

# Rejeitamos a H0 indicando que todos os componentes principais são estatisticamente significativos, em 
# nosso exemplo.

# A significância estatística é uma determinação de um analista de que os resultados nos dados não são 
# explicáveis apenas por acaso. O teste de hipótese estatística é o método pelo qual o analista faz essa 
# determinação. Esse teste fornece um valor-p, que é a probabilidade de observar resultados tão extremos 
# quanto dos dados da amostra, assumindo que os resultados sejam realmente devido apenas ao acaso. 
# Um valor-p de 5% ou menos é geralmente considerado estatisticamente significativo.

# A significância estatística é a probabilidade de que um relacionamento entre duas ou mais variáveis seja 
# causado por algo diferente do acaso.

# O teste de hipótese estatística é usado para determinar se o resultado de um conjunto de dados é 
# estatisticamente significativo.

# Teste de Levene

# Testando a homogeneidade da variância através dos grupos

?leveneTest

# Desativando notação científica
?options
options(scipen = 999)

# Ativando notação científica (padrão)
options(scipen = -1)

LTPC1 <- leveneTest(PC1 ~ clientes$ClienteChurn, data = cliente_pca)
valor_p_PC1_1sided <- LTPC1[[3]][1]/2
valor_p_PC1_1sided

LTPC2 <- leveneTest(PC2 ~ clientes$ClienteChurn, data = cliente_pca)
valor_p_PC2_1sided <- LTPC2[[3]][1]/2
valor_p_PC2_1sided

LTPC3 <- leveneTest(PC3 ~ clientes$ClienteChurn, data = cliente_pca)
valor_p_PC3_1sided <- LTPC3[[3]][1]/2
valor_p_PC3_1sided


# Conclusão do Projeto e Lab com Feedback
# Projeto de Análise Multivariada - Por Que os Clientes Cancelam Seus Planos de Assinatura Mensal?

# Agora é com você!

# Como forma de praticar tudo que estudamos até aqui, construa um relatório explicando para a área de 
# negócio as suas conclusões sobre as razões que levam um cliente a cancelar uma assinatura.

# Como você apresentaria isso para o tomador de decisão? No formato de um relatório no Word ou no formato
# de uma apresentação no PowerPoint? A escolha é sua.

# E como você justificaria as suas conclusões?

# Essa atividade é opcional e se quiser o feedback, envie seu relatório para projeto@dsacademy.com.br que
# nós avaliamos seu trabalho!





