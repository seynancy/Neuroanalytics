
#!/bin/bash   
 
mkdir createdata1 #making a directory for all the datasets                                                                                              
for i in `seq 1 50` #setting the stage to create 50 donor files
do 
  echo donor${i}.txt #creating donor files 
  touch createdata1/donor${i}.txt; #moving the files the directory created
  done

var=$(for i in {1..5}; do 
	echo $RANDOM;
 done) #this variable generates random numbers

mkdir createdata2 #making another directory for extended files
for i in `seq 1 50` #setting the stage to create additional files
do
   for j in `seq 1 50` #setting to create the extra 10 files for each donor
do 
  echo $var > donor${i}.txt_tp${j}.txt #creating the extra files per donor
  touch createdata2/donor${i}.txt_tp${j}.txt; #moving the files to createdata2 directory
done
done



