# Lookup Tables 

# Definindo o diretório de trabalho
# setwd("/Users/dmpm/Dropbox/DSA/AnaliseEstatisticaII/Cap02")
# getwd()

# Em muitas análises, os dados são lidos de um arquivo, mas devem ser modificados antes de poderem ser usados. 
# Por exemplo, você pode querer adicionar uma nova coluna de dados ou fazer um "encontrar" e "substituir" 
# nos dados a fim de substituir uma determinada informação.

# Existem 3 maneiras de conseguir isso: 

# A primeira envolve editar os dados originais - embora você nunca deva fazer isso, suspeito que esse método seja bastante comum. 
# Uma segunda - e amplamente utilizada - abordagem para adicionar informações é modificar os valores usando código em seu script. 
# A terceira - e mais agradável e performática - maneira de adicionar informações é usar uma tabela de pesquisa (lookup table).


# Em Ciência da Computação, uma tabela de pesquisa (lookup table) é uma matriz que 
# substitui a computação de tempo de execução por uma operação de indexação de matriz mais simples. 
# A economia em termos de tempo de processamento pode ser significativa, já que recuperar um valor 
# da memória é geralmente mais rápido do que executar uma operação de entrada/saída.

# Dataframe com os dados originais
nome <- c("Bob", "Maria", "Angela", "Harry", "Gutemberg")
sexo <- c(1,1,2,1,2)
dados <- data.frame (nome, sexo)
dados

# Lookup table
s_code <- c(1,2)
sexo_nome <- c("Masculino","Feminino")
lookupTable <- data.frame(s_code, sexo_nome)
lookupTable

# Pesquisando na Lookup Table e ajustando as colunas de sexo
# de-para
?match
dados$sexo = lookupTable[match(dados$sexo, lookupTable$s_code), "sexo_nome"] 
View(dados)










