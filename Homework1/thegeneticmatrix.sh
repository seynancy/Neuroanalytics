#!/bin/bash                                                                                                   
testfile="hapmap1.ped"; #uploading hapmap1 data                                                               
less -S $testfile; #viewing data in testfile                                                                  
wc testfile; #number of lines in textfile                                                                     
head -n	5 $testfile; #viewing first 5 elements of textfile                                                    
tail -n	5 $testfile; #viewing last 5 elements of the file                                                     
tail -n	5 $testfile|head -1; #viewing first element of last 5 files
sleep 1; #waiting one second
tail -n	5 $testfile|head -2; #viewing second element of last 5 files
sleep 1; #waiting one second
tail -n	5 $testfile|head -3; #viewing third element of last 5 files
sleep 1; #waiting one second
tail -n	5 $testfile|head -4; #viewing fourth element of last 5 files
sleep 1; #waiting one second
tail -n	5 $testfile|head -5; #viewing fifth element of last 5 files

