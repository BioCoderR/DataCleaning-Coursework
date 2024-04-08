# HEADER --------------------------------------------
#
# Author: Pranav Swaroop Gundla
#                               
# Copyright (c) PSG, 2024
# 
# Date: 2024-04-08
#
# Script Name: run_analysis.R
#
# Script Description:  This is for the Data-Cleaning Course in Coursera. This is a Peer-graded review work for performing the
#                      data analysis with the tidy data.
#
#
# Notes: 
## input files: x_train.txt,x_test.txt,y_train.txt,y_test.txt,subject_train.txt,subject_test.txt
##              features.txt, activity_labels.txt
## output files: tidy_average_data.txt, combinedcleaningdata.txt
##
##
##################################################################
##              Environment and Libraries Setup                 ##
##################################################################
# SET WORKING DIRECTORY -----------------------------
cat("SETTING WORKING DIRECTORY...\n\n", sep = "")
wd <- "DataCleaningCoursera/"
setwd(wd)
cat("WORKING DIRECTORY HAS BEEN SET TO: ", wd, sep = "")


# SET OPTIONS ---------------------------------------
cat("SETTING OPTIONS... \n\n", sep = "")
options(scipen = 999) # turns off scientific notation
options(encoding = "UTF-8") # sets string encoding to UTF-8 instead of ANSI

cat("INSTALLING PACKAGES & LOADING LIBRARIES... \n\n", sep = "")
packages <- c("reshape2") # list of packages to load
n_packages <- length(packages) # count how many packages are required

new.pkg <- packages[!(packages %in% installed.packages())] # determine which packages aren't installed

# install missing packages
if(length(new.pkg)){
  install.packages(new.pkg)
}

# load all requried libraries
for(n in 1:n_packages){
  cat("Loading Library #", n, " of ", n_packages, "... Currently Loading: ", packages[n], "\n", sep = "")
  lib_load <- paste("library(\"",packages[n],"\")", sep = "") # create string of text for loading each library
  eval(parse(text = lib_load)) # evaluate the string to load the library
}
#################################################################
##                1. Merging train & test sets                 ##
#################################################################
cat("/n")
cat("step 1: Merges the training and the test set to create on data set.\n")
### reading and merging the dataset pairs
traindata <- read.table("./train/X_train.txt")
testdata <- read.table("./test/X_test.txt")
join.data <- rbind(traindata, testdata) ## rbind to  merge the data
## sanity check for dimensions (observation/rows, variables/columns)
dim(traindata) ## [1] 7352  561
dim(testdata)  ## [1] 2947  561
dim(join.data) ## [1] 10299   561
## read and merge the label data for train and test
train.label <-  read.table("./train/y_train.txt")
test.label <- read.table("./test/y_test.txt")
join.label <- rbind(train.label,test.label)
## sanity check for the dimensions (observation/rows, variables/columns)
dim(train.label) ## [1] 7352    1
dim(test.label)  ## [1] 2947    1
dim(join.label) ## [1] 10299     1
## subject data read and merge
train.subject <- read.table("./train/subject_train.txt")
test.subject <- read.table("./test/subject_test.txt")
join.subject <- rbind(train.subject,test.subject)
## sanity check for the dimensions (observation/rows, variables/columns)
dim(train.subject) ## [1] 7352    1
dim(test.subject)  ## [1] 2947    1
dim(join.subject) ## [1] 10299     1

##################################################################################################
##   2. Extracts only the measurements on the mean and standard deviation for each measurement  ##
##################################################################################################
cat("\n")
cat("Step2: Extracts only the measurements on the mean and standard deviation for each measurement.\n")

