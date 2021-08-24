/* Solução lista 7 de Exercícios em SAS  */

/* Estudo de Caso 1 */

/* Carrega o dataset */
PROC import datafile="/folders/myshortcuts/AnaliseEstatisticaI/Modulo09/Lista7/blood_pressure.txt" 
	out=dataset dbms=CSV replace;
	delimiter = ','; 
run; 


* Calcula a média e tamanho tota da amostra;
PROC means data=dataset mean std;
 var mmhg;
 output out=resultado mean=meanvalue n=n_total;
run;


* Calculando estatística de teste e p-values;
data zteste; 
 set resultado;
 format p_value_A p_value_B p_value_C pvalue.;
 
 * Definindo o valor médio sob a hipótese nula;
 mu0 = 140;   
 
 * Definindo sigma conhecido;
 sigma = 20;  
 
 * Calculando o valor de z;
 z = sqrt(n_total) * (meanvalue - mu0) / sigma; 

 * Calculando o p-value para cada alternativa;
 p_value_A = 2*probnorm(-abs(z));
 p_value_B = 1-probnorm(z);
 p_value_C = probnorm(z); 
run;


* Print dos valores-p calculados;
PROC print;
 var z p_value_A p_value_B p_value_C ;
run; 

/* 

O valor-p nada mais é que uma probabilidade, que, obviamente, varia de 0 a 100%.

O valor-p avalia quão bem os dados da amostra suportam o argumento de que a 
hipótese nula é verdadeira. Ele mede quão compatíveis são seus dados com a hipótese nula. 
Qual é a probabilidade de o efeito observado nos dados da sua amostra se a hipótese nula é verdadeira?

Valor-p alto:  não há evidências nos dados para rejeitar a hipótese nula.
Valor-p baixo: há evidências nos dados para rejeitar a hipótese nula.

Um valor-p baixo sugere que sua amostra fornece evidências suficientes de que você pode rejeitar a 
hipótese nula para toda a população.

O valor-p representa a probabilidade de a diferença detectada entre os grupos analisados ter 
ocorrido ao acaso. Outra forma de interpretar o valor-p:

Se p <= 0,05, então há pequena probabilidade da diferença entre os grupos ser ao acaso. 
Considera-se que há diferença significativa entre os grupos.

Se p > 0,05, então há grande probabilidade da diferença observada entre os grupos ser ao acaso. 
Considera-se que não diferença significativa entre os grupos.

Opção A: rejeitamos a hipótese nula.
Opção B: não rejeitamos a hipótese nula.
Opção C: rejeitamos a hipótese nula.

*/


/* Estudo de Caso 2 */


data expo;
 format p_value pvalue.;

 * Número de Observações;
 n=100;          
 
 * Intervalo de Tempo;
 T=1;           
 
 * Número de Falhas;
 M=25;          
 
 * Taxa de falha sob a hipótese nula;
 lambda0=0.2;   
 
 * Probabilidade de falha;
 p=1-exp(-lambda0*T); 

* Teste estatístico;
z=(25-n*p)/sqrt(n*p*(1-p));

* Cálculo do valor-p;
p_value = 2*probnorm(-abs(z));

* Resultados;
proc print;
 var z p_value;
run;

* Resposta: Valor-p alto: não há evidências nos dados para rejeitar a hipótese nula.
* Não rejeitamos a hipótese nula.





