## ---------------------------------------------------------------------------------
#Getting and Cleaning Data Course Project
#
#Submission by Sheryar Patel
#
#Assignment Details:
#
#You should create one R script called run_analysis.R that does the following. 
#
#       * Merges the training and the test sets to create one data set.
#       * Extracts only the measurements on the mean and standard deviation for each measurement. 
#       * Uses descriptive activity names to name the activities in the data set
#       * Appropriately labels the data set with descriptive variable names. 
#       * From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#
#Good luck!
## ---------------------------------------------------------------------------------


## ---------------------------------------------------------------------------------
## Start of First 4 Steps
## ---------------------------------------------------------------------------------


## -----------------------------
#Load Libraries
## -----------------------------
library(data.table)
library(dplyr)
library(reshape2)
library(lubridate)

## -----------------------------
# Download and unzip database
## -----------------------------
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "data.zip", mode = "wb")
#unzip("data.zip")

## -----------------------------
# Retrieve activity labels list
## -----------------------------
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

## -----------------------------
# Retrieve features list
## -----------------------------
features <- read.table("UCI HAR Dataset/features.txt", as.is = TRUE)
features <- features[-1]

## -----------------------------
# Retrieve test dataset, including activity and subject data
## -----------------------------
test_y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subjects_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test_data <- read.table("UCI HAR Dataset/test/X_test.txt")
test_data <- data.frame(test_subjects_test, test_y_test, test_data)

## -----------------------------
# Retrieve train dataset, including activity and subject data
## -----------------------------
train_y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subjects_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train_data <- read.table("UCI HAR Dataset/train/X_train.txt")
train_data <- data.frame(train_subjects_train, train_y_train, train_data)

## -----------------------------
# Merge both datasets
## -----------------------------
mergedData <- merge(test_data, train_data, all = TRUE)

## -----------------------------
# Name columns using the features list.
## -----------------------------
names(mergedData) <- unlist(c("Subject", "Activity", features))

## -----------------------------
# Replace activity labels number by activities name
## -----------------------------
mergedData$Activity <- activityLabels$V2[mergedData$Activity]

## -----------------------------
# Filter mean and std data.
## -----------------------------
newData <- mergedData[, c(1, 2, grep("mean|std", colnames(mergedData)))]


## ---------------------------------------------------------------------------------
## End of First 4 Steps in Questions
## ---------------------------------------------------------------------------------


## ---------------------------------------------------------------------------------
## Start of Step 5
## ---------------------------------------------------------------------------------

## -----------------------------
# Group data by subject and ativity
## -----------------------------
GD <- newData %>% group_by(Subject, Activity)

## -----------------------------
# Apply mean to each column (grouping variables are ignored)
## -----------------------------
TidyData <- summarise_each(GD, funs(mean))

## -----------------------------
# Order result by subject and activity
## -----------------------------
TidyData <- arrange(TidyData, Subject, Activity)

## -----------------------------
# Write result to txt file
## -----------------------------
write.table(TidyData, file = "TidyDataSet.txt", row.names = FALSE)
