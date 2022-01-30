# Regressão Stepwise Para Seleção de Atributos

# Definindo o diretório de trabalho
# setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap05")
# getwd()

# Pacotes
install.packages("olsrr")
install.packages("dplyr")
library(olsrr) 
library(dplyr) 
library(MASS)

# Cria o modelo
View(Boston)
modelo = lm(medv ~ ., data = Boston) 
summary(modelo)


# Criando todos os modelos possíveis 
# 1-Calcula todos os modelos possíveis e escolhe aquele que maximiza o coeficiente R2 ajustado ou AIC. 
# (este comando pode levar horas dependendo do seu computador)
head(ols_step_all_possible(modelo) %>% arrange(desc(adjr)))


# Stepwise forward regression
# 2-Começa com um modelo vazio e adiciona cada melhor variável sequencialmente. 
?ols_step_forward_p
ols_step_forward_p(modelo) 


# Stepwise backward regression
# 3-Começa com um modelo saturado (contendo todas as variáveis possíveis) e remove a pior variável sequencialmente. 
?ols_step_backward_p
ols_step_backward_p(modelo) 


# Stepwise regression
# 4-Começa com um modelo vazio e adiciona uma variável por vez. 
# Adicionamos a melhor variável e, em seguida, removemos a pior variável. 
?ols_step_both_p
ols_step_both_p(modelo) 


# Stepwise AIC forward regression
?ols_step_forward_aic
ols_step_forward_aic(modelo) 


# Stepwise AIC backward regression
?ols_step_backward_aic
ols_step_backward_aic(modelo) 


# Stepwise AIC regression
?ols_step_both_aic
ols_step_both_aic(modelo) 

