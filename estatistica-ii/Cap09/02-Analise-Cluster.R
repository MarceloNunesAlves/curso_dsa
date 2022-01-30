# Projeto de Análise Multivariada - Por Que os Clientes Cancelam Seus Planos de Assinatura Mensal?

# Análise de Cluster

# A Análise de Cluster é a tarefa de dividir os pontos de dados em um conjunto de grupos, de modo 
# que os pontos de dados nos mesmos grupos sejam mais semelhantes a outros pontos de dados no mesmo grupo 
# e diferentes dos pontos de dados em outros grupos. 

# É basicamente uma coleção de objetos com base na similaridade entre eles.

# Existem diferentes tipos de técnicas de cluster:

# 1. Hierárquico.
# 2. Não Hierárquico.

# Um cluster hierárquico, também conhecido popularmente como cluster não supervisionado, é um método no 
# qual extraímos referências de conjuntos de dados que consistem em dados de entrada sem respostas 
# rotuladas. Geralmente é usado como um processo para encontrar estrutura significativa, processos 
# explicativos, recursos generativos e agrupamentos inerentes a um conjunto de exemplos. 

# Um método não hierárquico gera uma classificação ao particionar um conjunto de dados, fornecendo um 
# conjunto (geralmente) de grupos não sobrepostos que não têm relacionamentos hierárquicos entre eles. 
# Uma avaliação sistemática de todas as partições possíveis é bastante inviável, e muitas heurísticas 
# diferentes foram descritas para permitir a identificação de partições boas, mas possivelmente sub-ótimas.

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap09")

# Pacotes
install.packages("qcc")
install.packages("fitdistrplus")
library(ggplot2)
library(car)
library(reshape2)
library(tidyverse) 
library(qcc)
library(fitdistrplus)
library(corrplot)
library(RColorBrewer)

# Carregando os dados
clientes <- read.csv("dados/clientes.csv")
dim(clientes)
str(clientes)
View(clientes)

# Checando valores missing
sapply(clientes, function(x) sum(is.na(x)))
sum(is.na(clientes))

# Removendo valores missing
clientes <- clientes[complete.cases(clientes),]  
sum(is.na(clientes))
dim(clientes)

# Transforma os dados para análise

# Converte as variáveis categóricas em fator

# Variáveis categóricas
factorVars <- c("Sexo", "CidadaoSenior", "Parceiro", "Dependentes", "ServicoTelefone", 
                "LinhasMultiplas", "ServicoInternet", "SegurancaOnline", "BackupOnline",
                "ProtecaoDispositivo", "SuporteTecnico","StreamingTV", "StreamingFilmes",
                "Contrato", "FaturaOnline", "MetodoPagamento", "ClienteChurn")

# Converte as variáveis no dataset
clientes[, factorVars] <- lapply(clientes[, factorVars], as.factor)
str(clientes)
View(clientes)

# Analisando a variável de fidelidade do cliente
ggplot(data = clientes, mapping = aes(x = Fidelidade)) +  
  geom_histogram(binwidth = 1) +
  labs(x = 'Fidelidade do Cliente (meses)', 
       y = 'Número de Clientes', 
       title = 'Histograma de Fidelidade do Cliente')

# Insight: Muitos clientes deixam a empresa durante os primeiros meses. 

# Número de clientes que deixaram a empresa x Fidelidade

# Extrai os clientes que deixaram a empresa
clientes_churned <- filter(clientes, ClienteChurn == "Yes")
View(clientes_churned)

# Agrupa por Fidelidade
clientes_churned_fidelidade <- group_by(clientes_churned, ClienteChurn, Fidelidade) %>%
  summarise(count = n())
View(clientes_churned_fidelidade)

# Plot
ggplot(data = clientes_churned_fidelidade, mapping = aes(x = Fidelidade, y = count)) +  
  geom_point() +
  geom_smooth() +
  labs(x = 'Fidelidade do Cliente (meses)',
       y = 'Número de Clientes Que Cancelaram a Assinatura',
       title = 'Clientes Que Cancelaram a Assinatura x Fidelidade')

# Dados Acumulados
?cumsum
clientes_churned_fidelidade_acumulado <- cumsum(clientes_churned_fidelidade$count)

# Plot
plot(y = clientes_churned_fidelidade_acumulado, x = clientes_churned_fidelidade$Fidelidade,
     xlab = "Fidelidade do Cliente (meses)",
     ylab = "Número Acumulado de Clientes Que Cancelaram a Assinatura")

# Pareto Chart
?pareto.chart
pareto.chart(clientes_churned_fidelidade$count,
             xlab = NULL, 
             ylab = "Frequência", 
             ylab2 = "Percentual Acumulado", 
             cumperc = seq(0, 100, by = 25), 
             ylim = NULL, 
             main = "Pareto Chart")

# Insight: A rotatividade de clientes é muito maior no início da vida útil do cliente e reduz quando
# aumenta a fidelidade. As campanhas de aquisição de novos clientes estão atraindo clientes, mas os 
# programas de retenção não estão funcionando. Pareto mostra que, para 100 novos clientes no Tempo 0, 
# 50 clientes cancelaram a assinatura 9 meses depois.


# Vamos modelar a função de probabilidade da rotatividade ao longo do tempo (distribuição gama)

# O fitdistr estima os valores dos parâmetros, maximizando a função de probabilidade.
?fitdist
fit.gamma <- fitdist(clientes_churned$Fidelidade, distr = "gamma", method = "mle")
summary(fit.gamma)

par(new = TRUE)

# Distribuição Gamma

# Na teoria das probabilidades, a distribuição gamma é uma família de dois parâmetros de distribuições 
# contínuas de probabilidades. A distribuição exponencial, a distribuição Erlang e a distribuição 
# qui-quadrado são casos especiais da distribuição gamma. 

# Usamos 2 parâmetros para criar a distribuição gamma:

# Parâmetro Shape k.
# Parâmetro Rate (escala) θ.

# Outras combinações de dois parâmetros são possíveis.

# A parametrização com k e θ é comum em econometria e em alguns outros campos aplicados, onde, por exemplo, 
# a distribuição gamma é frequentemente usada para modelar tempos de espera. 

# Por exemplo na indústria, o teste de vida de um produto (o tempo de espera até a descontinuidade)
# é uma variável aleatória que é frequentemente modelada com uma distribuição gamma.

# Criando a distribuição gamma
?rgamma
length(clientes_churned$Fidelidade)
x <- rgamma(1869, shape = 0.727147, rate = 0.04156)

# Cria um dataframe para o Plot
df_data <- data.frame(x = c(1:1869), fidelidade_real = clientes_churned$Fidelidade, fidelidade_prevista = x)
View(df_data)

# Plot comparativo
ggplot(df_data, aes(x)) +                    
  geom_histogram(alpha = 0.5, aes(fidelidade_real), binwidth = 5, position = "identity") +  
  geom_histogram(alpha = 0.5, aes(fidelidade_prevista), binwidth = 5, position = "identity")+  
  labs( x = "Tempo (Meses)", 
        y = "Número de Clientes Que Cancelaram a Assinatura", 
        title = "Comparação da Distribuição Gama com a Distribuição Original da Variável Fidelidade")

# Insight: agora é possível prever a rotatividade de clientes para previsões financeiras. A previsão mostra
# que o número de cancelamentos deve ser manter no mesmo padrão se nada for feito na situação atual.

# Extraindo as variáveis quantitativas
str(clientes)
df_variaveis_quantitativas <- data.frame(clientes$Fidelidade, clientes$CobrancaMensal, clientes$CobrancaTotal)
df_variaveis_quantitativas
View(df_variaveis_quantitativas)

# Padroniza as variáveis
?scale
df_variaveis_quantitativas_scaled <- scale(df_variaveis_quantitativas[,])
View(df_variaveis_quantitativas_scaled)

# Coleta variáveis categóricas e transforma tipos de dados em numéricos para regressão
View(clientes)
clientes_cat <- clientes[,-c(1,6,19,20)]
View(clientes_cat)

# Cria variáveis dummy
?model.matrix
variaveis_dummy <- data.frame(sapply(clientes_cat, 
                                     function(x) data.frame(model.matrix(~x-1, 
                                                                         data = clientes_cat))[,-1]))
View(variaveis_dummy)
str(variaveis_dummy)

# Dataset final para clusterização
df_clientes_final <- cbind(df_variaveis_quantitativas_scaled, variaveis_dummy)
View(df_clientes_final)

# Correlação
temp <- df_clientes_final
names(temp) <- c(1:31)
temp <- cor(temp)
corrplot(temp, method = "pie", type = "upper")

# Customizando a Matriz de Correlação
?corrplot
corrplot(temp, method = "color", type = "full")
corrplot(temp, method = "pie", type = "full", diag = FALSE)

# Vamos filtrar e considerar apenas a correlação forte (maior que 0.4  ou menor que -0.4) 
# entre as variáveis. 
library(dplyr)
library(tidyr)

cor_mat <- cor(temp)
cor_mat[!lower.tri(cor_mat)] <- NA # remove a diagonal e valores redundantes
data.frame(cor_mat) %>%
  rownames_to_column() %>%
  gather(key = "variable", value = "correlation", -rowname) %>%
  filter(abs(correlation) > 0.4)

corrplot(cor_mat, method = "pie", type = "full", diag = FALSE)

# Para simplificar, alteramos os nomes das variáveis por números. 

# Insight: Análise Multivariada Baseada em Correlação

colnames(df_clientes_final)

# 1) As variáveis 1, 2 e 3 tem alta correlação entre si.
# 2) A variável 5 tem forte correlação com as variáveis 2 e 3.
# 3) A variável 6 tem forte correlação com as variáveis 1, 2 e 3.
# 4) A variável 10 tem forte correlação com as variáveis 1, 2 e 3.
# 5) A variável 11 tem forte correlação com as variáveis 1, 2 e 3.
# 6) A variável 2 está negativamente correlacionada com as variáveis 12, 13, 15, 17, 19, 21 e 23.
# 7) A variável 26 tem forte correlação com a variável 1.
# 8) A variável 27 tem forte correlação com a variável 2.
# 9) A variável 28 tem forte correlação com a variável 2.
# 10) A variável 30 tem forte correlação negativa com as variáveis 2 e 3.
# 11) A variável 4 não apresenta correlação com qualquer outra variável.


# Clusterização

# O objetivo da análise de cluster é identificar padrões nos dados. 

# No manual em pdf do item anterior há uma descrição completa do que é Análise de Cluster

# Pacotes
library(tidyverse)  
library(cluster)    
library(factoextra) 
library(GGally)
library(plotly)

# Vamos criar uma cópia do dataset e alterar o título das colunas para valor numérico.
# Isso visa facilitar a criação dos gráficos.
colnames(df_clientes_final)
df_clientes_final_num <- df_clientes_final
names(df_clientes_final_num) <- c(1:31)
colnames(df_clientes_final_num)

# Para a primeira análise de cluster, vamos usar apenas algumas variáveis: (1,2,3,5,6,7)
# Devemos usar as variáveis padronizadas com a função scale () da biblioteca dplyr. 
# A transformação reduz o impacto dos outliers e permite comparar uma única observação com a média. 
# Se um valor padronizado (ou escore z) for alto, você pode ter certeza de que essa observação está 
# realmente acima da média (um escore z grande implica que esse ponto está longe da média em termos 
# de desvio padrão). Um escore de dois indica que o valor está a dois desvios-padrão da média.
# Nota, o escore-z segue uma distribuição gaussiana e é simétrico em torno da média.
input_v1 <- df_clientes_final_num[,c(1,2,3,5,6,7)]
View(input_v1)

# Kmeans Animation
install.packages("animation")	
set.seed(2345)
library(animation)
?kmeans.ani
kmeans.ani(input_v1[2:3], 3)

# Modelo de Cluster
set.seed(120)
?kmeans

# Primeiro modelo
n_clusters <- 5
clientes_cluster_v1 <- kmeans(input_v1, centers = n_clusters, nstart = 20)
View(clientes_cluster_v1)
print(clientes_cluster_v1)

# No próximo item de aprendizagem do curso Análise Estatística Para Data Science II com R e SAS,
# aqui na DSA, você encontra um manual em pdf com as métricas e a interpretação de cada uma.

# A função kmeans() gera os resultados do cluster. Podemos ver os vetores centróides 
# (médias de cluster), o grupo no qual cada observação foi alocada (vetor de cluster) e uma 
# porcentagem (72.4%) que representa a compactação do cluster, ou seja, quão semelhantes são os 
# membros dentro do mesmo grupo. Se todas as observações dentro de um grupo estivessem no mesmo 
# ponto exato no espaço n-dimensional, atingiríamos 100% de compactação.

# A saída de kmeans é uma lista com várias informações:

# size: o número de pontos em cada cluster.
print(clientes_cluster_v1$size)

# centers: Uma matriz de centros de cluster.
print(clientes_cluster_v1$centers)

# withinss: vetor com a soma dos quadrados dentro do cluster, um componente por cluster.
print(clientes_cluster_v1$withinss)

# tot.withinss: a soma total dos quadrados de todos os clusters.
print(clientes_cluster_v1$tot.withinss)

# betweenss: a soma de quadrados entre grupos (entre clusters).
print(clientes_cluster_v1$betweenss)

# totss: a soma total de quadrados.
print(clientes_cluster_v1$totss)

# Compactação do cluster
compact <- clientes_cluster_v1$betweenss / clientes_cluster_v1$totss * 100
print(compact)

# cluster: um vetor de números inteiros (de 1: k) indicando o cluster ao qual cada ponto está alocado.
print(clientes_cluster_v1$cluster)

# Vamos checar qual seria o valor ideal de clusters de acordo com nossos dados

# Função para determinar o valor ideal de k
# Extraímos a métrica tot.withinss
kmean_withinss <- function(k) {
  cluster <- kmeans(input_v1, centers = k)
  compact <- cluster$betweenss / cluster$totss * 100
  metricas <- list("Tot_Intra_Cluster" = cluster$tot.withinss, "Compact" = compact)
  return (metricas)
}

# Testa a função com 2 e 5 clusters
kmean_withinss(2)
kmean_withinss(5)

# Define um valor máximo de k
max_k <- 12

# Vamos testar todos os valores de k de 2 a 12
wss_resultado <- sapply(2:max_k, kmean_withinss)

# Criamos um dataframe com o resultado para criar um plot com o gráfico de elbow
elbow_df <- data.frame(wss_resultado)
colnames(elbow_df) <- c('K2', 'K3', 'K4', 'K5', 'K6', 'K7', 'K8', 'K9', 'K10', 'K11', 'K12')
View(elbow_df)

# Fazemos o pivot do dataframe
library(reshape)
elbow_df_pivot <- unique(melt(elbow_df))
colnames(elbow_df_pivot) <- c('Valor_K', 'Tot_Intra_Cluster', 'Compact')
View(elbow_df_pivot)

# Plot de Elbow para o Total Intra Cluster (quanto menor, melhor)
ggplot(elbow_df_pivot, aes(x = Valor_K, y = Tot_Intra_Cluster)) +
  geom_point() 

# Plot de Elbow para a Compactação (quanto maior, melhor)
ggplot(elbow_df_pivot, aes(x = Valor_K, y = Compact)) +
  geom_point() 

# Podemos ter um pouco menos de trabalho
set.seed(123)
?fviz_nbclust
fviz_nbclust(input_v1, kmeans, method = "wss")
fviz_nbclust(input_v1, kmeans, method = "silhouette")

# Cluster Plot
?fviz_cluster
fviz_cluster(clientes_cluster_v1, data = input_v1)

# Podemos usar o Silhouette Coefficient (largura da silhueta) para avaliar a qualidade do nosso 
# agrupamento.

# A interpretação do silhouette coefficient é a seguinte:

# Si > 0 significa que a observação está bem agrupada. 
# Quanto mais próximo estiver de 1, melhor será o agrupamento.

# Si < 0 significa que a observação foi colocada no cluster errado.

# Si = 0 significa que a observação ocorre entre dois grupos.

# O gráfico abaixo nos fornece evidências de que nosso agrupamento usando cinco grupos 
# é bom porque não há largura negativa da silhueta e os valores são maiores que 0.
?silhouette
sil_v1 <- silhouette(clientes_cluster_v1$cluster, dist(input_v1))
fviz_silhouette(sil_v1)

# Vamos criar a segunda versão do modelo de clusterização, agora com todas as 
# variáveis em 5 agrupamentos.
View(df_clientes_final_num)
input_v2 <- df_clientes_final_num
n_clusters <- 5
clientes_cluster_v2 <- kmeans(input_v2, centers = n_clusters, nstart = 20)
View(clientes_cluster_v2)
print(clientes_cluster_v2)
fviz_cluster(clientes_cluster_v2, data = input_v2)
sil_v2 <- silhouette(clientes_cluster_v2$cluster, dist(input_v2))
fviz_silhouette(sil_v2)

# Insight: Nossa versão 1 apresenta um resultado melhor para o agrupamento dos clientes.

# Vamos criar a terceira versão do modelo de clusterização, agora com todas as 
# variáveis em 7 agrupamentos.
View(df_clientes_final_num)
input_v3 <- df_clientes_final_num
n_clusters <- 7
clientes_cluster_v3 <- kmeans(input_v3, centers = n_clusters, nstart = 20)
View(clientes_cluster_v3)
print(clientes_cluster_v3)
fviz_cluster(clientes_cluster_v3, data = input_v3)
sil_v3 <- silhouette(clientes_cluster_v3$cluster, dist(input_v3))
fviz_silhouette(sil_v3)

# Insight: Nossa versão 1 ainda apresenta um resultado melhor para o agrupamento dos clientes.

# Vamos criar a quarta versão do modelo de clusterização, agora com 6 variáveis em 7 agrupamentos.
View(df_clientes_final_num[,c(1,2,3,5,6,7)])
input_v4 <- df_clientes_final_num[,c(1,2,3,5,6,7)]
n_clusters <- 7
clientes_cluster_v4 <- kmeans(input_v4, centers = n_clusters, nstart = 20)
View(clientes_cluster_v4)
print(clientes_cluster_v4)
fviz_cluster(clientes_cluster_v4, data = input_v4)
sil_v4 <- silhouette(clientes_cluster_v4$cluster, dist(input_v4))
fviz_silhouette(sil_v4)

# Insight: Como nosso modelo versão 1 apresentou um resultado melhor para o coeficiente da 
# largura da silhoueta (mesmo com uma compactação menor), ele será nossa escolha final.

# Associando cada ponto de dado a cada cluster
View(input_v1)
input_v1$cluster <- as.factor(clientes_cluster_v1$cluster)
View(input_v1)

# Você obtém uma visão mais profunda da análise de cluster com o componente central, chamado centróide. 
# No comando abaixo, as linhas se referem à numeração do cluster e as colunas às variáveis 
# usadas pelo algoritmo. 
clientes_cluster_v1$centers

# Os valores são a pontuação média de cada cluster para a coluna de interesse. 
# A padronização facilita a interpretação. Valores positivos indicam que o escore z 
# para um determinado cluster está acima da média geral. 
# Por exemplo, o cluster 2 tem a maior média de CobrancaTotal entre todos os clusters.

# Cria um dataset com os centróides para o plot dos clusters
n_clusters <- 5
cluster <- c(1: n_clusters)
center_df <- data.frame(cluster, clientes_cluster_v1$centers)
View(center_df)

# Reshape dos dados para o Plot
center_reshape <- gather(center_df, X1, values, X1:X7)
View(center_reshape)

# Vamos criar uma paleta de cores
hm.palette <- colorRampPalette(brewer.pal(5, 'RdYlGn'), space = 'Lab')

# Plot
ggplot(data = center_reshape, aes(x = X1, y = cluster, fill = values)) +
  scale_y_continuous(breaks = seq(1, 5, by = 1)) +
  geom_tile() +
  coord_equal() +
  scale_fill_gradientn(colours = hm.palette(90)) +
  theme_classic() +
  labs(x = "Atributos") +
  labs(y = "Clusters")

# Insight: Os 5 grupos são facilmente reconhecidos.

print(colnames(df_clientes_final[,c(1,2,3,5,6,7)]))

# Cluster # 1: Análise do gráfico na aula em vídeo

# Cluster # 2: Análise do gráfico na aula em vídeo

# Cluster # 3: Análise do gráfico na aula em vídeo

# Cluster # 4: Análise do gráfico na aula em vídeo

# Cluster # 5: Análise do gráfico na aula em vídeo


# Vamos criar a matriz de distância (Euclidiana) e usá-la para construir um dendograma

# Preparando os dados
df_variaveis_quantitativas1 <- data.frame(clientes$Fidelidade, clientes$CobrancaMensal, clientes$CobrancaTotal)
df_variaveis_quantitativas1
View(df_variaveis_quantitativas1)

# Padronizando as variáveis
df_variaveis_quantitativas_scaled <- scale(df_variaveis_quantitativas1[,])
View(df_variaveis_quantitativas_scaled)

# Filtrando as 20 primeiras linhas
df_variaveis_quantitativas_scaled_cluster <- df_variaveis_quantitativas_scaled[c(1:20),]
View(df_variaveis_quantitativas_scaled_cluster)

# Cria uma matriz de distância (Euclidiana) dos dados padronizados
?dist
dist.clientes <- dist(df_variaveis_quantitativas_scaled_cluster, method = "euclidean")
dist.clientes

# Hclust (análise de cluster pelo método de ligação única)
?hclust
hclust_clientes <- hclust(dist.clientes, method = "single")
hclust_clientes

# Plot

# Cria uma margem extra no dendograma na parte inferior (rótulos)
par(mar = c(8, 4, 4, 2) + 0.1)

# Dendograma da Distância Entre Clusters
plot(as.dendrogram(hclust_clientes),
     ylab = "Distância Entre Clusters",
     ylim = c(0,6),
     main = "Dendrograma")

# Ajusta o layout do gráfico anterior
dev.new()
par(mar=c(5, 4, 4, 7) + 0.1)
plot(as.dendrogram(hclust_clientes), 
     xlab = "Distância Entre Clusters", 
     xlim = c(6,0),
     horiz = TRUE,
     main = "Dendrograma")





