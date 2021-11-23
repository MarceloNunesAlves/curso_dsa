# Regressão LOESS

# Se você deseja enfatizar tendências de longo prazo nos dados (ao invés de variabilidade 
# ano a ano por exemplo), podemos usar um Modelo LOESS.

# LOESS é uma regressão ponderada, que nos permite capturar tendências de longo prazo nos dados.

# LOESS funciona fazendo muitas regressões locais para cada ponto e calculando a média das previsões.

# Quando temos um gráfico de dispersão entre duas variáveis, X e Y, geralmente queremos 
# apresentar uma curva que relacione as duas variáveis. Primeiro, porque nos permite ver se 
# o relacionamento é linear (ou quase linear); segundo, porque interpretar gráficos de 
# dispersão às vezes é difícil; e, finalmente, porque podemos querer ter um modelo simples 
# que possa ser usado para prever Y em termos de X capturando todos os possíveis padrões 
# não lineares. 

# A regressão de suavização de plotagem de dispersão estimada localmente (LOESS - 
# locally estimated scatterplot smoothing) funciona ajustando muitos modelos locais 
# em torno de cada ponto. Esses modelos locais são então calculados em média. 

# Em particular, cada modelo (ajustado em torno de um ponto X0, Y0) é ajustado usando mínimos 
# quadrados ponderados (cada ponto é ponderado pelo quão perto os regressores estão do ponto X0). 
# Há um parâmetro especificado pelo usuário, chamado largura de banda, que especifica a quantidade 
# de dados usados em cada uma dessas regressões. Geralmente, polinômios de segunda ordem são usados 
# nessas regressões.

# O LOESS funciona fazendo muitas regressões locais para cada ponto e calculando a média das 
# previsões.

# O LOESS combina grande parte da simplicidade da regressão linear de mínimos quadrados com a 
# flexibilidade da regressão não linear. Isso é feito ajustando modelos simples a subconjuntos 
# localizados dos dados para construir uma função que descreve a parte determinística da 
# variância nos dados, ponto a ponto. De fato, uma das principais atrações desse método é que 
# o analista de dados não precisa especificar uma função global para ajustar um modelo aos dados, 
# apenas para ajustar segmentos dos dados.


# Neste exemplo, usaremos um conjunto de dados contendo preços e vendas. 
# O relacionamento não será linear e não será fácil caracterizar.

# Nosso objetivo será criar modelos capazes de prever o aumento nas vendas de acordo 
# com o aumento no preço.

# Carregando os dados
dataset3 = read.csv("dados/precos_vendas.csv") 
View(dataset3)

# Em seguida, criamos dois modelos LOESS. Usaremos dois valores diferentes de amplitude 
# (largura de banda - span) usando polinômios de segundo grau e largura de banda gaussiana, 
# conforme mostrado no exemplo a seguir:


# Modelo LOESS 1
?loess
model_loess1 = loess(dataset3$vendas ~ dataset3$preco,  span = 2/3, degree = 2, family = c("gaussian")) 

# Modelo LOESS 2
model_loess2 = loess(dataset3$vendas ~ dataset3$preco,  span = 0.1, degree = 2, family = c("gaussian")) 


# Funções para fazer as previsões
loess1_wrapper <- function(x){ 
  return (predict(model_loess1, x)) 
}  

loess2_wrapper <- function(x){ 
  return (predict(model_loess2, x)) 
} 

# Plot

# Plotamos duas curvas LOESS - a azul tem uma largura de banda muito pequena e a vermelha uma maior. 
# A curva vermelha é preferida (abaixo explicamos porque).

plot(dataset3$preco, dataset3$vendas) 
curve(loess1_wrapper, add = TRUE, col = "red", lwd = 3) 
curve(loess2_wrapper, add = TRUE, col = "blue", lwd = 3) 
legend(17.7, 0.5, legend = c("span=0.75", "span=0.1"), co = c("red", "blue"), lty=1:1, cex=0.8) 

# Há um equilíbrio que precisa ser alcançado aqui: 

# Quanto menor a largura de banda, mais precisos são os nossos resultados 
# (mas, ao mesmo tempo, mais difíceis são de interpretar). 

# Quanto maior a amplitude, menos precisa é a curva, mas mais fácil é interpretar. 
# O que pode ser visto na linha vermelha é que as vendas decaem rapidamente quando o preço é 
# baixo (0 a 5) e lentamente quando o preço é alto (10 a 15).

# Podemos calcular a mudança prevista de aumentar o preço de 5 para 10 e também de 10 para 15. 

# Mudança prevista de aumentar o preço de 5 para 10
loess1_wrapper(5) - loess1_wrapper(10)

# Mudança prevista de aumentar o preço de 10 para 15
loess1_wrapper(10) - loess1_wrapper(15)

# A queda nas vendas é aproximadamente quatro vezes maior quando o preço é mais baixo (= 0,12 / 0,03):

# Plot com ggplot2
# install.packages("ggplot2")
library(ggplot2)
ggplot(dataset3, aes(x=preco, y=vendas)) + 
  geom_point(size=2, shape=1) + 
  geom_smooth(se = TRUE, method = "loess") 






