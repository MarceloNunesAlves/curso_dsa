# Trabalhando com Regressão Ridge

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
    
    # Modelo de Regressão Ridge
    coefs_rd <-glmnet(cbind(V1 ,V2,V3,V4 ,V5),Y, lambda=lambda, alpha=0)$beta
    
    # Dataframes para os coeficientes
    frame1 <-data.frame(V1=coefs_lm[2], V2=coefs_lm[3],V3=coefs_lm[4], V4=coefs_lm[5],V5=coefs_lm[6],method="lm")
    frame2 <-data.frame(V1=coefs_rd[1], V2=coefs_rd[2],V3=coefs_rd[3], V4=coefs_rd[4],V5=coefs_rd[5],method="ridge")
    
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

# Como podemos ver, as estimativas Ridge são muito mais estáveis do que as de 
# Regressão Linear. Além disso, os coeficientes são um pouco menores 
# (estão mais distantes de 1, que é o valor ideal para eles). 
# Esse é o viés introduzido pela Regressão Ridge. 

# Observe que usamos alpha = 0, o que significa que não queremos nenhuma regularização Lasso 
# (queremos apenas Ridge). 
?glmnet

# Existem dois pontos importantes aqui: 

# Em primeiro lugar, os coeficientes são muito mais estáveis que seus pares com lm() 
# (menos variabilidade - caixas mais curtas no boxplot).
# Segundo, a maioria das variáveis fica ligeiramente compactada (mostrada na tabela). 
# Isso é causado pelo viés introduzido pelo Ridge. Vale a pena notar que a variável irrelevante (V5) 
# foi compactada de maneira bastante significativa, mas o resultado não é exatamente zero.

# Se mudamos para lambda = 0.1, as estimativas são quase as mesmas e não há muita diferença entre
# Regressão Linear e Regressão Ridge, pois não forçamos a penalidade.
regressao_func(0.1)

