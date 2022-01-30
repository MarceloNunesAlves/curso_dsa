# Forecasting - Previsões com Séries Temporais

# Processo de Construção do Modelo Preditivo

# A previsão de séries temporais tradicionais segue o mesmo processo da maioria das técnicas de 
# análise preditiva, como regressão ou classificação, e geralmente inclui as seguintes etapas: 

# Preparação de dados: Aqui, preparamos os dados para o processo de treinamento e teste do modelo. 
# Esta etapa inclui dividir a série em partições de treinamento (dentro da amostra) e teste 
# (fora da amostra), criando novos recursos (quando aplicável) e aplicando uma transformação, 
# se necessário (por exemplo, transformação de log, dimensionamento e assim por diante). 

# Treinar o modelo: Aqui, usamos a partição de treinamento para treinar um modelo estatístico. 
# O principal objetivo desta etapa é utilizar o conjunto de treinamento para treinar, ajustar e 
# estimar os coeficientes do modelo que minimizam os critérios de erro selecionados. Os valores 
# ajustados e a estimativa do modelo das observações da partição de treinamento serão usados 
# posteriormente para avaliar o desempenho geral do modelo. 

# Testar o modelo: Aqui, utilizamos o modelo treinado para prever as observações correspondentes 
# na partição de teste. A ideia principal aqui é avaliar o desempenho do modelo com um novo conjunto 
# de dados (que o modelo não viu durante o processo de treinamento). 

# Avaliação do modelo: Por último, mas não menos importante, depois que o modelo foi treinado e 
# testado, é hora de avaliar o desempenho geral do modelo nas partições de treinamento e teste. 

# Com base no processo de avaliação do modelo, se o modelo atender a um determinado limite ou 
# critério, reteremos o modelo usando a série completa para gerar a previsão final ou selecionar 
# um novo parâmetro de treinamento / modelo diferente e repetir o processo de treinamento.

# Por outro lado, esse processo possui características próprias, que o distinguem de outras técnicas 
# preditivas:

# 1- As partições de treinamento e teste devem ser ordenadas em ordem cronológica, em oposição à 
# amostragem aleatória. 

# 2- Normalmente, depois de treinar e testar o modelo usando as partições de treinamento e teste, 
# treinaremos novamente o modelo com todos os dados (ou pelo menos a observação mais recente em ordem 
# cronológica). À primeira vista, isso pode ser chocante e aterrorizante para pessoas com experiência 
# em aprendizado de máquina tradicional ou modelagem de aprendizado supervisionado, pois geralmente 
# leva a superajustes (overftting) e outros problemas. Discutiremos a razão por trás disso e como 
# evitar o excesso de ajustes posteriormente.

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap08")


##### Definição do Problema: Prevendo o Consumo de Gás Natural ##### 

# Pacotes
library(TSstudio)
library(forecast)
library(plotly)

# Carregando a série temporal
data(USgas)

# Visualizando detalhes da série
ts_info(USgas)


##### Particionamento da Série Temporal ##### 

# Estratégias e Métodos de Particionamento

# Uma das abordagens de treinamento mais comuns é o uso de partições únicas de treinamento e teste. 
# Essa abordagem simplista baseia-se em dividir a série em partições de treinamento e teste 
# (ou partições dentro e fora da amostra, respectivamente), treinando o modelo na partição de 
# treinamento e testando seu desempenho no conjunto de testes.

# As partições de treinamento e teste são ordenadas e organizadas em ordem cronológica. Essa abordagem 
# possui um único parâmetro - o "comprimento da amostra fora da amostra" (ou o comprimento da partição 
# de teste). Normalmente, o comprimento da partição de teste é derivado das seguintes regras práticas:
  
# 1- O comprimento da partição de teste deve ser de até 30% do comprimento total da série para ter 
# dados de observação suficientes para o processo de treinamento. 

# 2- A duração do horizonte de previsão (desde que não esteja violando o termo anterior). Isso está 
# relacionado principalmente ao fato de que o nível de incerteza aumenta à medida que o horizonte de 
# previsão aumenta. Portanto, alinhar o conjunto de testes ao horizonte de previsão poderia, 
# potencialmente, fornecer uma estimativa mais próxima do erro esperado da previsão. 

# Por exemplo, se tivermos uma série mensal com 72 observações (ou 6 anos) e o objetivo for prever 
# o próximo ano (ou 12 meses), faria sentido usar as primeiras 60 observações para treinar o modelo, 
# e testar o desempenho usando as últimas 12 observações. 

# Obs: Um método mais avançado de treinar os modelos é usar backtesting, quando fazemos a divisão
# da série em várias partições de treino e teste, muito similar ao conceito de validação cruzada
# em Machine Learning. Embora o método possa oferecer maior estabilidade nas previsões da série
# temporal, ele requer uso intensivo de capacidade computacional.

# Temos dois métodos principais para fazer o particionamento da série temporal, usando a função
# window do pacote stats ou ts_split do TSStudio.

# Vamos dividir a série USgas em partições, deixando as últimas 12 observações da 
# série como a partição de teste e o restante como treinamento.

# Particionamento da Série em dados de treino e de teste - Método 1
# Usando o índice de tempo da série para definir o ponto inicial e final de cada partição

# Partição de treino
?stats::window
particao_serie_treino_window <- window(USgas, 
                                       start = time(USgas)[1], 
                                       end = time(USgas)[length(USgas) - 12])

ts_info(particao_serie_treino_window)

# Partição de teste
particao_serie_teste_window <- window(USgas, 
                                      start = time(USgas)[length(USgas) - 12 + 1], 
                                      end = time(USgas)[length(USgas)])

ts_info(particao_serie_teste_window)

# Particionamento da Série em dados de treino e de teste - Método 2
# O argumento sample.out define o tamanho da partição de teste (e, portanto, a partição de treinamento)
?ts_split
particoes_USgas <- ts_split(USgas, sample.out = 12)
View(particoes_USgas)

# Coletando cada partição
particao_serie_treino_tsplit <- particoes_USgas$train
particao_serie_teste_tsplit <- particoes_USgas$test

# Detalhes das partições
ts_info(particao_serie_treino_tsplit)
ts_info(particao_serie_teste_tsplit)


##### Construção e Avaliação do Modelo ##### 

# Em Estatística e Econometria, e em particular na análise de séries temporais, 
# um modelo de média móvel integrada auto-regressiva (Autoregressive Integrated Moving Average - ARIMA) 
# é uma generalização de um modelo de média móvel auto-regressiva (ARMA). Ambos os modelos são 
# ajustados aos dados de séries temporais para melhor entender os dados ou prever pontos futuros da 
# série (previsão). 

# Os modelos ARIMA são aplicados em alguns casos em que os dados mostram evidências de não 
# estacionariedade, onde uma etapa inicial de diferenciação (correspondente à parte "integrada" 
# do modelo) pode ser aplicada uma ou mais vezes para eliminar a não estacionariedade.

# O modelo ARIMA originou-se a partir dos modelos de auto-regressão (AR) e das médias móveis (MA) e da combinação 
# entre AR e MA (modelo ARMA).

# A parte AR do ARIMA indica que a variável de interesse em evolução é regredida com seus próprios 
# valores defasados (isto é, anteriores). A parte MA indica que o erro de regressão é na verdade uma 
# combinação linear de termos de erro cujos valores ocorreram contemporaneamente e em vários momentos 
# no passado. O I (para "integrado") indica que os valores dos dados foram substituídos pela diferença 
# entre seus valores e os valores anteriores (e esse processo de diferenciação pode ter sido executado 
# mais de uma vez). O objetivo de cada um desses recursos é fazer com que o modelo ajuste os dados da 
# melhor maneira possível.

# O ARIMA é um dos mais populares modelos para análise da previsão em séries temporais. Os modelos ARIMA são 
# modelos que utilizam apenas dados históricos de séries temporais com o intuito de expressar como as séries 
# reagem de acordo com a variação estocástica anterior. Os modelos ARIMA podem ajudar a entender a dinâmica 
# dos dados em uma determinada aplicação.

# Antes da utilização do ARIMA na previsão de séries temporais vários passos de pré-processamento são necessários.

# Construindo e Treinando o Modelo ARIMA
?auto.arima
modelo_v1 <- auto.arima(particao_serie_treino_tsplit)
plot(forecast(modelo_v1, h = 12))

# Análise dos Resíduos

# A análise residual testa quão bem o modelo capturou e identificou os padrões de série. Além disso, fornece 
# informações sobre as distribuições de resíduos, necessárias para criar intervalos de confiança para a previsão. 
# A definição matemática de um resíduo é a diferença entre a observação real e o valor ajustado correspondente do 
# modelo, observado no processo de treinamento.
?checkresiduals
checkresiduals(modelo_v1)

# Resumo da avaliação dos gráficos:

# Os gráficos mostram que o modelo produz previsões que parecem dar conta de todas as informações disponíveis. 
# A média dos resíduos é próxima de zero e não há correlação significativa na série de resíduos. O gráfico de 
# tempo dos resíduos mostra que a variação dos resíduos permanece praticamente a mesma nos dados históricos, 
# além do que é mais externo e, portanto, a variação residual pode ser tratada como constante. Além disso,
# há evidente oscilação aleatória em torno da linha zero. Os resíduos parecem seguir uma distribuição normal.

# Os resíduos são úteis para verificar se um modelo capturou adequadamente as informações nos dados. 
# Um bom método de previsão produzirá resíduos com as seguintes propriedades:

# Os resíduos não estão correlacionados. Se houver correlações entre resíduos, restarão informações nos resíduos 
# que devem ser usadas no cálculo das previsões.

# Os resíduos têm média zero. Se os resíduos tiverem uma média diferente de zero, as previsões serão tendenciosas.

# O Teste de Ljung-Box é um método estatístico para testar se a autocorrelação de uma série (que, neste caso, 
# são os resíduos) é diferente de zero e usa a seguinte hipótese:

# H0: O nível de correlação entre a série e seu atraso é igual a zero e, portanto, as observações da série são 
# independentes (ou seja, o modelo não apresenta falta de ajuste e pode ser usado).

# H1: O nível de correlação entre a série e seu atraso é diferente de zero e, portanto, as observações da série 
# não são independentes (ou seja, o modelo apresenta falta de ajuste e não deve ser usado).

# O Teste de Ljung-Box é uma maneira de testar a ausência de autocorrelação serial, até um atraso especificado k.
# Quando o Teste de Ljung Box é aplicado aos resíduos de um modelo ARIMA, os graus de liberdade h devem ser 
# iguais a m-p-q, onde p e q são o número de parâmetros no modelo ARIMA (p, q).

# Na saída do Teste de Ljung-Box, você notará que, com base nos resultados do valor-p, podemos rejeitar a hipótese 
# nula (valor-p menor que 0,05). Portanto, há uma indicação de que a correlação entre a série residual e seus 
# atrasos é diferente de zero. 

# Isso sugere que a mudança diária no consumo de gas nos EUA não é uma quantia aleatória e está correlacionada 
# com a dos meses anteriores.

# Muitos testes estatísticos são usados para tentar rejeitar alguma hipótese nula. Nesse caso em particular, 
# o Teste de Ljung-Box tenta rejeitar a independência dos resíduos. O que isso significa?

# Se valor p < 0,05: você pode rejeitar a hipótese nula assumindo 5% de chance de cometer um erro. 
# Portanto, você pode assumir que seus valores estão mostrando dependência um do outro.

# Se valor p > 0,05: você não possui evidência estatística suficiente para rejeitar a hipótese nula. 
# Portanto, você não pode assumir que seus valores são dependentes. Isso pode significar que seus valores são 
# dependentes de qualquer maneira ou pode significar que seus valores são independentes. Mas você não está 
# provando nenhuma possibilidade específica, o que seu teste realmente disse é que você não pode afirmar a 
# dependência dos valores, nem pode afirmar a independência dos valores.

# Em geral, o importante aqui é ter em mente que o valor de p < 0,05 permite rejeitar a hipótese nula, mas um 
# valor de p > 0,05 não permite confirmar a hipótese nula.

# Em particular, você não pode comprovar a independência dos valores das Séries Temporais usando o Teste Ljung-Box. 
# Você só pode provar a dependência.

# Qualquer método de previsão que não satisfaça essas propriedades pode ser aprimorado.


# Previsões

# Depois de finalizar o ajuste do modelo, é hora de testar a capacidade do modelo de prever observações com dados 
# que modelo não havia visto antes (em oposição aos valores que o modelo viu durante todo o processo de 
# treinamento). O método mais comum para avaliar o sucesso da previsão é usar métricas de precisão ou erro. 

# A seleção de uma métrica de erro específica depende dos objetivos da precisão da previsão. 

# Previsões
?forecast
previsoes <- forecast(modelo_v1, h = 12)
View(previsoes)
plot(forecast(modelo_v1, h = 12))

# Calculando a acurácia das previsões - Avaliação do Modelo
?accuracy
accuracy(previsoes, particao_serie_teste_tsplit)

# Testando as previsões
?test_forecast
test_forecast(actual = USgas, forecast.obj = previsoes, test = particao_serie_teste_tsplit) 


# Criando uma Baseline

# Naive Model
?naive
modelo_v2_naive <- naive(particao_serie_treino_tsplit, h = 12)

# Calculando a acurácia das previsões
accuracy(modelo_v2_naive, particao_serie_teste_tsplit)

# Testando as previsões
test_forecast(actual = USgas, forecast.obj = modelo_v2_naive, test = particao_serie_teste_tsplit)


# Seasonal Naive Model
?snaive
modelo_v3_snaive <- snaive(particao_serie_treino_tsplit, h = 12)

# Calculando a acurácia das previsões
accuracy(modelo_v3_snaive, particao_serie_teste_tsplit)

# Testando as previsões
test_forecast(actual = USgas, forecast.obj = modelo_v3_snaive, test = particao_serie_teste_tsplit)



# Treinamento de Múltiplos Modelos Usando Backtesting

# Agora nós vamos treinar, testar e avaliar vários modelos (ou versões diferentes desses modelos) com o uso 
# de uma abordagem de backtesting. A abordagem de backtesting permite avaliar o desempenho do modelo ao longo 
# do tempo (em oposição a uma única partição de treinamento e teste) e selecionar um modelo com o melhor 
# desempenho usando algumas métricas de erro (por exemplo, MAPE ou RMSE).

# Primeiro criamos uma lista de modelos que serão criados
lista_modelos <- list(ets1 = list(method = "ets", vmethod_arg = list(opt.crit = "lik"), notes = "Modelo ETS com opt.crit = lik"),
                      ets2 = list(method = "ets", method_arg = list(opt.crit = "amse"), notes = "Modelo ETS com opt.crit = amse"),
                      arima1 = list(method = "arima", method_arg = list(order = c(2,1,0)), notes = "ARIMA(2,1,0)"),
                      arima2 = list(method = "arima", method_arg = list(order = c(2,1,2), seasonal = list(order = c(1,1,1))), notes = "SARIMA(2,1,2)(1,1,1)"),
                      hw = list(method = "HoltWinters", method_arg = NULL, notes = "Modelo HoltWinters"),
                      tslm = list(method = "tslm", method_arg = list(formula = input ~ trend + season), notes = "Modelo tslm com componentes trend e season"))

# Obs: O que representa a notação ARIMA(2,1,0) ou ARIMA (p, q, d):

# p é o número de observações de atraso utilizadas no treinamento do modelo (ou seja, ordem de atraso).
# d é o número de vezes que a diferenciação é aplicada (isto é, o grau de diferenciação).
# q é conhecido como o tamanho da janela da média móvel (isto é, ordem da média móvel).

# Assim, o modelo ARIMA (2,1,0) indica que o valor do atraso está definido como 2 para regressão automática. 
# Ele usa uma ordem de diferença de 1 para tornar a série temporal estacionária e, finalmente, não considera nenhuma janela 
# de média móvel (ou seja, uma janela com tamanho zero).

# SARIMA é representando assim: ARIMA(p, d, q) × (P, D, Q)S

# p = ordem AR não sazonal
# d = diferenciação não sazonal
# q = ordem MA não sazonal
# P = ordem AR sazonal
# D = diferenciação sazonal
# Q = ordem MA sazonal 
# S = intervalo de tempo de repetição do padrão sazonal (frequência)

# Depois criamos uma lista com os parâmetros de treinamento
metodo_treinamento = list(partitions = 6, sample.out = 12, space = 3)

# E então aplicamos o backtesting com a função train_model
?train_model
modelos <- train_model(input = USgas, methods = lista_modelos, train_method = metodo_treinamento, horizon = 12, error = "MAPE")

# Plot dos erros
plot_error(modelos)

# Plot dos modelos
plot_model(modelos)


# Forecasting - Previsões com Séries Temporais - Versão Final do Modelo

# Versão final do modelo
?Arima
?tsclean()

# Remove outliers - Cuidado! Nem sempre remover outliers é uma decisão sábia, pois o outlier pode voltar a se repetir.
tsoutliers(USgas, iterate = 2, lambda = NULL)
USgas_clean <- tsclean(USgas, lambda = NULL)

# Versão final do modelo
modelo_v4_final <- Arima(USgas_clean, order = c(2, 1, 2), seasonal = list(order = c(1, 1, 1), period = 12))
summary(modelo_v4_final)

# A ideia é escolher um modelo com valores mínimos de AIC e BIC.

# Previsões
previsoes_versao_final_h12 <- forecast(modelo_v4_final, h = 12)

# Plot das previsões
plot_forecast(previsoes_versao_final_h12,
              title = "Previsão de Consumo de Gás Natural dos EUA Para 12 Meses",
              Xtitle = "Ano",
              Ytitle = "Consumo")

# Previsões
previsoes_versao_final_h24 <- forecast(modelo_v4_final, h = 24, level = c(80, 90))

# Plot das previsões
plot_forecast(previsoes_versao_final_h24,
              title = "Previsão de Consumo de Gás Natural dos EUA Para 24 Meses",
              Xtitle = "Ano",
              Ytitle = "Consumo")

# Previsões
previsoes_versao_final_h60 <- forecast(modelo_v4_final, h = 60, level = c(80, 90))

# Plot das previsões
plot_forecast(previsoes_versao_final_h60,
              title = "Previsão de Consumo de Gás Natural dos EUA Para 60 Meses",
              Xtitle = "Ano",
              Ytitle = "Consumo")

# Previsões
?forecast_sim
previsoes_versao_final_h60_500 <- forecast_sim(modelo_v4_final, h = 60, n = 500)

# Plot das previsões (não funciona com simulações)
plot_forecast(previsoes_versao_final_h60_500,
              title = "Previsão de Consumo de Gás Natural dos EUA Para 60 Meses com 500 Iterações",
              Xtitle = "Ano",
              Ytitle = "Consumo")


library(plotly)

previsoes_versao_final_h60_500$plot %>% 
  layout(title = "Simulação de Previsão de Consumo de Gás Natural dos EUA Para 60 Meses com 500 Iterações",
         yaxis = list(title = "Consumo"),
         xaxis = list(title = "Ano"))



