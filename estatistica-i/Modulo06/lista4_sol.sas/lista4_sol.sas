/* Solução lista 4 de Exercícios em SAS  */

/* Carrega o dataset */
PROC IMPORT datafile="/folders/myshortcuts/AnaliseEstatisticaI/Modulo05/Lista4/dataset.csv" out=dataset dbms=CSV replace;
delimiter=';'; 
run; 


/* 1- Qual o total de pessoas com ensino médio na capital?  */
PROC FREQ DATA = dataset; 
TABLE grau_instrucao; 
run;  


/* 2- Qual o percentual de pessoas do interior com ensino superior? */
PROC FREQ DATA = dataset; 
TABLE grau_instrucao; 
run; 


/* 3- Crie um Stacked Bar Chart para representar a relação entre o grau de instrução e a região de procedência. */
PROC SGPLOT DATA = dataset;
  title 'Stacked Bar: Distribuição da região de procedência por grau de instrução';
  vbar grau_instrucao / group=reg_procedencia stat=sum;
  xaxis display=(nolabel);
  yaxis grid label='Frequência';
  run;


/* 4- Qual a relação entre grau de instrução e estado civil? */
PROC FREQ DATA = dataset; 
TABLE grau_instrucao*estado_civil / chisq; 
run; 


/* 5- Vide script R */

/* 6- Vide script R */
|
/* 7- Vide script R */


/* 8- Calcule as medidas de posição da variável salário. */
PROC MEANS MEAN MEDIAN DATA = dataset; 
VAR salario;
run; 


/* 9- Calcule as medidas de dispersão da variável salário. */
PROC MEANS STD VAR DATA = dataset; 
VAR salario;
run; 


/* 10- Apresente o resultado da sua análise. */




