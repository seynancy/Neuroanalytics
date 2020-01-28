#!/bin/bash   
# this script will divide the 500 files into a subdirectory

mkdir fakedata #making a subdirectory in my current working directory called homework1

for i in `find. -name"*.txt"; #this is the start of a for loop that will find common names for grouping. example of -name can be donor1 and *.txt will find all files of donor1 ending with txt in the current working directory
do
    mv $i ~/homework1/fakedata; #the for loop will move my files of interest into the fakedata directory
done



#to divide the 500 files in fakedata to create donor specific subdirectories

for j in `seq 1 50` #looping over to create 50 donor_specific subdirectories
do 
    echo "Creating subdirectories: donor_specific"${j};
    mkdir fakedata/donar_specific${j};  
done

#since we have all the 500 files in a directory called fakedata and additional 50 subdirectories under fakedata for each donor, we can now move each donor's files from fakedata into their specific subdirectories using additional for loops.

for j in `seq 1 50`;
do
    for i in `find ~/homework1/fakedata/ -name"*donor${j}*"`;
do
    mv $i ~/homework1/fakedata/donor_specific${j};
done
done
