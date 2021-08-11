/* Solução lista 6 de Exercícios em SAS  */

/* Criando um dataset */
data Iris;
	input SepalLength SepalWidth PetalLength PetalWidth @@;
	label sepallength='Sepal Length' sepalwidth='Sepal Width' 
		petallength='Petal Length' petalwidth='Petal Width';
	datalines;
   50 33 14 02  46 34 14 03  46 36 .  02
   51 33 17 05  55 35 13 02  48 31 16 02
   52 34 14 02  49 36 14 01  44 32 13 02
   50 35 16 06  44 30 13 02  47 32 16 02
   48 30 14 03  51 38 16 02  48 34 19 02
   50 30 16 02  50 32 12 02  43 30 11 .
   58 40 12 02  51 38 19 04  49 30 14 02
   51 35 14 02  50 34 16 04  46 32 14 02
   57 44 15 04  50 36 14 02  54 34 15 04
   52 41 15 .   55 42 14 02  49 31 15 02
   54 39 17 04  50 34 15 02  44 29 14 02
   47 32 13 02  46 31 15 02  51 34 15 02
   50 35 13 03  49 31 15 01  54 37 15 02
   54 39 13 04  51 35 14 03  48 34 16 02
   48 30 14 01  45 23 13 03  57 38 17 03
   51 38 15 03  54 34 17 02  51 37 15 04
   52 35 15 02  53 37 15 02
   ;

/* Exercício 1 - Correlação */
proc corr data=Iris;
	var sepallength sepalwidth petallength petalwidth;
run;


/* Exercício 2 - Poisson */
%let lambda=4;

data Poisson_PMF;
	do k=0 to 10;
		PMF = pdf('Poisson', k, &lambda);
		output;
	end;
run;

title "Poisson Probability Mass Function.";

proc sgplot data=Poisson_PMF noautolegend;
	vbar k / response=PMF barwidth=0.5 legendlabel="PMF";
	keylegend / location=inside position=NE across=1;
	yaxis display=(nolabel);
run;


/* Exercício 3 - Binomial */

/* PDF ('BINOMIAL', m, p, n) */
* m - variável aleatória;
* p - especfica a probabilidade de sucesso; 
* n - parâmetro que conta o número de tentativas;

data _null_;
   do;
      y=pdf('BINOM', 1, .10, 4);
      put 'Probabilidade:     ' y;
   end;
run;
