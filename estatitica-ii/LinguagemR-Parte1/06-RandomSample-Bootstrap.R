# Random Sample / Bootstrap 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# Usamos bootstrapping para estimar estatísticas, tais como erros padrão e intervalos de confiança.

# Considere um projeto de amostragem aleatória simples: existe uma população (desconhecida) 
# de itens e você deseja estimar a média populacional tomando uma amostra aleatória de 10 unidades. 
# Claramente, se você tomar várias amostras aleatórias, a média estimada para cada amostra 
# será diferente. 

# Sabemos, a partir da teoria estatística, que a distribuição dessas médias amostrais na verdade 
# segue uma distribuição normal (independente da distribuição real da população). 
# Este é o Teorema do Limite Central! 

# A distribuição das médias amostrais é um exemplo de uma distribuição amostral e descreve 
# como as amostras subsequentes são diferentes, tomadas aleatoriamente da população.

# Criando uma população de exemplo
?rweibull
Population <- rweibull(100000, shape=2, scale=20)
View(Population)


# Extraindo uma amostra aleatória de 10 elementos
Sample <- sample(Population, 10, replace=FALSE)
Sample


# Calculando média 
media <- mean(Sample)
media


# O desvio padrão da distribuição de amostragem é conhecido como o erro padrão (SE - Standard Error). 
# Normalmente estimamos o erro padrão usando a equação SE = s / sqrt(n)
SE <- sd(Sample)/sqrt(10)
SE

# O erro padrão é o desvio padrão da distribuição amostral. 
# Uma vez que, neste caso, nós realmente conhecemos toda a população podemos testar 
# essa afirmação via simulação. Podemos simplesmente pegar uma amostra de 10 elementos mil vezes, 
# calcular a média da amostra a cada vez e observar o desvio padrão através das 1.000 médias das amostras. 
# É semelhante ao nosso SE calculado para uma única amostra?

# Usamos a função replicate() para executar uma função diversas vezes
r <- replicate(1000, mean(sample(Population, 10, replace=F)))
print(r)


# Agora o desvio padrão é muito similar ao SE calculado anteriormente
sd(r)


# Embora sejam "muito parecidos", claro que certamente não são os mesmos valores. 
# O SE calculado a partir da amostra é uma estimativa muito pior, uma vez que se baseia 
# apenas na própria amostra. No entanto, eles certamente estão próximos o suficiente para 
# que possamos acreditar no método. Altere o tamanho da amostra e veja o que acontece.


# Bootstrap

# A ideia simples do bootstrap é que podemos fazer uma reamostragem da própria amostra, 
# com substituição, e a distribuição resultante é, na verdade, uma estimativa aproximada 
# da distribuição verdadeira da amostragem. 

# Amostragem com substituição significa que muitas de nossas amostras contêm a mesma unidade 
# mais de uma vez. 

# Reamostragem da nossa amostra 999 vezes e calcula a média de cada vez.
boot <- replicate(999, mean(sample(Sample, replace=T)))

# Como antes, o SD da distribuição amostral (aqui aproximado via bootstrap)
# é o erro padrão da média.
sd(boot)


# Intervalos de confiança

# Com o bootstrap, calculamos o intervalo de confiança simplesmente como os quartis da 
# distribuição amostral. Aqui você pode ver que, como a distribuição de amostragem é normal, 
# esse cálculo é muito semelhante ao método padrão “duas vezes o erro padrão” 
# (que é de fato baseado nos quartis da distribuição normal padrão).

# Método Bootstrap
quantile(boot, probs=c(0.025, 0.975))

# Bastante semelhante ao dobro do erro padrão calculado para a amostra
c(mean(boot) - 2*sd(Sample)/sqrt(10), mean(boot) + 2*sd(Sample)/sqrt(10))



