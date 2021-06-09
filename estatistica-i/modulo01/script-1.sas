LIBNAME caminho "/home/u58817695";

proc import file="/home/u58817695/hour.csv"
    out=work.hour
    dbms=csv;
run;
 
proc print data=work.hour (obs=6) noobs;
run;

#proc print data=work.hour;
#  do until (last.temperatura) ;              
#    set a ;                              
#    by temperatura;                         
#    numtemp = sum (numtemp, N(temp)) ;
#    sumtemp = sum (sumtemp, temp) ;   
#  end ;                                  
#  mean = divide (sumtemp, numtemp) ;   
#run;
