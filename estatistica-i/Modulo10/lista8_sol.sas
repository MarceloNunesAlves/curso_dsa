/* Solução lista 8 de Exercícios em SAS  */

/* 

Suponha que apenas 50.000 bebês nasceram no Brasil em 1997, portanto, temos dados disponíveis em toda a população de interesse. Queremos medir:

1. O peso médio de uma criança que nasceu em 1997.

2. O peso médio de uma criança do sexo masculino e outra do sexo feminino em 1997.

Métodos de amostragem a serem usados

1. Amostragem aleatória simples
2. Amostragem aleatória estratificada

Vamos usar o dataset bweight que está disponível na library SASHELP. Vamos ao trabalho.

*/

/* Carregando o Dataset */

data nascimentos (keep=weight boy);
	set sashelp.bweight;
run;


/* Exercício 1 - Usando a PROC SQL, calcule o peso médio de todas as crianças, 
o peso médio de meninos (coluna boy = 1) 
e o peso médio de meninas (coluna boy = 0). */
PROC sql;
	select round(avg(weight), .01) as media_peso,
		   round(avg(case when boy=1 then weight end), .01) as media_peso_masculino,
		   round(avg(case when boy=0 then weight end), .01) as media_peso_feminino
	from nascimentos;
quit;


/* Exercício 2 - Usando a PROC SQL, crie uma amostra randômica equivalente a 10% do dataset original. 
Dica: use a função ranuni() para gerar valores randômicos usados para selecionar os dados. */
PROC sql;
	create table amostra_10_porcento as
	select *
	from nascimentos
	where ranuni(0) < 0.1;
quit;


/* Exercício 3 - Usando a PROC SQL, crie uma amostra randômica equivalente a 5000 registros do dataset original. 
Dica: use a função ranuni() para gerar valores randômicos usados para selecionar os dados. */
PROC sql outobs=5000;
	create table amostra_5000_registros as
	select *
	from nascimentos
	where ranuni(0);
quit;


/* Exercício 4 - Usando a PROC surveyselect, crie duas amostras com os mesmos critérios 
dos exercícios 2 e 3. Dica: use o método SRS (Simple Random Sampling) da proc surveyselect. */
PROC surveyselect data=nascimentos
	out=amostra_10_porcento_survey
	method=srs
	samprate=0.1;
quit;

PROC surveyselect data=nascimentos
	out=amostra_5000_registros_survey
	method=srs
	sampsize=5000;
quit;


/* Exercício 5 - Usando a PROC SQL, criaremos uma amostra estratificada. 
Primeiro, crie duas amostras, com 2500 registros cada uma. 
A primeira amostra deve conter somente crianças do sexo masculino e a segunda 
somente crianças do sexo feminino. Depois faça a junção das duas amostras criando a amostra final. */

PROC sql outobs=2500;
	create table amostra_2500_registros_fem as
	select *
	from nascimentos
	where boy=0
	order by ranuni(0);
quit;

PROC sql outobs=2500;
	create table amostra_2500_registros_mas as
	select *
	from nascimentos
	where boy=1
	order by ranuni(0);
quit;


PROC sql;
	create table amostra_5000_registros_append as
	select *
	from amostra_2500_registros_fem
	union corresponding all(select * from amostra_2500_registros_mas);
quit;





