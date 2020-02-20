options(stringsAsFactors=FALSE);
library(tidyverse)

setwd("/nas/longleaf/home/seyn/NBIO/")
alc =read_tsv("20414.gwas.imputed_v3.both_sexes.tsv.gz") #reading in gwas
alc2 = select(alc,variant,pval) #selecting out columns of interest 
alc3 = arrange(alc2,pval) #arranging by the smallest pval. Smallest pval is 1.93e-40 on chromosome 4
sep = str_split(alc2$variant,":",simplify =TRUE) 
alc4 = mutate(alc2,chr=sep[,1],variant=sep[,2]) #adding chromosomes and position as columns in our tibble

alc5 = filter(alc4,chr==4) #selecting for just chromosome 4
alc5 = filter(alc5,pval<1e-04) #selecting for p<1*10^-4
f_alc = mutate(alc5,logP =-log10(pval)) #adding an extra column to calculate -log10 of pval

#plotting 
 ggplot(f_alc, aes(x=variant, y=logP)) +
    geom_point() +
    labs (title = "Alcohol Manhattan", x="Position",y= "-log10P") ->AlcoholManhattan
 
 ggsave("AlcoholManhattan.pdf")

