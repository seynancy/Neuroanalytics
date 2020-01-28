#!/bin/bash                                                                                                        

#I modified this code based on what the Jason shared in class for the first homework because it is easier to read than my previous
for donor in 0{01..100} #rather than using if then statement, i specified in the for loop to begin each sequence with a 0
do
    for tp in 0{01..10}
    do

        rand1=$RANDOM
        rand2=$RANDOM
        rand3=$RANDOM
        rand4=$RANDOM
        rand5=$RANDOM

        echo "data" > donor${donor}_tp${tp}.txt;
        echo ${rand1} >> donor${donor}_tp${tp}.txt;
        echo ${rand2} >> donor${donor}_tp${tp}.txt;
        echo ${rand3} >> donor${donor}_tp${tp}.txt;
        echo ${rand4} >> donor${donor}_tp${tp}.txt;
        echo ${rand5} >> donor${donor}_tp${tp}.txt;

    done
done


