# 1. Merges the training and the test sets to create one data set.
actLabel <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("activityLabel", "activityName"))
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("featureLabel", "featureName"))
subTest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subjectID")
XTest <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names = features$featureName)
yTest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "activityLabel")
testData <- cbind(subTest, XTest, yTest)
subTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "subjectID")
XTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names = features$featureName)
yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "activityLabel")
trainData <- cbind(subTrain, XTrain, yTrain)
allData <- rbind(testData, trainData)

names(allData)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
meanSdData <- allData[, c(1, grep("mean|std", names(allData)), 563)]

# 3. Use descriptive activity names to name the activities in the data set.
meanSdData$activity <- factor(meanSdData$activityLabel, levels = actLabel$activityLabel, labels = actLabel$activityName)

# 4. Appropriately labels the data set with descriptive variable names. 
colnames(meanSdData) <- gsub("\\.", "", names(meanSdData))

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(dplyr)
tidy_data <- group_by(meanSdData, subjectID, activity) %>% summarise_all(mean)

write.table(tidy_data, file = 'tidyDataMean.txt', row.names = FALSE)










