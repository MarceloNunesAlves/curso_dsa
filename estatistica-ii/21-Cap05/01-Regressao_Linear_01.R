# Construindo um Modelo de Regressão Linear

# Definindo o diretório de trabalho
# setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap05")
# getwd()


##### Preparação dos Dados #####

# Para reproduzir os mesmos resultados
set.seed(10)

# Gerando dados aleatórios para a primeira variável de entrada (X1)
datax1 = runif(1000) * 100 

# Gerando dados aleatórios para a segunda variável de entrada (X2)
datax2 = datax1 + runif(1000) * 100 

# Gerando dados para o valor da variável y
datay = 40 + datax2 + datax1 + rnorm(1000,0,20) 

# Preparando os dados para modelagem preditiva
model_data = data.frame(cbind(datay, datax1, datax2)) 
View(model_data)


##### Modelo de Regressão Linear com a função lm() #####

# Criando um modelo de regressão linear com a função lm()
?lm
modelo_v1 <- lm(datay ~ datax1 + datax2, data = model_data)
summary(modelo_v1)


##### Modelo de Regressão Linear com Cálculos de Matrizes #####

# Ajustando o formato de X e Y
X              = as.matrix(model_data[c("datax1","datax2")]) 
X              = cbind(rep(1,1000),X) 
colnames(X)[1] = "intercept" 
Y              = as.matrix(model_data["datay"])

View(X)
View(Y)

# Cálculo de matrizes para encontrar beta
beta = solve(t(X) %*% X) %*% (t(X) %*% Y) 
print(beta)

# Previsões
previsoes = X %*% beta  
head(previsoes)

# Cálculo dos Resíduos
residuos = previsoes - Y 
View(residuos)

# Desvio padrão dos resíduos
?var
desviop = var(residuos)[1] 
desviop

# Matriz de covariância
# Finalmente, calculamos a matriz de covariância para os coeficientes beta. 
# Observe que os elementos diagonais contêm as variâncias e os elementos fora da diagonal 
# contêm as covariâncias. Se as variáveis estiverem correlacionadas, os elementos fora da 
# diagonal ficarão maiores - e se ficarem grandes demais, a matriz não será invertível.
cov_matrix = solve(t(X) %*% X ) * desviop 
diag(cov_matrix) = sqrt(diag(cov_matrix)) 

# Os erros padrão para nossos coeficientes são os seguintes 
# (observe que obviamente correspondem aos relatados pela função lm):
print(paste("Erro Padrão:", diag(cov_matrix))) 



