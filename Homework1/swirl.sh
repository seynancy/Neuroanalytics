

#!/bin/bash                                                                                                      
for i in `seq 1 10`
do
    echo -ne '/'; #print outa single forward slash                                                               
    sleep 1; #wait one second before printing the next line                                                      
    echo -ne '\b_'; #print out a dash after skipping previous line                                               
    sleep 1; #wait one second before printing the next line                                                      
    echo -ne '\b/'; #print out backslash after skipping previous line                                           
    sleep 1; #wait one second before printing the next line                                                      
    echo -ne '\b|'; #print out vertical bar after skipping previous line                                         
    sleep 1; #wait one second before printing the next line                                                      
    echo -ne '\b\'; #print out forward slash after skipping previous line                                        
    sleep 1; #wait one second before printing the next line                                                      
    echo -ne '\b~'; #print out a dash after skipping previous line                                               
    sleep 1; #wait one second before printing the next line                                                      
    echo -ne '\b~'; #print out backslash after skipping previous line                                           
    sleep 1; #wait one second before printing the next line                                                      
    echo -ne '\b|'; #print out a vertical bar after skipping previous line                                       
    echo -ne "\b \n"; #print new line                                                                            
done
