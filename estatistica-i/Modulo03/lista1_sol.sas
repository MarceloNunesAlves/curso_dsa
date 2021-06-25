/* Solução lista 1 de Exercícios em SAS  */


/* Carrega o dataset */

PROC IMPORT datafile="/folders/myshortcuts/AnaliseEstatisticaI/Lista1/hour.csv" out=hour dbms=CSV replace;
run;


/* Calcula a média, mediana e moda */

PROC MEANS data=WORK.hour MEAN Median Mode;
run;


/* Calcula a temperatura (coluna temp) média por dia da semana (coluna weekday) */

PROC MEANS data=work.hour MEAN;
class weekday;
VAR temp;
run;

/* Cria um histograma na coluna temp */

PROC univariate data = work.hour;
var temp;
histogram;
run;



