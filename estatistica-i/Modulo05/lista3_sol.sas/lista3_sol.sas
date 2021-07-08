/* Solução lista 3 de Exercícios em SAS  */

/* Carrega o dataset */
PROC IMPORT datafile="/folders/myshortcuts/AnaliseEstatisticaI/Modulo04/Lista3/dataset.csv" out=dataset dbms=CSV replace; 
run; 


/* 1- Qual o tempo médio de atendimento? */
PROC MEANS MEAN DATA = dataset; 
VAR tempo_telefone;
run; 


/* 2- Qual a mediana do tempo de atendimento? */
PROC MEANS MEDIAN DATA = dataset; 
VAR tempo_telefone; 
run; 


/* 3- Qual o desvio padrão e variância do tempo de atendimento? */
PROC MEANS STD VAR DATA = dataset; 
VAR tempo_telefone; 
run; 


/* 4- Quais os quartis e percentis 32, 57 e 98 do tempo de atendimento? */
PROC UNIVARIATE DATA = dataset NOPRINT;
   VAR tempo_telefone;
   OUTPUT out = Pctls pctlpts  = 32 57 98
                      pctlpre  = medida_
                      pctlname = pct32 pct57 pct98;
run;

PROC MEANS Q1 Q3 DATA = dataset;
VAR tempo_telefone;
run;


/* 5- Qual o intervalo interquartil do tempo de atendimento? */
PROC MEANS QRANGE DATA = dataset; 
VAR tempo_telefone; 
run; 


/* 6- Crie um boxplot que represente as medidas anteriores. */
PROC SGPLOT DATA = dataset; 
VBOX tempo_telefone;
run; 


/* 7- A covariância de duas variáveis x e y em um conjunto de dados mede como as duas estão 
linearmente relacionadas. Uma covariância positiva indicaria uma relação linear positiva entre as 
variáveis e uma covariância negativa indicaria o contrário. Calcule a covariância  entre  o  tempo  
de atendimentoe o total de clientes. O que o resultado indica? */
PROC CORR COV DATA = dataset; 
VAR tempo_telefone clientes;
run;


/* 8- Calcule a Frequência Absoluta da variável tempo de atendimento. */
PROC FREQ DATA = dataset; 
TABLE tempo_telefone; 
run; 


/* 9- Crie um histograma que represente sua resposta no item anterior. */
PROC UNIVARIATE DATA = dataset;
VAR tempo_telefone;
histogram;
run;


/* 10- Calcule a Frequência Relativa e Acumulada da variável tempo de atendimento. */
PROC FREQ DATA = dataset; 
TABLE tempo_telefone; 
run;


/* 11- Crie um gráfico de linha para a Frequência Acumulada. */
/* https://support.sas.com/sassamples/graphgallery/PROC_GPLOT.html */
title 'Distribuição Acumulada ';
ods graphics on;
PROC UNIVARIATE DATA = dataset NOPRINT;
   cdf tempo_telefone / normal;
run;

/* 12- Crie um gráfico de dispersão para representar a relação entre as duas variáveis no dataset */
PROC SGPLOT DATA = dataset; 
SCATTER x=tempo_telefone y=clientes;
run; 





