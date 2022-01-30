# Projeto de Análise Multivariada - Por Que os Clientes Cancelam Seus Planos de Assinatura Mensal?

# Neste projeto vamos analisar um conjunto de dados com registros e informações de clientes de 
# uma operadora de telefonia. 

# Nosso objetivo será analisar e compreender as razões pelas quais um cliente cancela seu 
# plano de assinatura mensal e estudar a relação entre as muitas variáveis disponíveis.

# Executaremos o projeto em 4 etapas:

# Etapa 1 - Análise Exploratória, Limpeza e Transformação de Dados
# Etapa 2 - Análise de Cluster
# Etapa 3 - Análise Fatorial
# Etapa 4 - Análise de Componentes Principais

# As etapas 2, 3, e 4 são técnicas de análise multivariada. Na etapa 1 usaremos ferramentas 
# para análise multivariada, como gráficos em grid.


# E para guiar nossa análise, usaremos a técnica de Plano de Análise Estruturada em Pirâmide 
# (SPAP - Structured Pyramid Analysis Plan).

# O Plano de Análise Estruturada em Pirâmide (SPAP) é uma abordagem metodológica para dividir o 
# escopo de análise desejado em objetivos mensuráveis e realistas. Ajuda a simplificar o processo, 
# o esforço e os recursos necessários para restringir cada ação de trabalho do escopo para alcançar 
# a visão desejada.

# Uma abordagem de cima para baixo (top-down) é o que melhor define a mecânica de uma análise SPAP. 
# Também conhecido como design passo a passo e, em alguns casos, usado como sinônimo de decomposição, 
# é essencialmente a quebra de um sistema para obter insights sobre seus subsistemas de composição 
# de maneira reversa. A análise de cima para baixo geralmente se refere ao uso de fatores 
# abrangentes como base para a tomada de decisão. Com SPAP o objetivo é identificar o panorama geral e 
# todos os seus componentes. Esses componentes geralmente serão a força motriz para o objetivo final. 

# Um analista que busca uma perspectiva de cima para baixo vai querer ver como os fatores 
# sistemáticos estão afetando um resultado. Nas finanças corporativas, isso pode significar entender 
# como as grandes tendências estão afetando todo o setor. No orçamento, na definição de metas e na 
# previsão, o mesmo conceito também pode ser aplicado para entender e gerenciar os fatores macro.


# Objetivo SMART.

# Para aplicar o SPAP, precisamos definir metas (objetivos) que sejam S.M.A.R.T. 

# Specific (simple, sensible, significant).
# Measurable (meaningful, motivating).
# Achievable (agreed, attainable).
# Relevant (reasonable, realistic and resourced, results-based).
# Time bound (time-based, time limited, time/cost limited, timely, time-sensitive).

# Em português: (específica, mensurável, atingível, realista e com limite de tempo).

# Exemplo:

# Meta definida de forma ruim: Pretendo ler mais livros.
# Meta definida de forma SMART: Pretendo ler 6 livros em 12 meses.


# A meta SMART para nosso projeto será:

# Pergunta principal: Quais são os fatores que afetam a desistência de clientes em um ano fiscal?

# Essa meta pode então ser subdividia (top-down) em sub-metas, com as seguintes perguntas auxiliares:

# 1. Qual é o efeito da demografia na desistência?
# 2. Ser idoso causa menos desistência?
# 3. Não ter dependentes leva a mais desistência?
# 4. Que tipo de serviço faz com que o cliente fique / saia?
# 5. Não ter suporte técnico faz com que mais clientes saiam?
# 6. A desistência é menor no caso de nenhum serviço de internet?
# 7. O faturamento e seu serviço relacionado afetam a desistência?
# 8. Clientes com assinatura mensal são mais propensos a desistência?
# 9. O método de pagamento automático com cartão de crédito causa menos desistência?
# 10- Qual grupo desiste mais, clientes que pagam mais ou clientes que pagam menos, no total?


# Os Principais Indicadores de Desempenho (KPIs) para medir o sucesso da questão principal do nosso 
# projeto são os seguintes:

# 1. Demografia
# 2. Serviços
# 3. Faturamento

# 1- A análise levou em consideração diferentes itens de demografia?
# 2- Todos os serviços (ou pelo menos serviços principais) foram considerados na análise?
# 3- Diferentes níveis de faturamento foram considerados? 


# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap09")

# Pacotes
install.packages("readr")
install.packages("magrittr") 
install.packages("dplyr")
library(readr)
library(plyr)
library(ggplot2)
library(magrittr) 
library(dplyr) 
library(tidyr)
library(gridExtra)
library(corrplot)

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

# Variável CidadaoSenior deve ser fator e não numérica
str(clientes$CidadaoSenior)
clientes$CidadaoSenior <- factor(clientes$CidadaoSenior)

# Verificando fidelidade do cliente
min(clientes$Fidelidade)
max(clientes$Fidelidade)
max(clientes$CobrancaMensal)

# Ajustando a variável target para valores 0 e 1
# 0 - Não desistiu de ser cliente
# 1 - Desistiu de ser cliente
str(clientes$ClienteChurn)
clientes$ClienteChurn <- factor(ifelse(clientes$ClienteChurn == 'No', 0, 1))

# Verificando proporção de clientes por tipo de churn (cancelamento)
table(clientes$ClienteChurn)
prop.table(table(clientes$ClienteChurn)) * 100

# Usando dplyr para obter o mesmo resultado mas no formato de coluna
tabela_cliente <- clientes %>% group_by(ClienteChurn) %>% 
  summarise(Total = length(ClienteChurn)) %>%
  mutate(Taxa = Total / sum(Total) * 100.0)

print(tabela_cliente)

# Plot
ggplot(tabela_cliente, aes(x = '', y = Taxa, fill = ClienteChurn)) +
  geom_bar(width = 1, size = 1, color = 'black', stat = 'identity') +
  coord_polar('y') +
  geom_text(aes(label = paste0(round(Taxa), '%')), 
            position = position_stack(vjust = 0.5)) +
  scale_fill_manual(values = c("#999999", "#E69F00"))+
  labs(title = 'Taxa de Desistência') +
  theme_classic() +
  theme(axis.line = element_blank(),axis.title.x = element_blank(),axis.title.y = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank())


# Cria uma cópia do datataset
clientes_copia <- clientes
View(clientes_copia)

# Grids de Gráficos Para a Relação das Variáveis Explicativas com a Variável Alvo

# Vamos fazer um "recode"
# Todas as variáveis que tiverem valor "No internet service" convertemos para "No"

# Lista com as variáveis que receberão o recode
cols_recode1 <- c(10:15)

View(clientes[, cols_recode1][, 1])

# Loop mapvalue por coluna
for (i in 1:ncol(clientes[, cols_recode1])) {
  clientes[, cols_recode1][, i] <- as.factor(mapvalues(clientes[, cols_recode1][, i], 
                                                       from = c("No internet service"), 
                                                       to = c("No")))
}

str(clientes)
View(clientes)

# Vamos fazer o mesmo com a variável "LinhasMultiplas"
clientes$LinhasMultiplas <- as.factor(mapvalues(clientes$LinhasMultiplas, 
                                                from = c("No phone service"), 
                                                to = c("No")))

str(clientes)
View(clientes)

# Preparando gráficos para criar um grid
b1 <- ggplot(clientes, aes(Sexo, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b2 <- ggplot(clientes, aes(CidadaoSenior, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b3 <- ggplot(clientes, aes(Parceiro, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b4 <- ggplot(clientes, aes(Dependentes, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b5 <- ggplot(clientes, aes(ServicoTelefone, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b6 <- ggplot(clientes, aes(LinhasMultiplas, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b7 <- ggplot(clientes, aes(ServicoInternet, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b8 <- ggplot(clientes, aes(SegurancaOnline, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b9 <- ggplot(clientes, aes(BackupOnline, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b10 <- ggplot(clientes, aes(ProtecaoDispositivo, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b11 <- ggplot(clientes, aes(SuporteTecnico, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b12 <- ggplot(clientes, aes(StreamingTV, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b13 <- ggplot(clientes, aes(StreamingFilmes, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b14 <- ggplot(clientes, aes(Contrato, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b15 <- ggplot(clientes, aes(FaturaOnline, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))
b16 <- ggplot(clientes, aes(MetodoPagamento, fill = ClienteChurn)) + geom_bar(position='fill') + scale_fill_manual(values=c("#999999", "#E69F00"))

# Criando o grid
grid.arrange(b1,b2,b3,b4, ncol = 2)
grid.arrange(b5,b6,b7,b8, ncol = 2)
grid.arrange(b9,b10,b11,b12, ncol = 2)
grid.arrange(b13,b14,b15,b16, ncol = 2)

# Vamos criar uma varável para representar a faixa mensal de cobrança de cada cliente
# Primeiro vamos criar as faixas
clientes$CobrancaMensalFaixa <- NA
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 0 & clientes$CobrancaMensal <= 10] <- '10'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 10 & clientes$CobrancaMensal <= 20] <- '20'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 20 & clientes$CobrancaMensal <= 30] <- '30'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 30 & clientes$CobrancaMensal <= 40] <- '40'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 40 & clientes$CobrancaMensal <= 50] <- '50'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 50 & clientes$CobrancaMensal <= 60] <- '60'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 60 & clientes$CobrancaMensal <= 70] <- '70'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 70 & clientes$CobrancaMensal <= 80] <- '80'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 80 & clientes$CobrancaMensal <= 90] <- '90'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 90 & clientes$CobrancaMensal <= 100] <- '100'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 100 & clientes$CobrancaMensal <= 110] <- '110'
clientes$CobrancaMensalFaixa[clientes$CobrancaMensal > 110 & clientes$CobrancaMensal <= 120] <- '120'

# E agora criamos a variável
clientes$CobrancaMensalFaixa <- factor(clientes$CobrancaMensalFaixa, 
                                       levels = c('10', '20', '30', '40', '50', 
                                                  '60', '70', '80', '90','100','110','120'))
# Cancelamento Por Faixa de Cobrança Mensal
ggplot(clientes, aes(CobrancaMensalFaixa, fill = ClienteChurn)) + 
  geom_bar(position='fill') + 
  scale_fill_manual(values=c("#999999", "#E69F00"))

# Boxplots
boxplot(clientes$CobrancaTotal, data = clientes, main = "Cobrança Total")
boxplot(clientes$CobrancaMensal, data = clientes, main = "Cobrança Mensal")
boxplot(clientes$Fidelidade, data = clientes, main = "Fidelidade")

# Vamos agora observar as variáveis com base na variável resposta
b1 <- boxplot(Fidelidade ~ ClienteChurn, 
              data = clientes,
              col = c("yellow","blue"), 
              xlab ="Churn" , 
              ylab = "Fidelidade")

b2 <- boxplot(CobrancaMensal ~ ClienteChurn, 
              data = clientes,
              col = c("yellow","blue"), 
              xlab ="Churn" , 
              ylab = "Cobrança Mensal")

b3 <- boxplot(CobrancaTotal ~ ClienteChurn, 
              data = clientes,
              col = c("yellow","blue"), 
              xlab ="Churn", 
              ylab = "Cobrança Total")

# Relação entre fidelidade e cobrança total
plot(clientes$CobrancaTotal, clientes$Fidelidade)

# Correlação
cor_data <- data.frame(clientes$Fidelidade, clientes$CobrancaMensal, clientes$CobrancaTotal)
corr <- cor(cor_data)
corrplot(corr, method = "number")

# Histograma
hist(clientes$Fidelidade, 
     main = "Distribuição de Fidelidade", 
     xlab = "Fidelidade (Meses)")

hist(clientes$CobrancaMensal, 
     main = "Distribuição de Cobrança Mensal", 
     xlab = "Cobrança Mensal", 
     xlim = c(0,120), 
     breaks = 12)

hist(clientes$CobrancaTotal, 
     main = "Distribuição de Cobrança Total", 
     xlab = "Cobrança Total")



