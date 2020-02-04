options(stringsAsFactors=F)
library(data.table)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(ggforce)

setwd("/nas/longleaf/home/seyn/") #setting the directory 
#reading in the 3 files
ped = read.table("hapmap1.ped") 
map = read.table("hapmap1.map")
qt = read.table("qt.phe")

ped = ped[,c(7:167074)] #since the first 6 columns describe the individuals, we need to select columns past column 6. 
map = map[1:100,] #reading out the first 100 SNPs in the map file
map = as.data.frame(map)
colnames(map)[2] = c("SNP")
colnames(qt) [3] = c("Phenotype")

as.matrix(ped)
mat = 1:ncol(ped)
ped = ped[ , mat[mat%%2!=0] ] + ped[ , mat[mat%%2==0] ] #adding the genotype values so that genotypes of 1 1 = 2, 2 1=3, 2 2= 4. This will allow us to easily assign it to homozygous, heterozygous etc

#recoding numeric genotypes as missing, homozygous,and heterozygous
ped2 = ped
ped2[f_ped==0] = c("missing")
ped2[f_ped==2] = c("homozyg1")
ped2[f_ped==3] = c("heterozygous")
ped2[f_ped==4] = c("homozyg2")
f_ped = ped[,c(1:100)] #selecting for just the first 100 genotypes

#next I will rotate the map file and fit it to f_ped using data.table library
map2 = transpose(map)
map2 = map2[c(-2),] #to select for jus SNP names

qt2 =  qt[,c(-2)] #to select for phenotype and sample ID since we do not need the middle column in original qt file
combined =  cbind(qt2, f_ped) #to combine the datasets into one large file 
combined <- combined[,c(-1)] #to get rid of participant id, we can select out the first column 

#we now need to restructure the dataframe for plotting. This will combine all the data i.e phenotype data from .qt, genotype from .ped and their associated SNPs
combined2 <- gather(combined,
             key = "SNP",
             value = "genotype",
             -Phenotype)

#we will plot the graphs with ggplot using the library ggforce. This will plot the phenotype vs genotype of each SNP. @Dan, idk if this plot is even right. I really tried my best!
ggplot(data = combined2, aes(x = genotype, y = phenotype)) +   
    geom_point() +
    xlab("Genotype") + ylab("Phenotype") +   
    facet_wrap_paginate(~SNPid,
                        nrow = 1, 
                        ncol = 1, 
                        scales = "free") +
    theme( strip.text = element_text(size = 30)) -> q
required_n_pages <- n_pages(q) 

#for loop to allow us to loop over each SNP to create their separate file
pdf("genotype.pdf")
for(i in 1:required_n_pages){
    ggplot(data = combined2, aes(x = genotype, y = phenotype)) +   
        geom_point() +
        xlab("Genotype") + ylab("Phenotype") +  
        facet_wrap_paginate(~SNPid,
                            nrow = 1, 
                            ncol = 1, 
                            scales = "free",
                            page = i) +
        theme( strip.text = element_text(size = 30)) -> r
    
    print(r)
}
dev.off()

