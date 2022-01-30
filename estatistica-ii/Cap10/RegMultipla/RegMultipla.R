# Análise de Regressão Linear Múltipla

# Definição do Problema - Quais Fatores Mais Relevantes Para Prever o Lucro de Uma Startup?

# Nosso dataset terá dados de despesas em diferentes segmentos 
# (Administração, Marketing e Pesquisa&Desenvolvimento)

# Nosso trabalho é compreender quais fatores (ou qual fator) podemos usar para prever o lucro de uma Startup.

# Interpretação do Modelo de Regressão em R

# Equação de Regressão
# y = a + bx (simples)
# y = a + b0 x v0 + b1 x v1 (múltipla)

# Resíduos
# Diferença entre os valores observados de uma variável e seus valores previstos
# Seus resíduos devem se parecer com uma distribuição normal, o que indica
# que a média entre os valores previstos e os valores observados é próximo de 0 (o que é bom)

# Coeficiente - Intercept - a (alfa)
# Valor de a na equação de regressão

# Coeficientes - Nomes das variáveis - b (beta)
# Valor de b na equação de regressão

# Obs: A questão é que lm() ou summary() têm diferentes convenções de 
# rotulagem para cada variável explicativa. 
# Em vez de escrever slope_1, slope_2, .... 
# Eles simplesmente usam o nome da variável em qualquer saída para 
# indicar quais coeficientes pertencem a qual variável.

# Erro Padrão
# Medida de variabilidade na estimativa do coeficiente a (alfa) e b (beta). 
# O ideal é que este valor seja menor que o valor do coeficiente, mas nem sempre 
# isso irá ocorrer.

# Asteriscos 
# Os asteriscos representam os níveis de significância de acordo com o p-value.
# Quanto mais estrelas, maior a significância.
# Atenção --> Muitos astericos indicam que é improvável que não exista 
# relacionamento entre as variáveis.

# Valor t
# Define se coeficiente da variável é significativo ou não para o modelo. 
# Ele é usado para calcular o p-value e os níveis de significância.

# p-value
# O p-value representa a probabilidade que a variável não seja relevante. 
# Deve ser o menor valor possível. 
# Se este valor for realmente pequeno, o R irá mostrar o valor 
# como notação científica

# Em regressão linear, o valor-p define o resultado para o teste de hipótese:

# H0: Não há relacionamento significante entre a variável preditora x e a variável target y.
# H1: Há relacionamento significante entre a variável preditora x e a variável target y.

# Se valor-p > 0.05 indica que não há evidência estatística para rejeitar H0. Falhamos em rejeitar a H0.
# Se valor-p < 0.05 indica que há evidência estatística para rejeitar H0.

# Significância
# São aquelas legendas próximas as suas variáveis
# Espaço em branco - ruim
# Pontos - razoável
# Asteriscos - bom
# Muitos asteriscos - muito bom

# Residual Standard Error
# Este valor representa o desvio padrão dos resíduos

# Degrees of Freedom
# É a diferença entre o número de observações na amostra de treinamento 
# e o número de variáveis no seu modelo.

# R-squared (coeficiente de determinação - R^2)
# Ajuda a avaliar o nível de precisão do nosso modelo. 
# Quanto maior, melhor, sendo 1 o valor ideal.

# F-statistics
# É o teste F do modelo. Esse teste obtém os parâmetros do nosso modelo 
# e compara com um modelo que tenha menos parâmetros.
# Em teoria, um modelo com mais parâmetros tem um desempenho melhor. 

# Se o seu modelo com mais parâmetros NÃO tiver perfomance
# melhor que um modelo com menos parâmetros, o valor do p-value será bem alto. 

# Se o modelo com mais parâmetros tiver performance
# melhor que um modelo com menos parâmetros, o valor do p-value será mais baixo.

# Lembre-se que correlação não implica causalidade

# Carregando e Compreendendo os Dados

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap10/RegMultipla")

# Pacotes
install.packages('caTools')
install.packages('sjPlot')
install.packages("ggpubr")
install.packages("corrplot")
install.packages("DMwR")
install.packages("broom")
library(caTools)
library(sjPlot) 
library(ggpubr)
library(corrplot)
library(DMwR)
library(ggplot2)
library(broom)

# Carregando os dados
df_startup = read.csv('dados/dataset.csv')
dim(df_startup)
str(df_startup)
View(df_startup)
names(df_startup)

# Calculamos a correlação entre as variáveis
?cor
cor(df_startup)

?corrplot
cor_df_startup <- cor(df_startup)
corrplot(cor_df_startup)

# Dividindo os dados em treino e teste
set.seed(123)
?sample.split
split = sample.split(df_startup$Lucro, SplitRatio = 0.8)
?base::subset
dados_treino = subset(df_startup, split == TRUE)
dados_teste = subset(df_startup, split == FALSE)
dim(dados_treino)
dim(dados_teste)

# Padronização das variáveis (somente variáveis preditoras)
names(df_startup)
?scale
dados_treino_scaled = scale(dados_treino[,c(1,2,3)])
dados_teste_scaled = scale(dados_teste[,c(1,2,3)])

# Verificando tipos de objetos
class(df_startup)
class(dados_treino_scaled)
class(dados_teste_scaled)

# Converte para dataframe
df_treino = as.data.frame(dados_treino_scaled)
df_teste = as.data.frame(dados_teste_scaled)

# Visualiza
View(df_treino)
View(df_teste)

#  Concatena X e Y
df_treino <- cbind(df_treino, dados_treino[,c(4)])
df_teste <- cbind(df_teste, dados_teste[,c(4)])
dim(df_treino)
dim(df_teste)

# Visualiza
View(df_treino)
View(df_teste)

# Ajusta o nome das colunas
names(df_treino)
names(df_teste)
colnames(df_treino) <- c("Despesa_PD", "Despesa_Admin", "Despesa_Marketing", "Lucro")
colnames(df_teste) <- c("Despesa_PD", "Despesa_Admin", "Despesa_Marketing", "Lucro")
names(df_treino)
names(df_teste)

# Construindo o modelo de Regressão Linear Múltipla
# modelo_v1 = lm(formula = Lucro ~ Despesa_PD + Despesa_Admin + Despesa_Marketing, data = df_treino)
modelo_v1 = lm(formula = Lucro ~ ., data = df_treino)
summary(modelo_v1)

# Interpretando o resultado com relatório HTML
?tab_model
tab_model(modelo_v1) 

# Calcula o RMSE (Root Mean Squared Error)
sqrt(mean(modelo_v1$residuals^2))

# Análise dos resíduos
?resid
?qqnorm
resid(modelo_v1)
qqnorm(resid(modelo_v1))
qqline(resid(modelo_v1))
hist(resid(modelo_v1))
plot(modelo_v1)

# Unscale
?unscale
df_treino_orig <- unscale(df_treino[,-c(4)], dados_treino_scaled)
df_treino_res <- as.data.frame(df_treino_orig)
df_treino_res$Lucro_Real <- df_treino[,c(4)]
df_treino_res$Lucro_Previsto <- predict(modelo_v1)
df_treino_res$Residuo <- residuals(modelo_v1)
View(df_treino_res)

# Gráfico dos resíduos
names(df_treino_res)

# Gráfico com o Regressor Despesa_PD
ggplot(df_treino_res, aes(x = Despesa_PD, y = Lucro_Real)) +
  geom_segment(aes(xend = Despesa_PD, yend = Lucro_Previsto), alpha = .2) +  
  geom_point(aes(color = Residuo)) + 
  scale_color_gradient2(low = "blue", mid = "white", high = "red") +
  guides(color = FALSE) +
  geom_point(aes(y = Lucro_Previsto), shape = 1) +  
  theme_bw()

# Gráfico com o Regressor Despesa_Admin
ggplot(df_treino_res, aes(x = Despesa_Admin, y = Lucro_Real)) +
  geom_segment(aes(xend = Despesa_Admin, yend = Lucro_Previsto), alpha = .2) +  
  geom_point(aes(color = Residuo)) + 
  scale_color_gradient2(low = "blue", mid = "white", high = "red") +
  guides(color = FALSE) +
  geom_point(aes(y = Lucro_Previsto), shape = 1) +  
  theme_bw()

# Gráfico com o Regressor Despesa_Marketing
ggplot(df_treino_res, aes(x = Despesa_Marketing, y = Lucro_Real)) +
  geom_segment(aes(xend = Despesa_Marketing, yend = Lucro_Previsto), alpha = .2) +  
  geom_point(aes(color = Residuo)) + 
  scale_color_gradient2(low = "blue", mid = "white", high = "red") +
  guides(color = FALSE) +
  geom_point(aes(y = Lucro_Previsto), shape = 1) +  
  theme_bw()

# Relatório com a lib Broom
modelo_v1_report = lm(formula = Lucro ~ ., data = df_treino) %>% 
  augment()

# Relatório da regressão
View(modelo_v1_report)

# Plot
ggplot(modelo_v1_report, aes(x = Despesa_PD, y = Lucro)) +
  geom_smooth(method = "lm", se = FALSE, color = "lightgrey") +
  geom_segment(aes(xend = Despesa_PD, yend = .fitted), alpha = .2) + 
  geom_point(aes(alpha = abs(.resid))) + 
  guides(alpha = FALSE) +
  geom_point(aes(y = .fitted), shape = 1) +  
  theme_bw()

# Previsões com os dados de teste
y_pred_v1 = predict(modelo_v1, newdata = df_teste)
y_pred_v1

# Sumário do modelo
summary(modelo_v1)
numVars = length(df_treino)
numVars
max(coef(summary(modelo_v1))[1, "Pr(>|t|)"])
max(coef(summary(modelo_v1))[2, "Pr(>|t|)"])
max(coef(summary(modelo_v1))[3, "Pr(>|t|)"])
max(coef(summary(modelo_v1))[4, "Pr(>|t|)"])

# Encontrando o modelo ideal através da eliminação inversa (Backward Elimination)
# Função para Backward Elimination
backwardElimination <- function(x, sl) {
  numVars = length(x)
  for (i in c(1:numVars)){
    regressor = lm(formula = Lucro ~ ., data = x)
    maxVar = max(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"])
    if (maxVar > sl){
      j = which(coef(summary(regressor))[c(2:numVars), "Pr(>|t|)"] == maxVar)
      x = x[, -j]
    }
    numVars = numVars - 1
  }
  return(summary(regressor))
}

# Aplica a função considerando valor-p de 0.05
valor_p = 0.05
backwardElimination(df_treino, valor_p)

# Criando a versão final do modelo
modelo_v2 = lm(formula = Lucro ~ Despesa_PD, data = df_treino)
summary(modelo_v2)

# Calcula o RMSE
sqrt(mean(modelo_v2$residuals^2))

# Análise dos resíduos
resid(modelo_v2)
qqnorm(resid(modelo_v2))
qqline(resid(modelo_v2))
hist(resid(modelo_v2))
plot(modelo_v2)

# Previsões com dados de teste
y_pred_v2 = predict(modelo_v2, newdata = df_teste)
y_pred_v2

# Compara valores reais com valores previstos
?unscale
unsc_Despesa_PD <- unscale(df_teste$Despesa_PD, dados_teste_scaled)
df_analise <- cbind(unsc_Despesa_PD, df_teste$Lucro)
df_analise <- cbind(df_analise, y_pred_v2)
colnames(df_analise) <- c("Despesa_PD", "Lucro_Real", "Lucro_Previsto")
View(df_analise)
class(df_analise)
df_analise <- as.data.frame(df_analise)
class(df_analise)
plot(df_analise$Despesa_PD, df_analise$Lucro_Real)
plot(df_analise$Despesa_PD, df_analise$Lucro_Previsto)

# Previsões com novos dados
Despesa_PD <- c(79364.09, 157314.12, 58236.35)
Despesa_PD <- scale(Despesa_PD)
Despesa_PD <- as.data.frame(Despesa_PD)
colnames(Despesa_PD) <- c("Despesa_PD")
lucro = predict(modelo_v2, newdata = Despesa_PD)
lucro

# Fim
