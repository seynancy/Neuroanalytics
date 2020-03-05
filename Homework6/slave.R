library(tidyverse)
#input file
data <- read_csv("/nas/longleaf/home/seyn/NBIO/Homework6/fdata.csv")
args <- commandArgs(trailingOnly=TRUE)

#setting out output
dataout <- paste0("/nas/longleaf/home/seyn/NBIO/Homework6/permsout/permslopes",args[1],".txt");

#creating an empty matrix to store data
output <- matrix(NA,nrow=10000,ncol=1);

#performing permutation
for (i in 1:10000) {
    scrambledx <- sample(data$Genotype);
    permmod <- lm(data$Phenotype~scrambledx);
    output[i,1] <- coef(permmod)[2];
}

#writing out the permutations
write.table(output,file=dataout,row.names=FALSE,col.names=FALSE)

