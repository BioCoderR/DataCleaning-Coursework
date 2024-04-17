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
## The script below uses dplyr, tidyr, gsubfn, and data.table for this Project.
## The actions performed are mentioned below
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average
## of each variable for each activity and each subject.
##################################################################
##              Environment and Libraries Setup                 ##
##################################################################
# SET WORKING DIRECTORY -----------------------------
cat("SETTING WORKING DIRECTORY...\n\n", sep = "")
wd <- "DataCleaningCoursera/"
setwd(wd)
cat("WORKING DIRECTORY HAS BEEN SET TO: ", wd, sep = "")


required_packages <- c("data.table", "dplyr", "tidyr")
new_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)
lapply(required_packages, library, character.only = TRUE)

## getting the data
# from zip file
# wd in variable
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "data.zip"))
unzip(zipfile = "data.zip")

#Activity labels and features
activitylabels <- read.table("./UCI HAR Dataset/activity_labels.txt",col.names = c('index','activityNames'))
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("index", "featureNames"))
file_paths <- list.files("./UCI HAR Dataset",full.names = T,recursive = T)
file_paths
# [1] "./UCI HAR Dataset/activity_labels.txt"                         
# [2] "./UCI HAR Dataset/features_info.txt"                           
# [3] "./UCI HAR Dataset/features.txt"                                
# [4] "./UCI HAR Dataset/README.txt"                                  
# [5] "./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"   
# [6] "./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"   
# [7] "./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"   
# [8] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"  
# [9] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"  
# [10] "./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"  
# [11] "./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"  
# [12] "./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"  
# [13] "./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"  
# [14] "./UCI HAR Dataset/test/subject_test.txt"                       
# [15] "./UCI HAR Dataset/test/X_test.txt"                             
# [16] "./UCI HAR Dataset/test/y_test.txt"                             
# [17] "./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt" 
# [18] "./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt" 
# [19] "./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt" 
# [20] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
# [21] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
# [22] "./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
# [23] "./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
# [24] "./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
# [25] "./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
# [26] "./UCI HAR Dataset/train/subject_train.txt"                     
# [27] "./UCI HAR Dataset/train/X_train.txt"                           
# [28] "./UCI HAR Dataset/train/y_train.txt" 
xTrain <- read.table(file_paths[27])
yTrain <- read.table(file_paths[28])
xTest <- read.table(file_paths[15])
yTest <- read.table(file_paths[16])
subTrain <- read.table(file_paths[26])
subTest <- read.table(file_paths[14])
activityLabels<- read.table(file_paths[1])
features<- read.table(file_paths[3])
## column names change
colnames(xTrain) <- features[,2]
colnames(xTest) <- features[,2]
colnames(subTrain) <- "subjectID"
colnames(subTest) <- "subjectID"
colnames(yTrain) <- "activityID"
colnames(yTest) <- "activityID"
colnames(activityLabels) <- c("activityID", "activityType")
## 1. Merging all the data table into one main set
TrainData <- cbind(xTrain,yTrain,subTrain)
TestData <- cbind(xTest,yTest,subTest)
FinalSet <- rbind(TrainData,TestData)
## 2. Extracting only the measurements on MEAN and SD.'s for each measurement
M_sd <- grepl("activityID|subjectID|mean\\(\\)|std\\(\\)",colnames(FinalSet))
setMeanStd <- FinalSet[, M_sd]

## 3. Using the descriptive activity names
setActivityNames <- merge(setMeanStd, activityLabels, by = "activityID", all.x = T)

## 4. Labeling the data with descriptive variable names
colnames(setActivityNames) %<>%
  gsub("^t", "time", .) %>%
  gsub("^f", "frequency", .) %>%
  gsub("Acc", "Accelerometer", .) %>%
  gsub("Gyro", "Gyroscope", .) %>%
  gsub("Mag", "Magnitude", .) %>%
  gsub("BodyBody", "Body", .)
## 5. Creating the independent Tidy-Dataset with average of each variable for each activity and subject

TidyDataSet <- setActivityNames %>% 
  group_by(subjectID,activityID,activityType) %>% 
  summarise_all(mean)
## Writing the TidyData file
write.table(TidyDataSet,"TidyDataSet.txt",row.names = F)

