# GettingAndCleaningDataCourseProject
Contents of this repo:
1) this README file
2) data file named tidy_data.txt
3) CodeBook for the data file named Codebook.Rmd
4) run_analysis.R file containing code used to create tidy_data.txt


In order to run the run_analysis.R code, you must have the package "data.table" installed. 
You also need to have the UCI HAR Dataset folder in your working directory. This folder needs to contain 
the following files: subject_test.txt, X_test.txt, y_test.txt, subject_train.txt, X_train.txt, 
y_train.txt, activity_labels.txt, and features.txt.  This data is NOT included in this repo, but it 
can be downloaded at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

To load the data that I generated for this project into R, make sure the tidy_data.txt file is in your working 
directory and run the following code:
data (tidy_data, header = TRUE) 
View(data)

For a description of the transformations that run_analysis.R performs on the UCI HAR Dataset please see the 
Codebook.Rmd file.