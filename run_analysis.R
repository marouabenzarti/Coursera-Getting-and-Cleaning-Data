# read data train and test into data frames
subject_train <- read.table("./train/subject_train.txt")
subject_test <- read.table("./test/subject_test.txt")
X_train <- read.table("./train/X_train.txt")
X_test <- read.table("./test/X_test.txt")
y_train <- read.table("./train/y_train.txt")
y_test <- read.table("./test/y_test.txt")
# add column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
# add column names for features file
featureNames <- read.table("./features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
# add column name for label files y_train and y_test
names(y_train) <- "activity"
names(y_test) <- "activity"
# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)
# Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement
# determine which columns contain "mean()" or "std()"
meanstdcols <- grepl("mean\\(\\)", names(combined)) |grepl("std\\(\\)", names(combined))
# keep the subjectID and activity columns
meanstdcols[1:2] <- TRUE

# extract the columns that contain mean() or std ,the subjectID and activity columns
combined <- combined[, meanstdcols]
#Step 3 : Uses descriptive activity names to name the activities in the data set
# STEP 4: Appropriately labels the data set with descriptive activity names. 
combined$activity <- factor(combined$activity, labels=c("Walking",
                                                        "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
#Step 5 : From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
melteddata <- melt(combined, id=c("subjectID","activity"))
tidydata <- dcast(melteddata, subjectID+activity ~ variable, mean)
# write the tidy data set to a file
write.table(tidydata, "tidy.txt", row.names=FALSE)
