# Correlação Entre Atributos

# Definindo o diretório de trabalho
# setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap05")
# getwd()

# Pacotes
library(caret) 
library(car)

# Carrega o dataset
dados = read.csv("dados/vendas_loja.csv") 
View(dados)

# Separa os atributos em X
X = dados[-1] 
View(X)

# Encontrando combinações colineares
?findLinearCombos
findLinearCombos(X) 

# Converte X e Matriz
X = as.matrix(X) 

# Calcula o determinante da Matriz
det(t(X) %*% X) 

# Avaliando Um Modelo de Regressão Criado com Variáveis Colineares
modelo_v1 = lm(Valor_Venda ~ ., data = dados) 
summary(modelo_v1) 

# Vamos remover os coeficientes recomendamos e checar o determinante
det(t(X[,c(-6,-7)]) %*% X[,c(-6,-7)]) 

# Criando o modelo agora sem as variáveis colineares
modelo_v2 = lm(Valor_Venda ~ preco_vestuario_feminino + preco_vestuario_masculino + preco_sapato_feminino + preco_sapato_masculino + preco_sapato_criancas, data = dados) 
summary(modelo_v2) 

# Calculando o Variance Inflation Factor
# Removemos as correlações perfeitas que não nos permitiam inverter adequadamente 
# uma matriz e obter os coeficientes. O R é capaz de fazer alguns truques para obter 
# alguns desses coeficientes de qualquer maneira, mas ainda assim obtemos esses 
# valores de NA (é sempre melhor obter uma saída limpa). 

# No entanto, estamos omitindo o fato de que algumas das correlações ainda podem ser 
# grandes e podemos removê-las. Existem várias maneiras de fazer isso: uma opção é 
# usar os chamados fatores de inflação de variância (VIFs); 
# esses valores são proporções que mostram quanto maiores os erros padrão ficam entre 
# um modelo que contém apenas uma variável e um modelo que contém todas elas. 
# Se um VIF for grande, significa que não obteremos uma estimativa precisa do efeito 
# e, se tivermos mais dados, a estimativa mudará bastante. 
vif(modelo_v2)

# Criando uma versão do modelo unindo duas variáveis e criando uma terceira
vestuario_agregado = dados$preco_vestuario_feminino + dados$preco_vestuario_masculino 
sapatos_cri_fem_agregado = dados$preco_sapato_feminino + dados$preco_sapato_criancas 

modelo_v3 = lm(Valor_Venda ~ vestuario_agregado + preco_sapato_masculino + sapatos_cri_fem_agregado, data = dados) 
summary(modelo_v3) 
vif(modelo_v3)


# Interpretação do Modelo de Regressão em R

# ****************************************************
# *** Estas informações abaixo é que farão de você ***
# *** um verdadeiro conhecedor de Machine Learning ***
# ****************************************************

# Equação de Regressão
# y = a + bx (simples)
# y = a + b0 x v0 + b1 x v1 (múltipla)

# Resíduos
# Diferença entre os valores observados de uma variável e seus valores previstos
# Seus resíduos devem se parecer com uma distribuição normal, o que indica
# que a média entre os valores previstos e os valores observados é próximo de 0 (o que é bom)

# Coeficiente - Intercept - a (alfa)
# Valor de a na equação de regressão

# Coeficientes - Nomes das variáveis - b (beta)
# Valor de b na equação de regressão

# Obs: A questão é que lm() ou summary() têm diferentes convenções de 
# rotulagem para cada variável explicativa. 
# Em vez de escrever slope_1, slope_2, .... 
# Eles simplesmente usam o nome da variável em qualquer saída para 
# indicar quais coeficientes pertencem a qual variável.

# Erro Padrão
# Medida de variabilidade na estimativa do coeficiente a (alfa) e b (beta). 
# O ideal é que este valor seja menor que o valor do coeficiente, mas nem sempre 
# isso irá ocorrer.

# Asteriscos 
# Os asteriscos representam os níveis de significância de acordo com o p-value.
# Quanto mais estrelas, maior a significância.
# Atenção --> Muitos astericos indicam que é improvável que não exista 
# relacionamento entre as variáveis.

# Valor t
# Define se coeficiente da variável é significativo ou não para o modelo. 
# Ele é usado para calcular o p-value e os níveis de significância.

# p-value
# O p-value representa a probabilidade que a variável não seja relevante. 
# Deve ser o menor valor possível. 
# Se este valor for realmente pequeno, o R irá mostrar o valor 
# como notação científica

# Significância
# São aquelas legendas próximas as suas variáveis
# Espaço em branco - ruim
# Pontos - razoável
# Asteriscos - bom
# Muitos asteriscos - muito bom

# Residual Standar Error
# Este valor representa o desvio padrão dos resíduos

# Degrees of Freedom
# É a diferença entre o número de observações na amostra de treinamento 
# e o número de variáveis no seu modelo.

# R-squared (coeficiente de determinação - R^2)
# Ajuda a avaliar o nível de precisão do nosso modelo. 
# Quanto maior, melhor, sendo 1 o valor ideal.

# F-statistics
# É o teste F do modelo. Esse teste obtém os parâmetros do nosso modelo 
# e compara com um modelo que tenha menos parâmetros.
# Em teoria, um modelo com mais parâmetros tem um desempenho melhor. 

# Se o seu modelo com mais parâmetros NÃO tiver perfomance
# melhor que um modelo com menos parâmetros, o valor do p-value será bem alto. 

# Se o modelo com mais parâmetros tiver performance
# melhor que um modelo com menos parâmetros, o valor do p-value será mais baixo.

# Lembre-se que correlação não implica causalidade




