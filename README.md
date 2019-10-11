# GettingandCleaningDataProject
For organizing files associated with the course project from Coursera's Getting and Cleaning Data course

This project is designed to take a dataset (downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ), a dataset involving data collected from wearable smart devices and clean/tidy the dataset making it useful for further downstream analyses.
Descriptions of the dataset can be found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Please see CodeBook.Rmd for descriptions of the steps taken to tidy this dataset.
The script run_analysis.R was written to perform cleaning and tidying on this dataset, merging test and training datasets with subject IDs. There are 561 variables (measurements) that have been gathered by wearable devices in both the frequency and time domains about the subject during specific activities (1:6 - see Codebook.Rmd for descriptions of activities). These measurement labels were expanded to be more user-friendly to read and interpret. Finally, run_analysis.R extracts a subsetted, tidy data set and summarizes the data by both activity and subject, into the means and standard deviations for each measurement. This output can be found in tidy_data.txt.


To do:
    1. ~~Download data~~
    2. ~~Write script (5 steps)~~
    3. ~~Write-out tidied dataset~~
    4. ~~Write up Codebook~~
    5. ~~Organize and error-checking~~

