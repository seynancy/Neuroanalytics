options(stringsAsFactors=FALSE);
#################################################3
#########using Jason's code from Homework3##########

##Plot genotype x phenotype associations

##Get all my filenames of interest
fped <- 'hapmap1.ped';
fphe <- 'qt.phe';
fmap <- 'hapmap1.map';

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
map <- read.table(fmap);
##Make sure the number of SNPs in the map file equals the number of SNPs in the ped file
if(nrow(map)!=nSNPs) {
    cat('Something is wrong! The number of SNPs in the map file is not equal to the number of SNPs in the ped file','\n');
}
##I already know these SNPs are in the same order
##So I will assign the SNP names to the columns
colnames(SNPs) <- map$V2;
##Also now assign each row to the subject
rownames(SNPs) <- ped[,1]

#######this is the part where I will add Homwork4 to Jason's code from Homework 3########
#########################################################################################

length(which(is.na(SNPs))) #checking how many NA values there are 
missing = colSums(is.na(SNPs))/nrow(SNPs)*100 #to get the percentages of the missing NA
missing_top = which(missing > 5) #this will provide rsids with missing rate higher than 5%
write.csv(missing_top,file="/nas/longleaf/home/seyn/missing_rsid.csv", row.names = T,col.names =T, quote=F) 

#writing out modified .map file that eliminates SNPs that don't survive missingness threhold
rsid_remove = read.csv("/nas/longleaf/home/seyn/missing_rsid.csv", header = TRUE)
map2 = map[!(map$V2 %in% rsid_remove$X),] #removing the SNPs in map file that also appear in the rsid_remove file and storing it as map2
write.table(map2,file="/nas/longleaf/home/seyn/hapmap1_nomissing.map", sep = " ", quote=F,col.names =F,row.names=F) #saving new map file

#writing out modified .ped file that eliminates SNPs that don't survive missingness threhold
tmpSNPs #we will reload the tmpSNPs rather than SNPs with added columns to remove SNPs that don't survive missingness threshold. 
tmpSNPs[tmpSNPs==0] = NA #recoding 0 values as NAs to remove in the next step 
SNPs2 = tmpSNPs[, -which(colMeans(is.na(tmpSNPs)) > 0.05)] #removing the SNPs in ped file that do not survive the missingness threshoold.
SNPs2[is.na(SNPs2)] =  0 #recoding NA values that survived the missingness threshold back to 0

#final structure of .ped file 
ped = ped[,c(1:6)] #getting the first 6 columns from the original ped file that we removed in the begining 
SNPs3 = cbind(ped,SNPs2) #adding the first 6 columns of the original .ped file back to the modified .ped file
length(colnames(SNPs3)) #to make sure that the first 6 columns have indeed been added to the modified .ped file 
write.table(SNPs3,"hapmap1_nomissing.ped",row.names=FALSE, col.names=FALSE)
