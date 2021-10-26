# Indexação em Dataframes e Listas 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# Um dos recursos essenciais da linguagem R é sua capacidade robusta de manipular e processar 
# operações estatísticas complexas com uma estratégia otimizada.

# R lida com cálculos complexos usando essas estruturas de dados:

# Vetores (1D) - Uma estrutura de dados básicos.
# Matrizes (2D) - Uma estrutura de duas dimensões de números ou outros tipos de objetos matemáticos. 
# Arrays (nD) - Um estrutura com qualquer número de dimensões.
# Listas (Heterogêneo) - As listas armazenam coleções de objetos.
# DataFrames (Heterogêneo) - Gerados pela combinação de múltiplos vetores, de forma que cada vetor se torne uma coluna separada.

# Dataframes
df <- data.frame(x = 1:3, y = c("a", "b", "c"))
df
str(df)

df <- data.frame(x = 1:3, y = c("a", "b", "c"), stringsAsFactors = FALSE)
df
str(df)
typeof(df)
class(df)

int_vec <- c(1,2,3) 
char_vec <- c("a", "b", "c")
bool_vec <- c(TRUE, TRUE, FALSE)
data_frame <- data.frame(int_vec, char_vec, bool_vec)
data_frame

# Indexação
dados_empregados <- data.frame(
  emp_id = c (1:5),
  emp_nome = c("Bob","Rita","Carlos","Maciel","Oliveira"),
  salario = c(742.3,935.2,381.0,639.0,825.26),
  data_inicio = as.Date(c("2018-02-04", "2018-06-21", "2017-11-14", "2018-05-19","2018-03-25")),
  stringsAsFactors = FALSE)

dados_empregados
str(dados_empregados)
emp_nomes <- dados_empregados$emp_nome
emp_nomes
dados_empregados[1,2]
dados_empregados[1:2,]
dados_empregados[c(1,2),c(3,4)]
dados_empregados$dept <- c("Data Science","Financeiro","Operações","RH","Gestão")
dados_empregados

novos_empregados <- data.frame(
  emp_id = c (6:8),
  emp_nome = c("Maria", "Tavares", "Roberval"),
  salario = c(823.0,621.3,722.8),
  data_inicio = as.Date(c("2019-06-22","2019-04-30","2019-03-17")),
  dept = c('Data Science', 'TI', 'RH'),
  stringsAsFactors = FALSE
)

novos_empregados

empregados_final <- rbind(dados_empregados, novos_empregados)
empregados_final


# Listas
list_data <- list("Branco", "Vermelho", c(4,5,6), TRUE, 49.5)
print(list_data)

num_vec <- c(1,2,3)
char_vec <- c("Hadoop", "Spark", "Flume", "Mahout")
logic_vec <- c(TRUE, FALSE, TRUE, FALSE)
lst1 <- list(num_vec, char_vec, logic_vec)
lst1

# Indexação 
data_list <- list(c("Jan","Feb","Mar"), matrix(c(1,2,3,4,-1,9), nrow = 2), list("Vermelho", "Azul"))
names(data_list) <- c("Meses", "Valores", "Cores")
print(data_list)

print(data_list[1])   
print(data_list[1][1]) 
print(data_list[[1]][[1]]) 

print(data_list[3])   
print(data_list[[3]][[1]]) 
data_list[[3]][[1]] <- "Amarelo"
print(data_list[[3]][[1]]) 







