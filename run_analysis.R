# Script for obtaining, tidying and cleaning data on wearable computing
# For assessment with Coursera's getting and cleaning data course project
# You should create one R script called run_analysis.R that does the following.
# 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(tidyverse)
library(readr)
library(data.table)

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "file.zip")

file <- unzip("file.zip")   # Folder "UCI Har Dataset" is extracted

list.files("./UCI Har Dataset") # Check what the dataset contains

setwd("./UCI Har Dataset") # Move into the dataset folder

# get some documentation to help understand everything, as well as decoding files
readme <- read.delim("README.txt")
  
features <- read.table("features.txt", col.names = c("n","functions")) # get feature names
activity_labels <- read.table("activity_labels.txt", col.names = c("code", "activity")) # links class labels with activity name

# get data for test set
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
test_data_x <- read.table("test/X_test.txt", col.names = features$functions)
test_data_y <- read.table("test/y_test.txt", col.names = "code")

# get data for training set
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
train_data_x <- read.table("train/X_train.txt", col.names = features$functions)
train_data_y <- read.table("train/y_train.txt", col.names = "code")

# Step 1 - Merge the training and test data sets individually, then together
data_X <- rbind(test_data_x, train_data_x)
data_Y <- rbind(test_data_y, train_data_y)
subject <- rbind(subject_test, subject_train)

Merged_data <- cbind(subject, data_X, data_Y )

# Step 2 - Subset and extract only the measurements that have mean and std for each measurement
head(names(Merged_data)) # we're looking for the format "*.mean..." or "*.std..."
Tidy_merge <- Merged_data %>% 
    select(subject, code, contains("mean"), contains("std"))
 # looking up how to use grepl since it's less familiar than select 
# grepl("subject|activity|mean|std",colnames(Merged_data)) # could also work if stored, and then used to subset

# Step 3 - Uses descriptive activity names to name the activities in the data set
Tidy_merge$code <- activity_labels[Tidy_merge$code,2]
names(Tidy_merge)[2] <- "Activity"

# Step 4 - Appropriately label the data set with descriptive variable names.
  #head(names(Tidy_merge)) # Apparently "tBodyAcc.mean...X" isn't informative
names(Tidy_merge)[1] <- "Subject"
features_info <- read.delim("features_info.txt")
  # view(features_info) # sort of explains what these variables are...
  # features_info[2:5,] # print the pertinent variable explanations

# the t vs f at the front of the variables indicates whether the we're in the time or frequency domain
# aka whether a Fast Fourier Transform (FFT) has been performed

names(Tidy_merge)<-gsub("^t", "Time", names(Tidy_merge))
names(Tidy_merge)<-gsub("^f", "FFT", names(Tidy_merge))

# Decoding the rest of the variable names a bit...
names(Tidy_merge)<-gsub("Acc","Accelerometer",names(Tidy_merge))
names(Tidy_merge)<-gsub("Gyro","Gyroscope",names(Tidy_merge))
names(Tidy_merge)<-gsub("angle", "Angle", names(Tidy_merge))
names(Tidy_merge)<-gsub(".tBody","TimeBody", names(Tidy_merge))
# Clean up the .[stat] nomenclature
names(Tidy_merge)<-gsub(".std","_StDev", names(Tidy_merge))
names(Tidy_merge)<-gsub(".mean","_Mean", names(Tidy_merge))

#Typo and special characters
names(Tidy_merge)<-gsub("BodyBody","Body",names(Tidy_merge))
names(Tidy_merge)<-gsub("[\\(\\)-]","",names(Tidy_merge))

  #names(Tidy_merge)  # last check of how the names look

#From the data set in step 4, create a second,
# independent tidy data set with the average of each variable for each activity and each subject.

AvgbyActSubj <- Tidy_merge %>% 
  group_by(Activity, Subject) %>% 
  summarise_each(funs(mean))

  # Output the result to a txt
write.table(AvgbyActSubj, "tidy_data.txt", row.names = FALSE, quote = FALSE)
