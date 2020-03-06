library(tidyverse)

#input file
setwd("/nas/longleaf/home/seyn/NBIO/Homework6/")
fdata <- "combined.csv";
fdata2 <- "combined2.csv";
#Get the command line argument for the job number
args <- commandArgs(trailingOnly=TRUE)

#Output filename
fpermsout <- paste0("/nas/longleaf/home/seyn/NBIO/Homework6/permsout/permslopes",args[1],".txt");

#reading in both csv files i created in the driver.R script because I dont know which structure will work
data <- read_csv(fdata)
data2 <- read_csv(fdata2)

##Create an output vector
output <- matrix(NA,nrow=77302,ncol=1);

#setting up how lm will be calculated
#version1 with data 
n <- 77302
Phenotype <- data$Phenotype
SNP <-data[,c(-1)]

for (i in 1:njobs) {
    if (i < njobs) {
        ##Create the indices when there are no leftovers
        lind <- njobspernode*i;
        find <- njobspernode*i-njobspernode+1;
        cat('job:',i,'-',find,':',lind,'\n')
    } else {
        find <- nsnps %/% njobspernode * njobspernode + 1;
        lind <- ((i-1)*njobspernode) + (nsnps %% njobspernode);
        cat('job:',i,'-',find,':',lind,'\n')
    }
}
