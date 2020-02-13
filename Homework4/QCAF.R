options(stringsAsFactors=FALSE);
library(tidyverse)
#################################################3
#########again, using Jason's code from Homework3##########

##Plot genotype x phenotype associations

##Get all my filenames of interest. I will use the modified .map and .ped files from Q1
fped <- 'hapmap1_nomissing.ped';
fphe <- 'qt.phe';
fmap <- 'hapmap1_nomissing.map';

##Read in the ped file
ped <- read.table(fped);
##Transform this ped file into readable SNP data
##First remove the first six columns which are not SNP info
tmpSNPs <- ped[,c(7:ncol(ped))];
##To get the total number of SNPs, since each SNP is two columns we can do:
nSNPs <- ncol(tmpSNPs)/2;
##Get the total number of individuals in the study
ndonors <- nrow(ped);
##Display this as output to the user
cat('The total number of SNPs is: ',nSNPs,'\n');
cat('The total number of donors is: ',ndonors,'\n');

##Reformat the ped file to have
##0 0 = NA
##1 1 = homozygous for allele 1 = 0
##1 2 = heterozygous = 1
##2 2 = homozygous for allele 2 = 2
##Make an output matrix
SNPs <- matrix(NA,nrow=ndonors,ncol=nSNPs);
##Loop over each pair of columns in the tmpSNPs matrix
##I want this to get a series of numbers that are like this
##1,2  3,4  5,6 ...
##This is equivalent to (2*i-1,2*i)

for (i in 1:nSNPs) {
    
    ##Make an empty vector containing what the recoded SNP values will be
    snprecode <- matrix(NA,nrow=ndonors,ncol=1);
    
    ##Get the two columns representing one SNP
    onesnp <- tmpSNPs[,c(2*i-1,2*i)];
    
    ##Classify each SNP into 5 categories
    NAind <- which(onesnp[,1]==0 & onesnp[,2]==0);
    hom1ind <- which(onesnp[,1]==1 & onesnp[,2]==1);
    hetind <- which((onesnp[,1]==1 & onesnp[,2]==2) | (onesnp[,1]==2 & onesnp[,2]==1));
    hom2ind <- which(onesnp[,1]==2 & onesnp[,2]==2);
    
    ##Recode the SNPs according to their allelic status
    snprecode[NAind] <- NA;
    snprecode[hom1ind] <- 0;
    snprecode[hetind] <- 1;
    snprecode[hom2ind] <- 2;
    
    ##Save all of these SNPs in a matrix
    SNPs[,i] <- snprecode;
    
}

##Use the map file to label which SNP is being referred to in the SNPs file
map <- read.table(fmap); #reading in the map file
colnames(map)[2] <- "SNP"
map2 <- map[,c(2,4)] #to grab our columns of interest

map2 <- map2 %>% #using tidyverse to transform the map file so we can embed it to the ped file.
    pivot_wider(
        names_from = SNP,
        values_from = V4
    )

SNPs[SNPs==0]<-NA #recoding 0 values in ped to NAs. this will make it easier to account for NA values when calculating the allele frequency  
colnames(SNPs) <- colnames(map2); #adding column names to the genotype data.

#calculating allele frequencies based on 'hints' from the lecture
alleles <- colSums(SNPs, na.rm=TRUE)
totalN <- 2*colSums(!is.na(SNPs))
freq <- alleles/totalN
freq <- as.data.frame(freq)
freq2 <- freq %>% rownames_to_column('SNP')

#writing out low allele frequency SNPs
final_freq <- freq2 %>%
    top_frac(-0.05) #we can now filter out the SNPs with the lowest allele frequencies by setting top_frac to annotate SNPs with frequencies <5%
#based on the above we now have 4099 SNPs that do not survive allele frequency QC.
write.csv(final_freq,file="/nas/longleaf/home/seyn/missing_AF.csv", row.names = T,col.names =T, quote=F)

#cleaning up .map file. now that we have the SNPs that do not survive QC, we will take them out of the map file
missing_af = read.csv("/nas/longleaf/home/seyn/missing_AF.csv", header = TRUE)
map3 = map[!(map$V2 %in% missing_af$SNP),] #removing the SNPs in map file that also appear in the missing_af file
write.table(map3,file="/nas/longleaf/home/seyn/hapmap1_nomissing_AF.map", sep = " ", quote=F,col.names =F,row.names=F) #saving new map file

#cleaning up .ped file. now that we have the SNPs that do not survive QC, we will take them out of the ped file since we have the column names 
#of the map file as rsids,and given that the rsids correspond to the genotype pairs, we can duplicate each rsid to map to the tmpSNPs ped file
map_dup <- map2[ , rep(seq_len(ncol(map2)), each = 2)] 
colnames(tmpSNPs) <- colnames(map_dup)
tmpSNPs2 <- tmpSNPs[ , !names(tmpSNPs) %in% missing_af$SNP ] #taking out SNPs in ped that did not survive QC
tmpSNPs3 <- unname(tmpSNPs2)
ped = ped[,c(1:6)] #staging the first 6 columns that were taken out of ped
f_ped = cbind(ped,tmpSNPs3) #adding back the first 6 columns that were taken out of ped
write.table(f_ped,file="/nas/longleaf/home/seyn/hapmap1_nomissing_AF.ped", sep = " ", quote=F,col.names =F,row.names=F)
