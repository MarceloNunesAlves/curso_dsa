# Solução Lista 7 de Exercícios em R

# Distribuição Normal

# Em uma coleção aleatória de dados de fontes independentes, observa-se geralmente que a distribuição de dados é normal. 
# O que significa, ao traçar um gráfico com o valor da variável no eixo horizontal e a contagem dos valores no eixo vertical, 
# obtemos uma curva em forma de sino. 
# O centro da curva representa a média do conjunto de dados. No gráfico, cinquenta por cento dos valores estão à 
# esquerda da média e os outros cinquenta por cento estão à direita do gráfico. 
# Isso é chamado de distribuição normal em Estatística.

# R tem quatro funções para gerar distribuição normal, que são descritas abaixo.

# dnorm (x, média, sd)
# pnorm (x, média, sd)
# qnorm (p, média, sd)
# rnorm (n, média, sd)

# Ao prefixar um "d" ao nome da função, você pode obter valores de densidade de probabilidade (pdf). 
# Ao prefixar um "p", você pode obter probabilidades cumulativas (cdf). 
# Ao prefixar um "q", você pode obter valores quantílicos. 
# Ao prefixar um "r", você pode obter números aleatórios da distribuição. 

# Vamos estudar as 4 funções nos exercícios a seguir!

##################### Exercício 1  ###############################

# dnorm()
# Essa função fornece a altura da distribuição de probabilidade em cada ponto para uma determinada média e desvio padrão.

# O d em dnorm significa função de densidade de probabilidade, ou PDF. 
# A função de densidade de probabilidade (PDF ou apenas densidade) indica a probabilidade de observar 
# uma medida com um valor específico e, portanto, a integral sobre a densidade é sempre 1.

# Usando a densidade, é possível determinar as probabilidades dos eventos. 

# A função dnorm(x) retorna a densidade da distribuição normal padrão (média = 0, desvio padrão = 1) em x. 
# Sendo assim, como interpretamos dnorm(1)? E dnorm(-3:3)?
dnorm(1)
dnorm(-3:3)

# Resposta para dnorm(1): função dnorm() retorna a altura da distribuição de probabilidade no ponto x = 1. 
# Resposta para dnorm(-3:3): O comando retorna a densidade P(x) em x = -3, -2, -1, 0, 1, 2 e 3. 
# A função dnorm() retorna a altura da curva normal em algum valor ao longo do eixo x. 
# Isso é ilustrado no gráfico do Exercíco 2. 


##################### Exercício 2  ###############################

# Ainda considerando dnorm(-3:3) a distribuição é simétrica ou assimétrica?

# Resposta: A distribuição é simétrica em relação a x = 0. 
# A curva normal padrão pode ser plotada usando o comando abaixo:
curve(dnorm(x), xlim = c(-3,3))


##################### Exercício 3  ###############################

# O parâmetro xlim = c (-3,3) pode ser usado para traçar a função no intervalo −3≤x≤3. 

# A função dnorm () tem outras opções que permitem escolher distribuições normais 
# com outra média e desvio padrão (novamente digite ?dnorm para ver a documentação). 
# Resposta: 
?curve
curve(dnorm(x), xlim = c(-6,6))
curve(dnorm(x, mean = 1, sd = 2), col = "red", add = TRUE)

# A primeira linha no trecho de código plota a curva normal padrão no intervalo −6≤x≤6. 
# Na segunda linha, col = “red” plota a função com uma linha vermelha. 
# O add = TRUE significa que o gráfico deve ser adicionado ao primeiro plot em vez de gerar um novo gráfico. 
# Vemos que a segunda curva é simétrica em relação a x = 1 e é mais "espalhada" em comparação com a curva 
# normal padrão.

# Sem opções especificadas, o valor de "x" é tratado como uma pontuação padrão ou z-score. 
# Para mudar isso, você pode especificar as opções "mean =" e "sd =".


##################### Exercício 4  ###############################

# pnorm () 

# Dado um número ou uma lista, calcula-se a probabilidade de um número aleatório normalmente distribuído 
# ser menor que esse número. Essa função também atende pelo título de 
# “Função de Distribuição Cumulativa”. Ela aceita as mesmas opções que a dnorm.

# A função pnorm(z) retorna a probabilidade cumulativa da distribuição normal padrão no escore Z. 
# Ou seja, é a área abaixo da curva normal padrão à esquerda de z 
pnorm(1.65)

# Resposta: Isso significa que a probabilidade de obter um escore Z menor que 1,65 é 0,95 ou 95%. 

# Em outras palavras, dnorm() retorna a função de densidade de probabilidade ou pdf.
# A função pnorm() é a função de densidade cumulativa ou cdf, que retorna a área abaixo do valor 
# especificado de "x", ou para x = 1, a região sombreada.

# Às vezes, queremos encontrar a área da cauda do lado direito.
# Esse é especialmente o caso quando queremos encontrar o valor p (unilateral) correspondente a um score Z. 
# Existem muitas maneiras de fazer isso. O primeiro método é usar o fato de que a curva normal é simétrica, então: 
# P (Z > z) é complementar a P (Z <= z). 
# Por exemplo, P (Z > 1,65) é complementar a P (Z <= 1,65) e P (Z > 1,65) pode ser calculado por:

pnorm(-1.65)
1-pnorm(1.65)
pnorm(1.65, lower.tail = FALSE)

# Vemos que os três métodos produzem o mesmo resultado, conforme esperado. 
# Eu prefiro o primeiro método, pois envolve menos digitação.


##################### Exercício 5  ###############################

# qnorm() 

# A função qnorm() é o inverso da função pnorm(): qnorm (y) retorna o valor x para que pnorm (x) = y. 
# Por exemplo, o escore Z correspondente ao 95º percentil é? Calcule usando qnorm():
qnorm(0.95)
pnorm( qnorm(0.95) )
qnorm(0.05, lower.tail = FALSE)

# Isso significa que o escore Z correspondente à área da cauda direita igual a 0,05 é 1,645. 
# Também pode ser obtido pela seguinte expressão devido à simetria da curva normal 
# (o escore Z é o negativo do escore Z correspondente à área da cauda esquerda sendo 0,05):

-qnorm(0.05)


# A função rnorm () é um gerador de números aleatórios. Por exemplo:
rnorm(10)


