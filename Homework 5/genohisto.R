options(stringsAsFactors=FALSE);
library(tidyverse)

ped <- read.table("hapmap1_nomissing_AF2.ped.gz");
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
map <- read.table("hapmap1_nomissing_AF.map"); #reading in the map file
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
freq[freq==1]<-NA #adding this part because i may not have selected out SNPs with frequencies >95% in the previous Hw resulting in overrepresentation of 1s. 
freq <- as.data.frame(freq)
freq2 <- freq %>% rownames_to_column('SNP')
freq2 = freq2[complete.cases(freq2), ] #selecting out freq of 1 that have now been coded as NA

which(freq2$freq >0.5) #checking which frequencies are above 0.5. 
freq2$minor_allele_freq = (1 - freq2$freq) #transforming frequencies above 0.5 to minor allele frequencies and adding the result as a colunm in my data frame
which(freq2$minor_allele_freq >0.5) #double checking to make sure frequencies are less than 0.5

#plotting MAFs as a histogram
ggplot(data=freq2, aes(x =minor_allele_freq)) + 
    geom_histogram(binwidth = 0.02,col = "black",fill = "#00AFBB", alpha =.2)+
    labs(x="SNP", y="Frequency") + ggtitle("Minor allele frequencies") + theme_classic() -> genohisto
print(genohisto)
ggsave("genohisto.pdf")

