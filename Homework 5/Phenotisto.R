options(stringsAsFactors = F)
library(ggplot2)


setwd("/nas/longleaf/home/seyn/NBIO")
qt = read.table("qt.phe") #loading phenotype data

#computing histogram with gg
ggplot(data=qt, aes(qt$V3)) + 
    geom_histogram(breaks=seq(0, 13, by=2),col = "black",fill = "#00AFBB",binwidth = 3, alpha =.2)+
    labs(x="Phenotype", y="Frequency") + ggtitle("Phenotypic data") + theme_classic()
    
