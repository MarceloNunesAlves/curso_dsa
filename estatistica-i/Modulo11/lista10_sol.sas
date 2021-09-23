/* Solução lista 10 de Exercícios em SAS  */

/* Vamos comparar as alturas médias de 19 alunos com base no sexo. 
Os dados estão contidos no conjunto de dados Sashelp.Class. */

/* Utilize “sex” como variável de agrupamento, chame PROC MEANS para gravar as 
estatísticas de resumo em um conjunto de dados e imprima um subconjunto das 
estatísticas. Em seguida, use a PROC TTEST para realizar o seguinte teste de hipóteses:

Hipótese Nula (H0) – As alturas médias são as mesmas para os dois grupos (sexo masculino e sexo feminino)
Hipótese Alternativa(H1) – As alturas médias não são as mesmas para os dois grupos (sexo masculino e sexo feminino)

Quais são as suas conclusões? Devemos ou não rejeitar a H0?


/* Criando um dataset class a partir de sashelp.class ordenando pela variável sex */
proc sort data = sashelp.class out = class; 
   by sex;                                
run;


/* Calculando as estatísticas de resumo e gravando no dataset EstatisticasResumo */
proc means data = class;           
   by sex;                              
   var height;                           
   output out = EstatisticasResumo;              
run;


/* Imprimindo algumas estatísticas de resumo para os 2 grupos */
proc print data = EstatisticasResumo; 
   where _STAT_ in ("N", "MEAN", "STD");
   var Sex _STAT_ Height;
run;


/* Realizando o Teste de Hipótese com o Teste t*/
/* Teste two-sided das diferenças das médias entre os grupos */
proc ttest data = EstatisticasResumo order = data alpha = 0.05 test = diff sides = 2; 
   class sex;
   var height;
run;


/* A linha "Pooled" fornece o teste t sob a suposição de que as variâncias dos dois grupos 
são aproximadamente iguais, o que parece ser verdadeiro para esses dados. 

O valor da estatística t é t = -1,45 com um valor-p bilateral de 0,1645. 

Com esta pequena amostra, falhamos em rejeitar a hipótese nula no nível de significância 
de 0,05. (Para variâncias desiguais, use a linha "Satterthwaite".) */


/* O PROC TTEST no SAS executa o teste t para:

• uma amostra
• duas amostras
• observações emparelhadas; 

*/

/* Teste t de duas amostras

• O procedimento SAS PROC TTEST é usado para testar a igualdade de médias para
um teste t de duas amostras (grupos independentes).

Principais premissas do teste t de duas amostras: as amostras são independentes 
e as populações são normalmente distribuídas com variâncias iguais.

Interpretação do Teste t em SAS:

• DF - Os graus de liberdade para o teste t são simplesmente o número de observações válidas 
menos 1. Perdemos um grau de liberdade porque estimamos a média da amostra. Usamos algumas 
das informações dos dados para estimar a média; portanto, não está disponível para uso no 
teste e os graus de liberdade são responsáveis por isso.

• Valor t - Esta é a estatística t de student. É a razão da diferença entre a média da 
amostra e o número fornecido e o erro padrão da média. Como o erro padrão da média mede 
a variabilidade da média da amostra, quanto menor o erro padrão da média, maior a 
probabilidade de que a média da nossa amostra esteja próxima da média real da população. 

• Pooled - O estimador de variância agrupado (pooled estimator) é uma média ponderada da 
variância das duas amostras, com maior peso atribuído à amostra maior;

• Satterthwaite é uma alternativa ao teste t de variância combinada e é usado quando
a suposição de que as duas populações têm variâncias iguais parece irracional.

*/



