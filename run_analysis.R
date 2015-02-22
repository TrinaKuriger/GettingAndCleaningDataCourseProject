# jkuriger
# Course Project
# Getting and Cleaning Data
# This code merges the UCI HAR training and test sets and extract only the 
# measurements on the mean and standard deviation for each measurement. It 
# calculates the average of each variable for each activity and each subject.
# It also renames the variables to make them descriptive, and then outputs 
# this new tidy data set of averages to a txt file.


#read in all of the data
testSubject <- read.table("UCI HAR Dataset/subject_test.txt")
testSet <- read.table("UCI HAR Dataset/X_test.txt")
testLabels <- read.table("UCI HAR Dataset/y_test.txt")
trainingSubject <- read.table("UCI HAR Dataset/subject_train.txt")
trainingSet <- read.table("UCI HAR Dataset/X_train.txt")
trainingLabels <- read.table("UCI HAR Dataset/y_train.txt")
labels <- read.table("UCI HAR Dataset/activity_labels.txt")
columnNames <- read.table("UCI HAR Dataset/features.txt",  stringsAsFactors = FALSE)

#extract column 2 from columnNames to use as column names
columnNames <- columnNames[,2]

#combine the testSet and trainingSet
testAndTrainSets <- rbind(testSet, trainingSet)

#replace BodyBody, () and - in columnNames (i.e. fix columnName errors)
columnNames <- gsub("BodyBody", "Body", columnNames, fixed = TRUE)
columnNames <- gsub("(", "", columnNames, fixed = TRUE)
columnNames <- gsub(")", "", columnNames, fixed = TRUE)
columnNames <- gsub("-", "_", columnNames, fixed = TRUE)
columnNames <- gsub(",", "_", columnNames, fixed = TRUE)
columnNames <- gsub(" ", "_", columnNames, fixed = TRUE)

#clarify f and t in column names with more descriptive terms  
columnNames <- gsub("fB", "freqB", columnNames, fixed = TRUE)
columnNames <- gsub("tB", "timeB", columnNames, fixed = TRUE)
columnNames <- gsub("tG", "timeG", columnNames, fixed = TRUE)

#change mean and std to camelCase
columnNames <- gsub("_mean", "Mean", columnNames, fixed = TRUE)
columnNames <- gsub("_std", "Std", columnNames, fixed = TRUE)

# mark to remove all the meanFreq and angle columns, since they contain word 
# mean but are not what we are looking for. First mark to remove by
# changing angle and meanFreq to "remove" to mark them all for removal
columnNames <- gsub("angle", "remove", columnNames, fixed = TRUE)
columnNames <- gsub("MeanFreq", "remove", columnNames, fixed = TRUE)

##assign columnNames as column names for testAndTrainSets
colnames(testAndTrainSets) <- columnNames


# then create a new data set without the columns marked to remove
noAngleMeanFrq <- testAndTrainSets[,!(grepl("remove", columnNames, fixed=TRUE))]
# also remove the same values from the columnNames file to use as an index
noAngleMeanFrqColumnNames <- columnNames[!(grepl("remove", columnNames,  
                                                  fixed=TRUE))]

#take all columns that include the words mean or std
meanAndStdSet <- noAngleMeanFrq[,((grepl("Std", noAngleMeanFrqColumnNames, 
      fixed=TRUE)) | (grepl("Mean", noAngleMeanFrqColumnNames,fixed=TRUE)))]



# combine testLabels and trainingLabels into a data frame, name column activity
activity <- rbind(testLabels, trainingLabels)
colnames(activity) <- "activity"

#combine activity with the meanAndStdSet
data <- cbind(activity, meanAndStdSet)  
  
# repeat the same with subject info
subject <- rbind(testSubject, trainingSubject)
colnames(subject) <- "subject"
data <- cbind(subject,data) 

# aggregate data by subject & activity and get the mean value of each variable
aggdata <-aggregate(data, by=list(data$subject,data$activity), FUN=mean, 
                    na.rm=TRUE)
# remove first two columns because they are identifiers placed by aggregate
data <- aggdata[,3:70]
                    

library(data.table)

# convert to data and labels to change the activity column from a 
# number to the associated description given in labels
data <- data.table(data)
labels <- data.table(labels)

# activity values are in num format but labels value are int format, so 
# convert activity values to int format so they will be compatible
data$activity <- as.integer(data$activity)

# change values in data$activity column referencing labels$V2 for new value
data <- data[,activity:=labels[V1==data$activity, V2]]


write.table(data, file = "tidy_data.txt", sep = "\t", row.names = FALSE)
