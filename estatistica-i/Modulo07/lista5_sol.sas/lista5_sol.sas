/* Solução lista 5 de Exercícios em SAS  */

/* Carrega o dataset */
FILENAME REFFILE '/folders/myshortcuts/AnaliseEstatisticaI/Modulo07/Lista5/exame.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.EXAME;
	GETNAMES=YES;
RUN;


/* 1- Usando a Proc Tabulate, crie uma tabela resumida pela variável sexo  */
PROC tabulate data=exame;
	class Sexo;
	table Sexo;
run;


/* 2- Usando a Proc Tabulate, crie uma tabela resumida pela variável sexo e pela variável tipo  */
PROC tabulate data=exame;
	class Sexo Tipo;
	table Sexo Tipo;
run;


/* 3- Usando a Proc Tabulate, crie uma tabela resumida pela variável tipo com os percentuais por tipo  */
PROC tabulate data=exame;
	class Tipo;
	table Tipo * (n pctn);
run;


/* 4- Usando a Proc Tabulate, crie uma tabela resumida pelas variáveis sexo e tipo e com percentuais por coluna  */
PROC tabulate data=exame;
	class Sexo Tipo;
	table (Tipo), (Sexo ALL)*(n*f=5. colpctn*f=Pctfmt7.1) /RTS=25;
	keylabel All='Todos os Sexos' n='Count' colpctn='%';
run;
