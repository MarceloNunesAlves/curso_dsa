/* Solução lista 2 de Exercícios em SAS  */

/* Carrega o dataset */
PROC IMPORT datafile="/folders/myshortcuts/AnaliseEstatisticaI/Modulo03/Lista2/dataset.csv" out=dataset dbms=CSV replace; 
run; 


/* 1- Quais as 3 cores dos veículos mais vendidos? */
PROC FREQ DATA = dataset; 
TABLE cor; 
run; 


/* 2- De qual ano são os veículos mais vendidos? */

PROC FREQ DATA = dataset ORDER = freq; 
TABLE ano; 
run; 

/* 3- Crie um barplot para apresentar sua resposta no item 2. */
PROC CHART DATA = dataset; 
VBAR ano / descending; 
run; 
QUIT; 


/* 4- Qual o percentual de vendas de veículos com transmissão automática? */

PROC FREQ DATA = dataset; 
TABLE transmissao; 
run; 


/* 5- Crie um Pie Chart para representar sua resposta no item 4. */ 
PROC CHART DATA = dataset; 
PIE transmissao; 
run; 


/* 6- Qual o percentual de venda de veículos por modelo? */
PROC FREQ DATA = dataset ORDER = freq; 
TABLE modelo; 
run; 

/* 7- Calcule o percentual de vendas por preço de veículo e o percentual acumulado */
PROC FREQ DATA = dataset ORDER = freq; 
TABLE preco; 
run; 

/* 8- Liste o total de veículos vendidos por ano e por tipo de transmissão */
PROC FREQ DATA = dataset; 
TABLE ano*transmissao / list; 
run; 

/* 9- Imprima um resumo estatístico com o teste do qui-quadrado, graus de liberdade e valor p do resultado do item anterior */
PROC FREQ DATA = dataset; 
TABLE ano*transmissao / chisq; 
run; 

/* 10- Crie um barplot a partir do resultado do item 8 */
PROC SGPLOT DATA = dataset; 
VBAR ano /group = transmissao GROUPDISPLAY = CLUSTER; 
TITLE 'Venda de Veiculos por ano / Tipo Transmissao'; 
run;


