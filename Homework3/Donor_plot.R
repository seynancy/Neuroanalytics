
#plotting the time point of each donor. I created my donor graphs based on Homework 1 where we hadn't added the zero padding to the files yet
options(stringsAsFactors=F)
library(ggplot2)
library(tidyverse)
library(ggforce)
library(stringr)

setwd("/nas/longleaf/home/seyn/fakedata/")
directory = list.files(pattern = ".*.txt") #finding all files in the directory with this pattern 
directory = unlist(strsplit(directory, split="[.]txt")) #removing the .txt suffix from the files
conditions = as.data.frame(directory) #creating a dataframe with the split files

conditions = str_split_fixed(conditions$directory, "_", 2) #splitting the files into two columns. Files will be split after "_"
colnames(conditions) =c("donor","tp") #adding column names to the dataframe

files = list.files(pattern=".*.txt")  #adding the .txt. suffix back to the files
files_df = lapply(files, function(x) {read.table(file = x, header = T, sep =",")}) #reading out the data contained in each file for donors
combined_df = do.call("rbind", lapply(files_df, as.data.frame)) #rowbinding all the data into one large dataframe with data being the column name
combined_df = cbind(combined_df, conditions) #column binding the dataframe to include the donor number and their tps

# a modification of ggplot that will allow me to make place each donor's file on a separate page. This part of the code is courtesy of Sarah G.
ggplot(data = combined_df, aes(x = tp, y = data)) +   
    geom_point() +
    xlab("Time") + ylab("Phenotype") +   
    facet_wrap_paginate(~donor,
                        nrow = 1, 
                        ncol = 1, 
                        scales = "free") +
    theme( strip.text = element_text(size = 30)) -> q
required_n_pages <- n_pages(q) 

#for loop to allow us to loop over each donor to create their separate file. Because my graph was created baseded 
#on Homework1 files, I have donor1 graph followed by donor10. This is the same for the tps on the x-axis.

pdf("longitudinaldata.pdf")
for(i in 1:required_n_pages){
    ggplot(data = combined_df, aes(x = tp, y = data)) +   
        geom_point() +
        xlab("Time") + ylab("Phenotype") +  
        facet_wrap_paginate(~donor,
                            nrow = 1, 
                            ncol = 1, 
                            scales = "free",
                            page = i) +
        theme( strip.text = element_text(size = 30)) -> r
    
    print(r)
}
dev.off()

