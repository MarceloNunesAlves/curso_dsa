# Trabalhando com Regressão Lasso

# Definindo o diretório de trabalho
# setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap05")
# getwd()

# Pacotes
install.packages("glmnet")
library(glmnet)
library(tidyr)
library(ggplot2)
library(dplyr)

# Seed
set.seed(100)

# Regularização L1 e L2

# A Regressão Lasso executa a regularização L1, que adiciona uma penalidade igual ao valor 
# absoluto da magnitude dos coeficientes. Esse tipo de regularização pode resultar em modelos 
# esparsos com poucos coeficientes; Alguns coeficientes podem se tornar zero e eliminados do modelo. 
# Penalidades maiores resultam em valores de coeficiente mais próximos de zero, o que é ideal 
# para produzir modelos mais simples. Por outro lado, a regularização de L2 (por exemplo, 
# Regressão Ridge) não resulta na eliminação de coeficientes ou modelos esparsos. 
# Isso torna o Lasso muito mais fácil de interpretar do que o Ridge.


# O acrônimo “LASSO” significa Least Absolute Shrinkage and Selection Operator.

# A Regressão Lasso é um tipo de regressão linear que usa retração (ou encolhimento - Shrinkage). 
# Encolhimento é quando os valores dos dados são reduzidos em direção a um ponto central, 
# como a média. O procedimento de Lasso incentiva modelos simples e esparsos (ou seja, modelos 
# com menos parâmetros). Esse tipo específico de regressão é adequado para modelos que mostram 
# altos níveis de muticolinearidade ou quando você deseja automatizar certas partes da seleção 
# de modelos, como seleção de variáveis / eliminação de parâmetros.


# Neste exemplo, seguiremos a mesma lógica do que fizemos em Regressão Ridge, mas usaremos 
# alpha = 1, forçando o glmnet a fazer o Lasso. Isso penalizará os coeficientes agora usando 
# a norma L1, o que significa que alguns dos coeficientes (os irrelevantes) serão empurrados 
# exatamente para zero. Portanto, alguns Cientistas de Dados usam o LASSO como uma ferramenta 
# de seleção de variáveis.


# Vamos construir um conjunto de dados para nossos testes. 
# Ele terá duas variáveis (V1 - V2) severamente correlacionadas. 
# E teremos outras duas variáveis (V3 - V4) também muito correlacionadas. 
# Teremos uma quinta variável que é independente de V1-V4. 

# Queremos comparar Ridge com mínimos quadrados comuns (regresão linear) e ver o que acontece 
# com esses dois pares de variáveis e para a variável V5. 

# Além disso, agruparemos tudo em uma função que plota um boxplot. 

# Nossa maneira preferida de fazer o Ridge é usar a função/pacote glmnet. 
# Isso nos permite fazer algo um pouco mais poderoso que o Ridge, chamado glmnet. 

# Na verdade, esse método é uma mistura de Ridge e Lasso (outra técnica de regressão penalizada, 
# que examinaremos na sequência). Temos até um parâmetro específico chamado alfa que controla 
# quanto Ridge / Lasso queremos.

regressao_func <- function(lambda){
  
  # Dataframe para os coeficientes
  coeffs_total = data.frame(V1=numeric(),V2=numeric(),V3=numeric(),V4=numeric(),V5=numeric())
  
  # Loop
  for (q in 1:100){
    
    V1 = runif(1000)*100
    
    V2 = runif(1000)*10 + V1
    
    V3 = runif(1000)*100
    
    V4 = runif(1000)*10 + V3
    
    V5 = runif(1000)*100
    
    Residuals = runif(1000)*100
    
    Y = V1 + V2 + V3 + V4 + Residuals
    
    # Modelo de Regressão Linear
    coefs_lm <-lm(Y ~ V1 + V2 + V3 + V4 + V5)$coefficients
    
    # Modelo de Regressão Lasso
    coefs_rd <-glmnet(cbind(V1 ,V2,V3,V4 ,V5),Y, lambda=lambda, alpha=1)$beta
    
    # Dataframes para os coeficientes
    frame1 <-data.frame(V1=coefs_lm[2], V2=coefs_lm[3],V3=coefs_lm[4], V4=coefs_lm[5],V5=coefs_lm[6],method="lm")
    frame2 <-data.frame(V1=coefs_rd[1], V2=coefs_rd[2],V3=coefs_rd[3], V4=coefs_rd[4],V5=coefs_rd[5],method="lasso")
    
    # Juntando os coeficientes em um dataframe único
    coeffs_total <- rbind(coeffs_total,frame1,frame2)
  }
  
  # Modificando o layout dos dados
  transposed_data = gather(coeffs_total,"Variavel","Valor",1:5)
  print(transposed_data%>%group_by(Variavel,method) %>% summarise(median=median(Valor)))
  
  # Plot
  ggplot(transposed_data,aes(x=Variavel, y=Valor, fill=method)) + geom_boxplot()
}

# Testando a função

# Chamamos a função usando lambda = 8. 
regressao_func(8)

# Agora, executamos o código com lambda = 8. Como você pode ver, os coeficientes são um pouco 
# menores do que aqueles com Ridge. Mas a parte mais importante aqui é que o coeficiente 
# irrelevante agora é igual a zero. Isso é um pouco melhor do que em Ridge, porque está 
# literalmente nos dizendo para descartar essa variável do modelo.

# Observe que usamos alpha = 0, o que significa que não queremos nenhuma regularização Lasso 
# (queremos apenas Ridge). 
?glmnet

# Existem dois pontos importantes aqui: 

# Existem algumas diferenças óbvias em relação aos coeficientes de Ridge: No Lasso, obtemos 0 
# exatamente para as variáveis irrelevantes (essa é uma maneira de fazer a seleção de variáveis). 
# Mas para Ridge, obtemos um valor menor (um coeficiente compactado), mas não exatamente zero. 

# Portanto, o Ridge não pode ser usado para seleção de variáveis. Os coeficientes Lasso são menores 
# que os de Ridge (usando o mesmo lambda). Em outras palavras, o viés parece maior para Lasso. 
# Os coeficientes Ridge são mais estáveis (medidos como a altura das caixas nos boxplots).

# Se mudamos para lambda = 0.1, as estimativas são quase as mesmas e não há muita diferença entre
# Regressão Linear e Regressão Lasso, pois não forçamos a penalidade.
regressao_func(0.1)


# Escolhendo o melhor valor de penalização (lambda).

# Ridge e Lasso são semelhantes aos mínimos quadrados comuns, com a óbvia diferença de que existe um 
# termo de penalização. A ideia é minimizar os resíduos quadrados e, ao mesmo tempo, ter 
# coeficientes que não são grandes. Como os coeficientes não serão tão grandes quanto seriam 
# na ausência do prazo de penalização, o modelo não poderá se ajustar demais aos dados. 

# Observe que é há um hiperparâmetro que define quanto peso queremos colocar na penalização, 
# chamado lambda. Um grande valor implica que a penalização será dominante e o modelo 
# provavelmente não será adequado (não capturará a estrutura dos dados). Por outro lado, um 
# pequeno valor implica que a penalização não será usada, e o modelo provavelmente se ajustará 
# demais (capturar até o ruído nos dados). O valor certo para as necessidades deve ser 
# determinado por meio de validação cruzada ou usando conjuntos de dados de treinamento/teste.


# Usando CV para escolher o melhor valor de lambda

# Cria o dataset
V1 =runif(1000)*100
V2 =runif(1000)*10 + V1
V3 =runif(1000)*100
V4 =runif(1000)*10 + V3
V5 =runif(1000)*100
Residuals =runif(1000)*100
Y = V1 + V2 + V3 + V4 + Residuals

# Executa o CV
?cv.glmnet
cv.lasso = cv.glmnet(cbind(V1 ,V2,V3,V4 ,V5),Y,alpha=1)
cv.lasso
plot(cv.lasso)



