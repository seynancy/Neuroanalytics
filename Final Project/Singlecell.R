#loading required libraries
library(Seurat)
library (Matrix)
library(stringr)

options(stringsAsFactors = F)
setwd("/Users/nancysey/desktop/")

#reading in publicly available single cell expression dataset and metadata from Bhattacherjee et al.2019. Note that ExpressionData may take a while to load 
ExpressionData = read.csv ("/Users/nancysey/desktop/GSE124952_expression_matrix.csv", header = TRUE)
MetaData = read.csv ("/Users/nancysey/desktop/GSE124952_meta_data.csv", header = TRUE)
MetaData.complete = na.omit(MetaData) # lets first take out NA rows from MetaData
ExpressionData.complete = ExpressionData[,c(1:24823)] #select columns in ExpressionData that matches to the rows of MetaData

# this is to select out specific treatment. We will like to use withdrawal_15_d saline/cocaine because Bhattacherjee et al.2019 reported seeing the greatest effect of
#treatment after 15 days of withdrawal.
index = which(MetaData.complete$stage %in% c("withdraw_15d_Saline","withdraw_15d_Cocaine"))
MetaData.complete =  MetaData.complete[index,] 
rownames(ExpressionData.complete) = ExpressionData.complete$X
ExpressionData.complete = ExpressionData.complete[,-1]
ExpressionData.complete = ExpressionData.complete [,MetaData.complete$X] #matching colnames of ExpressionData to rownames of MetaData

#since the ExpressionData.complete has a lot of 0 values, we will transform it into a sparse matrix and saving both ExpressionData and MetaData into an rda file
ExpressionSparse.mtx = as.sparse(ExpressionData.complete)
save (ExpressionSparse.mtx, MetaData.complete, file = "/Users/nancysey/desktop/SingleCell_Addiction.rda")

#now that we have cleaned up the ExpressionData and MetaData, we will use Seurat package in R to normalize the dataset by loading in the rda file that was created
mydata = load ("SingleCell_Addiction.rda")
mydata = CreateSeuratObject(counts=ExpressionSparse.mtx, project="addiction", min.cells=3, min.features=200) #transforming the Expressiondata into a Seurat object 
mydata_norm <- NormalizeData(mydata)
mydata_normscale <- ScaleData(mydata_norm, do.scale=T, do.center=T)
saveRDS(mydata_normscale, file ="/Users/nancysey/desktop/SingleCell_Normalized.rds")
