library(tidyverse)
library(data.table)
library(tidyverse)
library(tidyr)
library(ggplot2)
library(ggforce)

options(stringsAsFactors=F)

#to get the SNP of interest, I will recycle my previous code to get the SNP of interest and write it out as a csv file
ped = read.table("hapmap1.ped") 
map = read.table("hapmap1.map")
qt = read.table("qt.phe")

ped = ped[,c(7:167074)] #since the first 6 columns describe the individuals, we need to select columns past column 6. 
map = map[,c(2,4)] #to get SNP info 
map = as.data.frame(map) #transforming map to a data frame
colnames(map)[1] = c("SNP")
colnames(qt) [3] = c("Phenotype")

as.matrix(ped)
mat = 1:ncol(ped)
ped = ped[ , mat[mat%%2!=0] ] + ped[ , mat[mat%%2==0] ] #adding the genotype values so that genotypes of 1 1 = 2, 2 1=3, 2 2= 4. This will allow us to easily assign it to homozygous, heterozygous etc
ped[ped==0] = NA
f_ped = ped #changing the name of ped2 to final ped(f_ped)

#I will set the colnames of f_ped to correspond with the SNP names in the map file
colnames(f_ped) = map$SNP

qt2 =  qt[,c(-2)] #to select for phenotype and sample ID since we do not need the middle column in original qt file
combined =  cbind(qt2, f_ped) #to combine the datasets into one large file 
combined <- combined[,c(-1)] #to get rid of participant id, we can select out the first column 

combined2 <- gather(combined,
                    key = "SNP",
                    value = "Genotype",
                    -Phenotype)

combined2 <- na.omit(combined2)

fdata = subset(combined2,SNP=="rs2645091")
write.csv(fdata,file="/nas/longleaf/home/seyn/NBIO/Homework6/fdata.csv", row.names = T,col.names =T, quote=F) 

#Now that we have the phenotype corresponding to our SNP of interest, we can submit the job.I tried using -p steinlab but it doesn't work
for (i in 1:100) {
    system(paste0("sbatch -p general -N 1 --mem=4g -n 1 -t 00:20:00 -o permsout/output",i,".txt --wrap=\"Rscript slave.R ",i,"\""));
}

