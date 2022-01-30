# Análise Estatística Para Data Science II

# Mini-Projeto 7

# Market Basket Analysis Para Recomendações de Compras aos Clientes

# Acompanhe as aulas no Capítulo 13 com os detalhes sobre este script.

# Pacotes
library(dplyr)
library(tidyr)

# Carregando os dados
# Para maior precisão do modelo vamos usar o dataset "order_products__prior.csv"
aisles <- read.csv('dados/aisles.csv')
departments <- read.csv('dados/departments.csv')
products <- read.csv('dados/products.csv')
orders <- read.csv('dados/orders.csv')
order_products_train <- read.csv('dados/order_products__train.csv')
order_products_prior <- read.csv('dados/order_products__prior.csv')

# Preparando a tabela de usuários-pedidos-produtos
users_orders_products <- orders %>% inner_join(order_products_prior) %>% 
  left_join(products) %>% 
  left_join(aisles) %>% 
  left_join(departments) %>% 
  arrange(user_id, order_number) %>% 
  select(user_id, order_id, order_number, order_dow, order_hour_of_day, 
         days_since_prior_order, product_id, product_name, reordered, 
         add_to_cart_order, department_id, aisle_id, department, aisle)

dim(users_orders_products)
head(users_orders_products, 5)

# Cria uma lista para todos os usuários
lista_usuarios = orders %>% 
  filter(eval_set == 'train') %>% 
  distinct(user_id)

# Divisão da lista de usuários em treino e teste com split 70/30
set.seed(12345)
proporcao_treino = 0.7
index = sample( 1:nrow(lista_usuarios), proporcao_treino * nrow(lista_usuarios) )
users_treino = lista_usuarios[index,]  
users_teste  = lista_usuarios[-index,] 

# Criando o dataset de treino

# Lista de produtos no pedido. Usaremos isso como label.
df1 = orders %>%    
  filter(user_id %in% users_treino, eval_set=='train') %>% 
  left_join(order_products_train) %>%
  distinct(user_id, product_id) %>%
  mutate(actual = 1) 

# Lista de produtos que cada usuário comprou antes em pedidos anteriores.
df2 = orders %>%   
  filter(user_id %in% users_treino, eval_set == 'prior') %>% 
  left_join(order_products_prior) %>%
  distinct(user_id, product_id)

# Cria o dataset de treino
df_treino = left_join(df1, df2) %>%
  mutate(key = paste(user_id, product_id, sep = "-")) %>%  
  select(key, user_id, product_id, actual) %>%
  arrange(user_id, product_id) %>%
  replace_na(list(actual = 0)) 

# Remove objetos não mais necessários para liberar memória
rm(list=c('df1','df2'))

# Visualiza os dados
View(df_treino)

# Criando o dataset de teste no mesmo padrão usado em treino

df1 = orders %>%    
  filter(user_id %in% users_teste, eval_set=='train') %>% 
  left_join(order_products_train) %>%
  distinct(user_id, product_id) %>%
  mutate(actual=1) 

df2 = orders %>%   
  filter(user_id %in% users_teste, eval_set=='prior') %>% 
  left_join(order_products_prior) %>%
  distinct(user_id,product_id)

df_teste = left_join(df1, df2) %>%
  mutate(key = paste(user_id, product_id, sep = "-")) %>%  
  select(key, user_id, product_id, actual) %>%
  arrange(user_id, product_id) %>%
  replace_na(list(actual = 0)) 

# Drop
rm(list=c('df1','df2'))

# Visualiza
View(df_teste)

# Prepara o dataset de treino final
df_treino_final = users_orders_products %>%
  filter(user_id %in% users_treino) %>%
  left_join(users_orders_products) %>% 
  left_join(products) %>%
  full_join(df_treino, by = c('user_id', 'product_id')) %>%
  arrange(user_id, product_id) %>%
  select(-c('key',
            'user_id', 
            'order_id', 
            'product_id', 
            'product_name', 
            'department_id', 
            'aisle_id', 
            'department',
            'aisle', 
            'days_since_prior_order')) 

glimpse(df_treino_final)
dim(df_treino_final)

# Remove os valores NA
df_treino_final <- na.omit(df_treino_final)
dim(df_treino_final)
View(df_treino_final)

# Prepara o dataset de teste final
df_teste_final = users_orders_products %>%
  filter(user_id %in% users_teste) %>%
  left_join(users_orders_products) %>% 
  left_join(products) %>%
  full_join(df_teste, by=c('user_id','product_id')) %>%
  arrange(user_id, product_id) %>%
  select(-c('key',
            'user_id',
            'order_id', 
            'product_id', 
            'product_name', 
            'department_id', 
            'aisle_id', 
            'department',
            'aisle', 
            'days_since_prior_order')) 

glimpse(df_teste_final)
dim(df_teste_final)

# Remove os valores NA
df_teste_final <- na.omit(df_teste_final)
dim(df_teste_final)
View(df_teste_final)

# Modelagem com Regressão Logística
?glm
modelo = glm(actual ~ ., family = gaussian, data = df_treino_final)

# Sumário do modelo
summary(modelo) 





