# Solução Lista 4 de Exercícios em R

# Diretório de trabalho
setwd("~/Dropbox/DSA/AnaliseEstatisticaI/Modulo05/Lista4")
getwd()

# Carrega o dataset
data <- read.csv("dataset.csv", sep = ';')
View(data)
attach(data)


# 1- Qual o total de pessoas com ensino médio na capital?
tabela1 <- table(reg_procedencia,grau_instrucao)
tabela1

# Formatando a saída
Total_linha <- margin.table(tabela1, 2)  # O argumento 2 define a marginal da linha
Total_coluna <- margin.table(tabela1, 1) # O argumento 1 define a marginal da coluna
tabela1_final <- rbind(cbind(tabela1,Total_coluna), c(Total_linha, sum(Total_coluna)))
dimnames(tabela1_final)[[1]][4] <- "Total_linha" 
tabela1_final

# 2- Qual o percentual de pessoas do interior com ensino superior?
tabela2 <- prop.table(tabela1)
tabela2

Total_linha <- margin.table(tabela2,2) 
Total_coluna <- margin.table(tabela2,1)
tabela2_final <- rbind(cbind(tabela2,Total_coluna),c(Total_linha, sum(Total_coluna)))
dimnames(tabela2_final)[[1]][4] <- "Total_linha" 
tabela2_final

# Formatando o resultado final
library(tidyverse)
tabela2_final %>% `*`(100) %>% round(2)

# 3- Crie um Stacked Bar Chart para representar a relação entre o grau de instrução e a região de procedência.
library(ggplot2)
library(scales)
library(reshape2)

ggplot(melt(tabela1_final[1:3,],value.name = "contagem",
            varnames = c("reg_procedencia","grau_instrucao") ))+        ## `melt` empilha os dados no formato necessário para o ggplot
  aes(x=grau_instrucao ,y=contagem, fill=reg_procedencia) +             ## Variáveis a serem plotadas. 
  geom_bar(stat="identity", position = "fill") +                        ## Define o gráfico de barras percentual empilhado 
  scale_fill_brewer(name="Região de\n Procedência")+                    ## Opções do preenchimento do gráfico (label e paleta de cores)
  scale_y_continuous(labels = percent_format()) +                       ## Formato do eixo Y em porcentagem
  theme_bw()+                                                           ## Define a cor do fundo do gráfico: neste caso, branco
  theme(legend.position="bottom") +                                     ## Define a posição da legenda abaixo do gráfico
  ggtitle("Stacked Bar: Distribuição da região de procedência por grau de instrução")+
  xlab("Grau de Instrução") + ylab("")                                  ## Define os `labels` dos eixos


# 4- Qual a relação entre grau_instrucao e estado_civil?
install.packages("gmodels")
library(gmodels)

CrossTable(grau_instrucao,estado_civil, 
           prop.r=TRUE,       # Se TRUE, entao retorna as proporções nas linhas
           prop.c=FALSE,      # Se TRUE, entao retorna as proporções nas colunas
           prop.t=FALSE,      # Se TRUE, entao retorna as proporções em relação ao total
           prop.chisq=FALSE,  # Se TRUE, entao retorna a contribuição de cada combinação para a estatística de Qui-quadrado
           digits=2)

# Teste do Qui-Quadrado
tabela3 <- table(grau_instrucao,estado_civil)
testequi <- chisq.test(tabela3) 
testequi

# 5-Como interpretar o resultado do Teste do Qui-quadrado no item anterior? As variáveis são dependentes ou independentes?

# Duas variáveis aleatórias x e y são chamadas independentes se a distribuição de probabilidade de uma variável não for afetada pela presença de outra.

# Para estabelecer que 2 variáveis categóricas são dependentes, a estatística qui-quadrado deve estar acima de um certo ponto de corte. 
# Este corte aumenta à medida que o número de classes dentro da variável aumenta.

# Alternativamente, você pode simplesmente executar um teste qui-quadrado e verificar os valores-p.

# Como todos os testes estatísticos, o teste qui-quadrado assume uma hipótese nula e uma hipótese alternativa. 
# A prática geral é, se o valor de p que sai no resultado é menor que um nível de significância pré-determinado, que é 0,05 normalmente, 
# então rejeitamos a hipótese nula.

# H0: As duas variáveis são independentes
# H1: As duas variáveis estão relacionadas.

# A hipótese nula do teste qui-quadrado é que as duas variáveis são independentes e a hipótese alternativa é que elas estão relacionadas.

# O valor do qui-quadrado será maior se a diferença entre os valores real e esperado aumentar.
# Além disso, quanto mais as categorias nas variáveis, maior deve ser a estatística qui-quadrado.

# Como o valor de p 0.3843 é maior que o nível de significância de 0,05, 
# não rejeitamos a hipótese nula de que o grau de instrução seja independente do estado civil.


# 6- Quais são as técnicas usadas para analisar a relação entre:

# 2 Variáveis Categóricas         
# ==> Teste do Qui-Quadrado

# 2 Variáveis Numéricas                                       
# ==> Regressão Linear 

# Variável Categórica (Dependente) e Numérica (Independente)  
# ==> Regressão Logística

# Variável Categórica (Independente) e Numérica (Dependente)  
# ==> ANOVA (Análise de Variância)


# 7- Explique o que é Correlação e o que é Causalidade.

# Correlação é um conceito que se refere à medida da relação entre duas variáveis. 
# Por exemplo, pensemos nas variáveis quantidade de sorvetes vendidos e temperatura. Em dias de calor acentuado, 
# verifica-se que a quantidade de sorvetes vendidos tende a ser mais elevada. Isto é, diz-se que há uma correlação positiva 
# entre temperaturas e quantidade de sorvetes vendidos. 
# A correlação ainda pode ser nula (ou quase nula), por exemplo, quando tentamos relacionar o consumo de arroz com a 
# temperatura. Esse consumo tende a não variar expressivamente em decorrência da mudança de temperatura, 
# diz-se então que a correlação entre o consumo de arroz e a temperatura é (praticamente) nula.

# Causalidade é um conceito em que há relação entre uma variável X e uma variável Y e a variável Y é consequência da variável X, 
# ou dito de outra maneira, a variável X é causa da variável Y. 
# Ainda no exemplo da temperatura e da quantidade vendida de sorvete, podemos identificar que dias de temperaturas mais 
# altas implicam em uma maior quantidade média de sorvetes vendidos. 
# Isto é, dadas as preferências das pessoas de consumirem mais sorvetes em dias de calor, quando a temperatura aumenta, em média, 
# a quantidade de sorvete vendida também aumenta. Com o devido embasamento teórico a respeito das preferências das pessoas, 
# pode-se concluir que o aumento de temperatura é a causa da elevação na venda de sorvetes.


# 8- Calcule as medidas de posição da variável salário.
str(data$salario)
data$salario <- as.double(data$salario)
summary(data$salario)


# 9- Calcule as medidas de dispersão da variável salário.
sd(data$salario)
var(data$salario)


# 10 - Apresenteo relatório em PowerPoint ou usando RMarkdown



