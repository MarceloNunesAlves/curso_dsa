# Análise Estatística Para Data Science II
# Estudo de Caso 3
# Impacto da Regularização LASSO, Ridge e Elastic Net em Modelos Support Vector Machines

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap11/RegressaoLogistica")

# Fonte de dados:
# https://archive.ics.uci.edu/ml/machine-learning-databases/00350

# Pacotes
library(MASS)
library(ISLR)
library(e1071)
library(penalizedSVM)
library(sparseSVM)

# Carregando os dados
dados = read.csv("dados/dataset.csv", skip = 1, header = TRUE)
str(dados)
dim(dados)
View(dados)

# Engenharia de Atributos
# Criamos uma nova coluna chamada y, sendo:
# 1 = não pagou o cartão de crédito (inadimplente)
# -1 = pagou o cartão de crédito (não inadimplente)
dados$y = ifelse(dados$default.payment.next.month == 0, -1, 1)
View(dados)

# Checando a proporção de classe
table(dados$y)

barplot(prop.table(table(dados$y)),
        col = rainbow(2),
        ylim = c(0,0.8),
        ylab = "Proporção",
        xlab = "Pagamento do Cartão",
        cex.names = 1.5)

# Remove a coluna de ID
colnames(dados)
dados$ID <- NULL

# Converte para matriz a fim de facilitar a divisão em dados de treino e teste
dados = as.matrix(dados)
dimnames(dados) = NULL
set.seed(1)

# Divisão em dados de treino e teste

# Índice para divisão
indice = sample(2, nrow(dados), replace = T, prob = c(0.7,0.3))

# Geração dos datasets
dim(dados)
dados_treino = dados[indice==1, 1:23]
dados_teste = dados[indice==2, 1:23]
target_treino = dados[indice==1, 25]
target_teste = dados[indice==2, 25]

# Geração dos dataframes
df_treino = data.frame(x = dados_treino, y = as.factor(target_treino))
df_teste = data.frame(x = dados_teste,  y = as.factor(target_teste))

View(df_treino)
View(df_teste)
dim(df_treino)
dim(df_teste)

# Modelagem

# Obs: Para evitar erro de memória, apague os objetos que não estiverem mais sendo usados na sessão
rm(dados, dados_treino, dados_teste, indice)

# Outra opção é aumentar a memória disponível para o interpretador R (somente em último caso)
# Sys.setenv('R_MAX_VSIZE'=12000000000)

# Primeiro aplicaremos o modelo SVM sem nenhuma customização
?svm
modelo_v1 = svm(y ~ ., data = df_treino)
summary(modelo_v1)
modelo_v1$index

# Avaliação do modelo (dados de treino)
table(modelo_v1$fitted, df_treino$y)

# Avaliação do modelo (dados de teste)
ypred_v1 = predict(modelo_v1, df_teste)
tab_v1 = table(previsão = ypred_v1, real = df_teste$y)
tab_v1

#  Acurácia e erro do modelo
acuracia_v1 = sum(diag(tab_v1)) / sum(tab_v1)
erro_v1 = 1 - acuracia_v1

# Print
print(acuracia_v1)
print(erro_v1)

# Na segunda versão do modelo SVM aplicaremos regularização com a norma L2
# O cálculo do comprimento ou magnitude dos vetores geralmente é necessário diretamente como um 
# método de regularização no aprendizado de máquina ou como parte de operações mais amplas de 
# vetor ou matriz.
# A norma L1 que é calculada como a soma dos valores absolutos do vetor/matriz.
# A norma L2 que é calculada como a raiz quadrada da soma dos valores do vetor/matriz ao quadrado.
?svm
modelo_v2 = svm(y ~ ., data = df_treino, kernel = "radial", gamma = 20, cost = 100)
summary(modelo_v2)

# Avaliação do modelo (dados de treino)
table(modelo_v2$fitted, df_treino$y)

# Avaliação do modelo (dados de teste)
ypred_v2 = predict(modelo_v2, df_teste)
tab_v2 = table(previsão = ypred_v2, real = df_teste$y)
tab_v2

#  Acurácia e erro do modelo
acuracia_v2 = sum(diag(tab_v2)) / sum(tab_v2)
erro_v2 = 1 - acuracia_v2

# Print
print(acuracia_v2)
print(erro_v2)

# Otimização de hiperparâmetros para encontrar os melhores valores de gamma e cost
set.seed(1)
?tune
otimiza_hiper_1 = tune(svm, 
                       y ~ ., 
                       data = df_treino, 
                       kernel = "radial", 
                       ranges = list(cost = c(1,10,1000),
                                     gamma = c(0.01,10,100)))

summary(otimiza_hiper_1)
modelo_v3 = otimiza_hiper_1$best.model
summary(modelo_v3)

# Avaliação do modelo (dados de treino)
table(modelo_v3$fitted, df_treino$y)

# Avaliação do modelo (dados de teste)
ypred_v3 = predict(modelo_v3, df_teste)
tab_v3 = table(previsão = ypred_v3, real = df_teste$y)
tab_v3

#  Acurácia e erro do modelo
acuracia_v3 = sum(diag(tab_v3)) / sum(tab_v3)
erro_v3 = 1 - acuracia_v3

# Print
print(acuracia_v3)
print(erro_v3)

# Qual o Número Ideal de Vetores de Suporte?
modelo_v1$tot.nSV # 9199
modelo_v2$tot.nSV # 20653
modelo_v3$tot.nSV # 8605

# Vamos mudar o kernel
otimiza_hiper_2 = tune(svm, 
                       y ~ ., 
                       data = df_treino, 
                       kernel = "linear", 
                       ranges = list(cost = c(0.01, 0.1, 1, 10)))

summary(otimiza_hiper_2)
modelo_v4 = otimiza_hiper_2$best.model
summary(modelo_v4)

# Avaliação do modelo (dados de treino)
table(modelo_v4$fitted, df_treino$y)

# Avaliação do modelo (dados de teste)
ypred_v4 = predict(modelo_v4, df_teste)
tab_v4 = table(previsão = ypred_v4, real = df_teste$y)
tab_v4

#  Acurácia e erro do modelo
acuracia_v4 = sum(diag(tab_v4)) / sum(tab_v4)
erro_v4 = 1 - acuracia_v4

# Print
print(acuracia_v4)
print(erro_v4)

# Qual o Número Ideal de Vetores de Suporte?
modelo_v1$tot.nSV # 9199
modelo_v2$tot.nSV # 20653
modelo_v3$tot.nSV # 8605
modelo_v4$tot.nSV # 11943

# Obs: Para evitar erro de memória, apague os objetos que não estiverem mais sendo usados na sessão
rm(ypred_v1, ypred_v2, ypred_v3, ypred_v4)
rm(tab_v1, tab_v2, tab_v3, tab_v4)
rm(erro_v1, erro_v2, erro_v3, erro_v4)
rm(acuracia_v1, acuracia_v2, acuracia_v3, acuracia_v4)
rm(erro_v1, erro_v2, erro_v3, erro_v4)
rm(modelo_v1, modelo_v2, modelo_v3, modelo_v4)
rm(otimiza_hiper_1, otimiza_hiper_2)
rm(df_treino)

#### Se necessário, feche o RStudio e abra novamente, executando a partir deste ponto #### 

# Como não podemos mais usar dataframes a partir daqui (e sim matrizes), carregamos os dados novamente
dados = read.csv("dados/dataset.csv", skip = 1, header = TRUE)
dados$y = ifelse(dados$default.payment.next.month == 0, -1, 1)
dados$ID <- NULL
dados = as.matrix(dados)
dimnames(dados) = NULL
set.seed(1)
indice = sample(2, nrow(dados), replace = T, prob = c(0.7,0.3))
dados_treino = dados[indice==1, 1:23]
dados_teste = dados[indice==2, 1:23]
target_treino = dados[indice==1, 25]
target_teste = dados[indice==2, 25]
rm(indice)
rm(dados)

# Estudo de Caso 3 - Versão 4 Alternativa
# Aplicando SVM com Norma L1 nos dados de treino
# Quinta versão do modelo
?svmfs
modelo_v4_alt = svmfs(x = dados_treino, 
                      y = target_treino, 
                      fs.method = "1norm",
                      cross.outer = 0, 
                      grid.search = "discrete",
                      lambda1.set = c(0.1,1,10), 
                      calc.class.weights = TRUE, 
                      class_weights = list("-1":1, "1":3),
                      parms.coding = "none", 
                      show = "none",
                      maxIter = 500, 
                      inner.val.method = "cv", 
                      cross.inner = 5,
                      seed = 1, 
                      verbose = FALSE )

summary(modelo_v4_alt)

# Avaliação do modelo (dados de treino)
table(modelo_v4_alt$fitted, df_treino$y)

# Avaliação do modelo (dados de teste)
ypred_v4_alt = predict(modelo_v4_alt, df_teste)
tab_v4_alt = table(previsão = ypred_v4_alt, real = df_teste$y)
tab_v4_alt

#  Acurácia e erro do modelo
acuracia_v4_alt = sum(diag(tab_v4_alt)) / sum(tab_v4_alt)
erro_v4_alt = 1 - acuracia_v4_alt

# Print
print(acuracia_v4_alt)
print(erro_v4_alt)

# Aplicando Elastic Net (Normas L1 + L2)
# Quinta versão do modelo
?cv.sparseSVM
modelo_v5 = cv.sparseSVM(X = dados_treino, 
                         y = target_treino, 
                         alpha = 0.5, 
                         gamma = 0.1, 
                         nlambda = 100,
                         lambda.min = 0.01,
                         nfolds = 5,
                         preprocess = c("standardize", "rescale", "none"),
                         max.iter = 1000, 
                         eps = 1e-5)

summary(modelo_v5)

# Número de variáveis selecionadas
dim(dados_treino)
predict(modelo_v5, df_teste, lambda = 0.01, type = c("nvars"), exact = FALSE) 

# Coeficientes de cada input
predict(modelo_v5, df_teste, lambda = 0.01, type = c("coefficients"), exact = FALSE)

# Plot
plot(modelo_v5)

# Usando o modelo para previsões com o valor ótimo de lambda = 0.01
ypred_v5 = predict(modelo_v5, dados_teste, lambda = 0.01)
tab_v5 = table(previsão = ypred_v5, real = df_teste$y)
tab_v5

#  Acurácia e erro do modelo
acuracia_v5 = sum(diag(tab_v5)) / sum(tab_v5)
erro_v5 = 1 - acuracia_v5

# Print
print(acuracia_v5)
print(erro_v5)

# Fim

