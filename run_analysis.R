setwd("/Users/tanay/Documents/R Programs/GettingAndCleaningData/UCI HAR Dataset")  #setting the working directory
library(plyr)
library(data.table)

#Q1 Merging training and test data sets to create one data set
#Loading all the raw data sets
xTrain = read.table('./train/x_train.txt',header=FALSE)
subjectTrain = read.table('./train/subject_train.txt',header=FALSE)
yTrain = read.table('./train/y_train.txt',header=FALSE)
xTest = read.table('./test/x_test.txt',header=FALSE)
subjectTest = read.table('./test/subject_test.txt',header=FALSE)
#combining raw data sets into one
yTest = read.table('./test/y_test.txt',header=FALSE)
yDataSet <- rbind(yTrain, yTest)
xDataSet <- rbind(xTrain, xTest)
subjectDataSet <- rbind(subjectTrain, subjectTest)
dim(xDataSet)
dim(yDataSet)
dim(subjectDataSet)

#Q2 Extracting only the measurements on the mean and standard deviation for each measurement
xDataSet_mean_std <- xDataSet[, grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2])]
names(xDataSet_mean_std) <- read.table("features.txt")[grep("-(mean|std)\\(\\)", read.table("features.txt")[, 2]), 2] 
View(xDataSet_mean_std)
dim(xDataSet_mean_std)

#Q3 Using descriptive activity names to name the activities in data set.
yDataSet[, 1] <- read.table("activity_labels.txt")[yDataSet[, 1], 2]
names(yDataSet) <- "Activity"
View(yDataSet)

#Q4 Appropriately labeling the data set with descriptive activity names
names(subjectDataSet) <- "Subject"
summary(subjectDataSet)
# Organizing and combining all the data sets into a single one.
singleDataSet <- cbind(xDataSet_mean_std, yDataSet, subjectDataSet)

# Giving descriptive names to all the variables.
names(singleDataSet) <- make.names(names(singleDataSet))
names(singleDataSet) <- gsub('Acc',"Acceleration",names(singleDataSet))
names(singleDataSet) <- gsub('GyroJerk',"AngularAcceleration",names(singleDataSet))
names(singleDataSet) <- gsub('Gyro',"AngularSpeed",names(singleDataSet))
names(singleDataSet) <- gsub('Mag',"Magnitude",names(singleDataSet))
names(singleDataSet) <- gsub('^t',"TimeDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('^f',"FrequencyDomain.",names(singleDataSet))
names(singleDataSet) <- gsub('\\.mean',".Mean",names(singleDataSet))
names(singleDataSet) <- gsub('\\.std',".StandardDeviation",names(singleDataSet))
names(singleDataSet) <- gsub('Freq\\.',"Frequency.",names(singleDataSet))
names(singleDataSet) <- gsub('Freq$',"Frequency",names(singleDataSet))

View(singleDataSet)

#Q5 Creating a second, independent tidy data set with the average of each variable for each activity and each subject
names(singleDataSet)
Data2<-aggregate(. ~Subject + Activity, singleDataSet, mean)
Data2<-Data2[order(Data2$Subject,Data2$Activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

library(codebook)
new_codebook_rmd()
