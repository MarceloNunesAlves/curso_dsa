# Análise Estatística Para Data Science II

# Mini-Projeto 7

# Market Basket Analysis Para Recomendações de Compras aos Clientes

# Leia a definição do projeto com a fonte de dados no Capítulo 13 do curso.

# Diretório de trabalho
getwd()
setwd("~/Dropbox/DSA/AnaliseEstatisticaII/Cap13")

# Pacotes
library(data.table)
library(dplyr)
library(ggplot2)
library(knitr)
library(stringr)
library(DT)
library(treemap)

# Carregando os dados
aisles <- read.csv('dados/aisles.csv')
departments <- read.csv('dados/departments.csv')
products <- read.csv('dados/products.csv')
orders <- read.csv('dados/orders.csv')
order_products_train <- read.csv('dados/order_products__train.csv')

# Dimensões
dim(aisles)
dim(departments)
dim(products)
dim(orders)
dim(order_products_train)

# Visualizando os dados
View(aisles)
View(departments)
View(products)
View(orders)
View(order_products_train)

# Tipos de dados
str(aisles)
str(departments)
str(products)
str(orders)
str(order_products_train)

# Manipulação de dados (converte colunas para o tipo fator)
aisles <- aisles %>% 
  mutate(aisle = as.factor(aisle))

departments <- departments %>% 
  mutate(department = as.factor(department))

products <- products %>% 
  mutate(product_name = as.factor(product_name))

products <- products %>% 
  mutate(organic = ifelse(str_detect(str_to_lower(products$product_name), 'organic'),
                          "organic", "not organic"), 
         organic = as.factor(organic))

orders <- orders %>% 
  mutate(order_hour_of_day = as.numeric(order_hour_of_day), 
         eval_set = as.factor(eval_set))

# Análise Exploratória
colors()

# Pedidos por hora do dia
orders %>% 
  ggplot(aes(x = order_hour_of_day)) + 
  geom_histogram(stat = "count", fill = "steelblue1")

# Número de dias desde o pedido anterior
orders %>% 
  ggplot(aes(x = days_since_prior_order)) + 
  geom_histogram(stat = "count", fill = "springgreen1")

# Número de pedidos x Número de itens no pedido
order_products_train %>% 
  group_by(order_id) %>% 
  summarize(n_items = last(add_to_cart_order)) %>%
  ggplot(aes(x = n_items)) +
  geom_histogram(stat = "count", fill = "turquoise4") + 
  geom_rug() +
  coord_cartesian(xlim = c(0,80))

# Produtos mais vendidos
tabela1 <- order_products_train %>% 
  group_by(product_id) %>% 
  summarize(count = n()) %>% 
  top_n(10, wt = count) %>%
  left_join(select(products, product_id, product_name), by = "product_id") %>%
  arrange(desc(count)) 

?kable
kable(tabela1)

# Tabela anterior no formato gráfico
tabela1 %>% 
  ggplot(aes(x = reorder(product_name, -count), y = count)) +
  geom_bar(stat = "identity", fill = "purple3") +
  theme(axis.text.x=element_text(angle = 90, hjust = 1), axis.title.x = element_blank())

# Produtos disponíveis para venda
tabela2 <- order_products_train %>% 
  group_by(product_id, add_to_cart_order) %>% 
  summarize(count = n()) %>% 
  mutate(pct = count/sum(count)) %>% 
  filter(add_to_cart_order == 1, count > 10) %>% 
  arrange(desc(pct)) %>% 
  left_join(products, by = "product_id") %>% 
  select(product_name, pct, count) %>% 
  ungroup() %>% 
  top_n(10, wt = pct)

kable(tabela2)

tabela2 %>% 
  ggplot(aes(x = reorder(product_name, -pct), y = pct)) +
  geom_bar(stat = "identity", fill = "honeydew3") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        axis.title.x = element_blank()) +
  coord_cartesian(ylim = c(0.4,0.7))

# Média de "reorder" desde o pedido anterior
order_products_train %>% 
  left_join(orders, by = "order_id") %>% 
  group_by(days_since_prior_order) %>%
  summarize(mean_reorder = mean(reordered)) %>%
  ggplot(aes(x = days_since_prior_order, y = mean_reorder))+
  geom_bar(stat  = "identity", fill = "tomato4")

# Proporção de "reorder"
order_products_train %>% 
  group_by(product_id) %>% 
  summarize(proportion_reordered = mean(reordered), n = n()) %>%
  ggplot(aes(x = n, y = proportion_reordered)) +
  geom_point() +
  geom_smooth(color = "yellow4")+
  coord_cartesian(xlim = c(0,2000))

# Proporção entre produtos orgânicos e não orgânicos
tabela3 <- order_products_train %>% 
  left_join(products, by="product_id") %>% 
  group_by(organic) %>% 
  summarize(count = n()) %>% 
  mutate(proportion = count/sum(count))

kable(tabela3)

tabela3 %>% 
  ggplot(aes(x = organic, y = count, fill = organic)) +
  geom_bar(stat = "identity") + scale_fill_manual(values = c("#696969","#006400"))

# Média de "reorder" por tipo de produto
tabela4 <- order_products_train %>% 
  left_join(products, by = "product_id") %>% 
  group_by(organic) %>% 
  summarize(mean_reordered = mean(reordered))

kable(tabela4)

tabela4 %>% 
  ggplot(aes(x = organic, fill = organic, y = mean_reordered)) +
  geom_bar(stat="identity") +
  scale_fill_manual(values = c("#696969", "#006400"))

# Mapa de calor (heatmap)

# A tabela5 contém os produtos por corredor e departamento
tabela5 <- products %>% 
  group_by(department_id, aisle_id) %>% 
  summarize(n = n())

tabela5 <- tabela5 %>% 
  left_join(departments, by = "department_id")

tabela5 <- tabela5 %>% 
  left_join(aisles, by = "aisle_id")

# A tabela6 contém os produtos por corredor e departamento, junto com os pedidos associados
tabela6 <- order_products_train %>% 
  group_by(product_id) %>% 
  summarize(count = n()) %>% 
  left_join(products, by = "product_id") %>% 
  ungroup() %>% 
  group_by(department_id, aisle_id) %>% 
  summarize(sumcount = sum(count)) %>% 
  left_join(tabela5, by = c("department_id", "aisle_id")) %>% 
  mutate(onesize = 1)

?treemap
treemap(tabela6, 
        index = c("department", "aisle"),
        vSize = "onesize",
        vColor = "department",
        palette = "Set3",
        title = "Heatmap Pedido Por Departamento e Corredor",
        sortID = "-sumcount", 
        border.col = "#FFFFFF",
        type = "categorical",
        fontsize.legend = 0,
        bg.labels = "#FFFFFF")

# Fim