library(tidyverse)

setdir = ("/nas/longleaf/home/seyn/NBIO/Homework6/permsout")
data = read_csv("/nas/longleaf/home/seyn/NBIO/Homework6/fdata.csv")

#creating and empty matrix to store output
nullperms = matrix(NA,nrow=1e6,ncol=1);

#generating a loop to gather all the files
for (i in 1:100) {
    tmpperms = read_csv(paste0(setdir,"/permslopes",i,".txt"),col_names=FALSE);
    lind = i*1e4;
    find = i*1e4-1e4+1;
    nullperms[lind:find,1] = tmpperms$X1[1:1e4];    
}

#making the indexed matrix into a tibble
perms = tibble(nullperms=nullperms)
#observed statistics
mod = lm(data$Phenotype~data$Genotype)
obs = coef(mod)[2]
 
#getting the pvalues
pval = length(which(perms$nullperms < -obs)) + length(which(perms$nullperms > obs))/1e6 #to get the two sided pval. Pval = 801929.8

#generating the historgram
ggplot(data=perms) +
    geom_histogram(mapping=aes(x=nullperms)) +
    geom_vline(mapping=aes(xintercept=obs)) +
    geom_vline(mapping=aes(xintercept=-obs)) +
    ggtitle("801929.8")

ggsave('histogram.png')

