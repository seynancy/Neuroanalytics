options(stringsAsFactors=F)
setwd("/nas/longleaf/home/seyn/") #setting the directory 
#reading in the 3 files
ped = read.table("hapmap1.ped") 
map = read.table("hapmap1.map")
qt = read.table("qt.phe")

ped2 = ped[,c(7:207)] #since the first 6 columns describe the individuals, we need to select columns past column 6. This will select the next 200 columns 
map = map[1:100,] #reading out the first 100 SNPs in the map file
map = as.data.frame(map)
colnames(map)[2] = c("SNP")
colnames(qt) [3] = c("Phenotype")

as.matrix(ped2)
mat = 1:ncol(ped2)
ped3 = ped2[ , mat[mat%%2!=0] ] + ped2[ , mat[mat%%2==0] ] #adding the genotype values so that genotypes of 1 1 = 2, 2 1=3, 2 2= 4. This will allow us to easily assign it to homozygous, heterozygous etc

#recoding numeric genotypes as missing, homozygous,and heterozygous
f_ped = ped3
f_ped[f_ped==0] = c("missing")
f_ped[f_ped==2] = c("homozygous1")
f_ped[f_ped==3] = c("heterozygous")
f_ped[f_ped==4] = c("homozygous2")

#combining qt and ped files into one data frame
master = cbind(qt$Phenotype,ped4) #this merges the phenotype data with the genotype data

