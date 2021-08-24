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
dnorm(1) #=> É a probabilidade no valor x=1
dnorm(-3:3) #=> É a probabilidade no valor x de -3 a 3


##################### Exercício 2  ###############################
# Ainda considerando dnorm(-3:3) a distribuição é simétrica ou assimétrica?
x <- seq(from=-3,to=3,length.out=1000)
f.x <- dnorm(x, mean = 0, sd = 1)
plot(x, f.x,type="l", lwd=3)
# é simétrica
?curve

##################### Exercício 3  ###############################

# O parâmetro xlim = c (-3,3) pode ser usado para traçar a função no intervalo −3≤x≤3. 

# A função dnorm () tem outras opções que permitem escolher distribuições normais 
# com outra média e desvio padrão (novamente digite ?dnorm para ver a documentação). 
# Resposta: 

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


##################### Exercício 5  ###############################

# qnorm() 

# A função qnorm() é o inverso da função pnorm(): qnorm (y) retorna o valor x para que pnorm (x) = y. 
# Por exemplo, o escore Z correspondente ao 95º percentil é? Calcule usando qnorm():
qnorm(0.9505285)
