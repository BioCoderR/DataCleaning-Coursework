# Project Code Book

This document serves as the code book for the project and it provides essential information on how to access the source data and execute R-script to understand the variable & transformations applied to data in this process.

## How to access the Data:

**1. Download the Data:**

-   Download the source data from this link [Data for the project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
-   Unzipping the `data.zip` into the working directory of R studio is present in the script

**2. Executing the R script:**

-   Run the R-script name `run_analysis.R` to perform the necessary operations on the data.

## About the Source Data:

The source data for the project is originated from the Human Activity Recognition Using Smartphones Data Set. A detailed description is available at the official site: [Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Direct Link to the data [UCI HAR Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## About the R Script:

The script titled `run_analysis.R` performs the following steps assigned task for the coursework

1.  **Data Reading and Merging:**

-   Reading the Training & Testing datasets along with feature vectors and activity labels.
-   Assigns the variable names.
-   Merges all the data tables into one merged dataset.

2.  **Extracting Relevant Measurements for Mean and Standard Deviations:**

-   Selecting only the measurements corresponding to mean and standard deviations of each feature.

3.  **Descriptive Activity Naming:**

-   Usage of the descriptive activity names to label the activities in the dataset.

4.  **Descriptive Variable changing:**

-   Appropriately labeling the dataset with the descriptive variable names.

5.  **Creating a Final Tidy Data Set:**

-   Generating the independent Final Tidy Data set with the average of each variable for the each activity and each subject.
-   Writing the resultant tidy dataset into a text file Note: The code assumes that all the data files are present within the same folder in uncompressed and with their original names intact.

## About variables:

-   `xTrain`, `yTrain`, `xTest`, `yTest`, `subTrain`, `subTest`, `activityLabels`, and `features` contain data from the downloaded files.
-   `TrainData`, `TestData`, and `FinalSet` are the merged datasets for the further analysis.
-   `features` contain the corrected names for the `xTrain`, `xTest`, applied to the column names for detailed references.

Please refer to this document for clear understanding of the project's data sources, processing steps and variables used in the analysis for this course work.
