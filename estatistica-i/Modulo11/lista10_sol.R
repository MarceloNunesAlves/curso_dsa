# Solução Lista 10 de Exercícios
# Teste de Hipótese Para Fatores de Risco Associados ao Baixo Peso de Recém Nascidos

# Testando diferenças na média entre dois grupos

# Hipótese Nula (H0) – Os pesos dos recém-nascidos não diferem entre mães fumantes e não fumantes.
# Hipótese Alternativa (H1) – Os pesos dos recém-nascidos diferem entre mães fumantes e não fumantes.

# Usando a função t.test() em R qual sua conclusão? Rejeitamos ou não a H0?

# Pacotes
library(MASS)
library(plyr)
library(ggplot2)


# Dataset
?birthwt
nascimentos <- birthwt
View(nascimentos)
class(nascimentos)
str(nascimentos)


# Ajustando o nome das colunas
colnames(nascimentos) <- c("peso_abaixo_2500", "idade_mae", "peso_mae", 
                       "raca", "mae_fumante", "numero_anterior_prematuros", "historico_hipertensao", "irritabilidade_uterina", 
                       "visitas_ao_medico", "peso_nascimento_gramas")

View(nascimentos)


# Transformar variáveis em fatores com níveis descritivos
nascimentos <- mutate(nascimentos, 
                      raca = as.factor(mapvalues(raca, c(1, 2, 3), c("Branco","Negro", "Outro"))),
                      mae_fumante = as.factor(mapvalues(mae_fumante, c(0,1), c("Não", "Sim"))),
                      historico_hipertensao = as.factor(mapvalues(historico_hipertensao, c(0,1), c("Não", "Sim"))),
                      irritabilidade_uterina = as.factor(mapvalues(irritabilidade_uterina, c(0,1), c("Não", "Sim")))
)

str(nascimentos)


# Criando boxplot mostrando como o peso_nascimento_gramas varia entre status de fumante
qplot(x = mae_fumante, y = peso_nascimento_gramas,
      geom = "boxplot", data = nascimentos,
      xlab = "Mãe é Fumante", 
      ylab = "Peso do Recém Nascido (gramas)",
      fill = I("orchid4"))


# O gráfico acima sugere que o tabagismo está associado ao menor peso do recém nascido. 
# Como podemos avaliar se essa diferença é estatisticamente significativa?
  
# Vamos calcular uma tabela de resumo
ddply(nascimentos, ~ mae_fumante, summarize,
      mean.nascimentos = mean(peso_nascimento_gramas),
      sd.nascimentos = sd(peso_nascimento_gramas)
)


# É bom ter o desvio padrão, mas, para avaliar a significância estatística, 
# queremos realmente ter o erro padrão (que o desvio padrão foi ajustado pelo tamanho do grupo).
ddply(nascimentos, ~ mae_fumante, summarize,
      group.size = length(peso_nascimento_gramas),
      media_peso = mean(peso_nascimento_gramas),
      desvio_padrao_peso = sd(peso_nascimento_gramas),
      erro_padrao_peso = desvio_padrao_peso / sqrt(group.size)
)

# Essa diferença parece bastante significativa. 
# Para executar um teste t de duas amostras, podemos simplesmente usar a função t.test().

# Um teste t é um teste analítico usado para determinar se há uma diferença significativa 
# entre dois conjuntos de dados ou se a média de um conjunto de dados difere 
# significativamente de um valor previsto.

nascimentos.t.test <- t.test(peso_nascimento_gramas ~ mae_fumante, data = nascimentos)
nascimentos.t.test


# Vemos a partir deste resultado que a diferença é altamente significativa. 
# A função t.test () também gera um intervalo de confiança.

# Observe que a função retorna muitas informações e podemos acessar cada elemento retornado.

# A capacidade de extrair informações específicas da saída do teste de hipótese permite 
# que você relate seus resultados usando blocos de código em linha. 

# Ou seja, você não precisa codificar estimativas, valores-p, intervalos de confiança, etc.

names(nascimentos.t.test)
nascimentos.t.test$p.value 
nascimentos.t.test$estimate  
nascimentos.t.test$conf.int  
attr(nascimentos.t.test$conf.int, "conf.level") 

# Calculando a diferença entre os grupos
nascimentos.smoke.diff <- round(nascimentos.t.test$estimate[1] - nascimentos.t.test$estimate[2], 1)
nascimentos.smoke.diff

# Verificando o nível de confiança usado no teste
conf.level <- attr(nascimentos.t.test$conf.int, "conf.level") * 100
conf.level

# Nosso estudo constata que os pesos ao nascer são, em média, 283,8g mais altos 
# no grupo de não fumantes do que no grupo de fumantes 
# (estatística t 2,73, valor-p = 0,007, IC 95% [78,6, 489] g)

# Um pequeno valor-p (normalmente ≤ 0,05) indica forte evidência contra a hipótese nula; 
# portanto, você rejeita a hipótese nula. 

# Um valor-p grande (> 0,05) indica evidência fraca contra a hipótese nula; 
# portanto, você falha em rejeitar a hipótese nula.

# Para este exercício, rejeitamos a H0 pois o valor-p é menor que 0.05.








