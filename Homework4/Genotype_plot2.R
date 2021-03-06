options(stringsAsFactors=F)
library(data.table)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(ggforce)

setwd("/nas/longleaf/home/seyn/") #setting the directory 
#reading in the 3 files
ped = read.table("hapmap1_nomissing_AF2.ped") 
map = read.table("hapmap1_nomissing_AF.map")
qt = read.table("qt.phe")

ped = ped[,c(7:154608)] #since the first 6 columns describe the individuals, we need to select columns past column 6. 
map = map[,c(2,4)] #to get SNP info 
map = as.data.frame(map) #transforming map to a data frame
colnames(map)[1] = c("SNP")
colnames(qt) [3] = c("Phenotype")

as.matrix(ped)
mat = 1:ncol(ped)
ped = ped[ , mat[mat%%2!=0] ] + ped[ , mat[mat%%2==0] ] #adding the genotype values so that genotypes of 1 1 = 2, 2 1=3, 2 2= 4. This will allow us to easily assign it to homozygous, heterozygous etc

#recoding numeric genotypes as missing, homozygous,and heterozygous
ped2 = ped[,c(1:100)] #selecting for the first 100 genotypes
map2 = map[c(1:100),] #also selecting for the first 100 SNPs
ped2[ped2==0] = NA #marking missing genotypes as NA values. SNPs with these will be marked as NA on the plots
ped2[ped2==2] = c("Homozygous1")
ped2[ped2==3] = c("Heterozygous")
ped2[ped2==4] = c("Homozygous2")
f_ped = ped2 #changing the name of ped2 to final ped(f_ped)

#I will set the colnames of f_ped to correspond with the SNP names in the map file
colnames(f_ped) = map2$SNP

qt2 =  qt[,c(-2)] #to select for phenotype and sample ID since we do not need the middle column in original qt file
combined =  cbind(qt2, f_ped) #to combine the datasets into one large file 
combined <- combined[,c(-1)] #to get rid of participant id, we can select out the first column 

#we now need to restructure the dataframe for plotting. This will combine all the data i.e phenotype data from .qt, genotype from .ped and their associated SNPs. Also we will rename the column names 
combined2 <- gather(combined,
                    key = "SNP",
                    value = "Genotype",
                    -Phenotype)

combined2<- na.omit(combined2)
#we will plot the graphs with ggplot using the library ggforce. This will plot the phenotype vs genotype of each SNP. @Dan, idk if this plot is even right. I really tried my best!
ggplot(data = combined2, aes(x = factor(Genotype, level = c("Homozygous1","Heterozygous","Homozygous2")), y = Phenotype)) +   
    geom_point() +
    xlab("Genotype") + ylab("Phenotype") +   
    facet_wrap_paginate(~SNP,
                        nrow = 1, 
                        ncol = 1, 
                        scales = "free") +
    theme( strip.text = element_text(size = 30)) -> q
required_n_pages <- n_pages(q) 
q


#for loop to allow us to loop over each SNP to create their separate file
pdf("genotypeassociation_filtered2.pdf")
for(i in 1:required_n_pages){
    ggplot(data = combined2, aes(x = factor(Genotype, level = c("Homozygous1","Heterozygous","Homozygous2")), y = Phenotype)) +   
        geom_point() +
        xlab("Genotype") + ylab("Phenotype") +  
        facet_wrap_paginate(~SNP,
                            nrow = 1, 
                            ncol = 1, 
                            scales = "free",
                            page = i) +
        theme( strip.text = element_text(size = 30)) -> r
    
    print(r)
}
dev.off()
