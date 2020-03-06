library(tidyverse)
library(modelr)
library(data.table)
library(data.table)
library(ggplot2)
library(ggforce)

setwd("/nas/longleaf/home/seyn/NBIO/")
ped = read.table("hapmap1_nomissing_AF2.ped")
map = read.table("hapmap1_nomissing_AF.map")
qt = read.table("qt.phe")

ped = ped[,c(7:ncol(ped))] #selecting out the first 6 cols
map = map[,c(2,4)]
colnames(map)[1] = "SNP"
colnames(qt) [3] = "Phenotype"

mat = 1:ncol(ped)
ped = ped[ , mat[mat%%2!=0] ] + ped[ , mat[mat%%2==0] ] #adding the genotype values so that genotypes of 1 1 = 2, 2 1=3, 2 2= 4. This will allow us to easily assign it to homozygous, heterozygous etc

#I will set the colnames of ped to correspond with the SNP names in the map file
colnames(ped) = map$SNP

qt2 =  qt[,c(-2)] #to select for phenotype and sample ID since we do not need the middle column in original qt file
combined =  cbind(qt2$Phenotype,ped) #to combine the datasets into one large fil
colnames(combined) [1] <-"Phenotype"

#Here, I will generate two different csv files for slave.R. Mostly because I am not sure which version will work. The structure of combined2 is similar to Q1
write.csv(combined,file = "/nas/longleaf/home/seyn/NBIO/combined.csv",row.names = F,col.names =T, quote=F) 

combined2 <- gather(combined,
                    key = "SNP",
                    value = "Genotype",
                    -Phenotype)

write.csv(combined2,file = "/nas/longleaf/home/seyn/NBIO/Homework6/combined2.csv",row.names = F,col.names =T, quote=F)

#setting up job submission
test = unique(combined2$SNP) #there are 77301 unique snps in my dataset after the QC we did previously

nsnps <- 77301
njobspernode <- 1000

##Total number of jobs to submit
njobs <- ceiling(nsnps/njobspernode)

##Loop over the number of jobs
for (i in 1:njobs) {
    system(paste0("sbatch -p general -N 1 --mem=4g -n 1 -t 00:20:00 -o permsout/output",i,".txt --wrap=\"Rscript slave2.R ",i,"\""));
}

