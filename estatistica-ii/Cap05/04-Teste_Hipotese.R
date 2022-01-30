# Teste de Hipóteses Para os Coeficientes

# Definindo o diretório de trabalho
# setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap05")
# getwd()

# Pacotes
install.packages("multcomp")
library(multcomp) 

# Carregando o dataset
dados = read.csv("dados/precos_casas.csv") 
View(dados)

# Criando o modelo de regressão
modelo = lm(preco_casa ~ tamanho + numero_banheiros + numero_quartos + numero_entradas + tamanho_varanda + tamanho_entrada, data = dados) 
summary(modelo)

# Poderíamos fazer a seguinte pergunta:

# Como a variável tamanho tem um coeficiente de 5,6 e a soma dos coeficientes para 
# numero_banheiros + numero_quartos + numero_entradas + tamanho_varanda + tamanho_entrada é aproximadamente 5, 
# podemos dizer que a soma dos efeitos dessas variáveis é semelhante ao único efeito da variável tamanho? 

# Teste de Hipóteses
?glht

# Teste 1

# Hipótese Nula = O efeito de 5 variáveis é semelhante ao efeito da variável tamanho
# Hipótese Alternativa = O efeito de 5 variáveis NÃO é semelhante ao efeito da variável tamanho

summary(glht(modelo,linfct = c("numero_banheiros + numero_quartos + numero_entradas + tamanho_varanda + tamanho_entrada - tamanho = 0")))

# Não rejeitamos a hipótese nula pois o valor-p é maior que 0.05 e assim concluímos que o contraste não 
# é estatisticamente significante!


# Teste 2

# Hipótese Nula = O efeito das variáveis numero_banheiros e numero_entradas é semelhante ao efeito das variáveis tamanho_varanda e tamanho_entrada
# Hipótese Alternativa = O efeito das variáveis numero_banheiros e numero_entradas NÃO é semelhante ao efeito das variáveis tamanho_varanda e tamanho_entrada

summary(glht(modelo,linfct = c("numero_entradas + numero_banheiros - tamanho_varanda - tamanho_entrada = 0"))) 

# Não rejeitamos a hipótese nula pois o valor-p é maior que 0.05 e assim concluímos que o contraste não 
# é estatisticamente significante!



