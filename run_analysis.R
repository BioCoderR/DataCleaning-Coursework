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


# SET OPTIONS ---------------------------------------
cat("SETTING OPTIONS... \n\n", sep = "")
options(scipen = 999) # turns off scientific notation
options(encoding = "UTF-8") # sets string encoding to UTF-8 instead of ANSI

cat("INSTALLING PACKAGES & LOADING LIBRARIES... \n\n", sep = "")
packages <- c("dplyr","data.table","gsubfn","tidyr") # list of packages to load
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

## getting the data
# from zip file
# wd in variable
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "data.zip"))
unzip(zipfile = "data.zip")

# Load activity labels and features
activityLabels <- fread(
  file.path(path, "./UCI HAR Dataset/activity_labels.txt"),
  col.names = c("classLabels", "activityNames")
)

features <- fread(
  file.path(path, "./UCI HAR Dataset/features.txt"),
  col.names = c("index", "featureNames")
)

# Extracting mean and std from features
featuresNeeded <- grep("(mean|std)\\(\\)", features$featureNames)
measurements <- features[featuresNeeded, featureNames]
measurements <- gsubfn(
  "(^t|^f|Acc|Gyro|Mag|BodyBody|\\(\\))",
  list(
    t = "Time",
    f = "Frequency",
    Acc = "Accelerometer",
    Gyro = "Gyroscope",
    Mag = "Magnitude",
    BodyBody = "Body",
    "()" = ""
  ),
  measurements
)

# Load train data
trainData <- fread(file.path(path, "./UCI HAR Dataset/train/X_train.txt"))[, featuresNeeded, with = FALSE]
setnames(trainData, names(trainData), measurements)

activityTrain <- fread(file.path(path, "./UCI HAR Dataset/train/y_train.txt"), col.names = "Activity")
subjectTrain <- fread(file.path(path, "./UCI HAR Dataset/train/subject_train.txt"), col.names = "SubjectNo.")

train <- bind_cols(activityTrain, subjectTrain, trainData)

# Load test data in a similar fashion to train data
testData <- fread(file.path(path, "./UCI HAR Dataset/test/X_test.txt"))[, featuresNeeded, with = FALSE]
setnames(testData, names(testData), measurements)

activityTest <- fread(file.path(path, "./UCI HAR Dataset/test/y_test.txt"), col.names = "Activity")
subjectTest <- fread(file.path(path, "./UCI HAR Dataset/test/subject_test.txt"), col.names = "SubjectNo.")

test <- bind_cols(activityTest, subjectTest, testData)

# Merge test and train by rows
combinedData <- bind_rows(train, test)

# Factor Activity column based on activity labels
combinedData <- combinedData %>%
  mutate(
    Activity = factor(Activity, levels = activityLabels$classLabels, labels = activityLabels$activityNames),
    SubjectNo. = as.factor(SubjectNo.)
  )

# Pivot longer then summarise the data table
tidyData <- combinedData %>%
  pivot_longer(cols = -c(SubjectNo., Activity), names_to = "variable", values_to = "value") %>%
  group_by(SubjectNo., Activity, variable) %>%
  summarise(mean = mean(value, na.rm = TRUE), .groups = 'drop')

# Write final tidy data into new file
fwrite(tidyData, file = "tidyData.txt")
