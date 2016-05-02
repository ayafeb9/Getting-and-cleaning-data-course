# run_analysis.R 
# created for Week 4 Getting and Cleaning Data R Course
# by Aya Hozumi April 25, 2016
library(dplyr)
library(data.table)
library(tidyr)

# dat unzipped from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# load the X_test.txt and X_train.txt
train<-tbl_df(read.table("X_train.txt"))
test<-tbl_df(read.table("X_test.txt"))
# load attributes of the data
subjecttrain<-tbl_df(read.table("subject_train.txt"))
subjecttest<-tbl_df(read.table("subject_test.txt"))
activitytrain<-tbl_df(read.table("Y_train.txt"))
activitytest<-tbl_df(read.table("Y_test.txt"))
features<-tbl_df(read.table("features.txt"))
activitylabels<-tbl_df(read.table("activity_labels.txt"))

#1 Merges the training and the test sets to create one data set.
subject<-rbind(subjecttrain,subjecttest)
setnames(subject,"V1","subject")
activity<-rbind(activitytrain,activitytest)
setnames(activity,"V1","activity_num")
table<-rbind(train,test)
# now subject,activity,table are merged datasets
# use feature list as variable names for table
setnames(features,names(features),c("feature_num","feature_name"))
colnames(table)<-features$feature_name
all_table<-cbind(subject,activity,table)
# use activity list as variable names for activity
setnames(activitylabels,names(activitylabels),c("activity_num","activity_name"))

#2 Extracts only the measurements on the mean and standard deviation for each measurement.
extract_mean_std<-grepl("mean|std",features$feature_name)
extracted_table<-all_table[,extract_mean_std]

#3 Uses descriptive activity names to name the activities in the data set
all_table<-merge(activitylabels,all_table,by="activity_num",all.x=TRUE)
table$activity_name <- as.character(table$activity_name)

#4 Appropriately labels the data set with descriptive variable names.
names(all_table)<-gsub("std()", "St Dev", names(all_table))
names(all_table)<-gsub("^t", "Time", names(all_table))
names(all_table)<-gsub("^f", "Frequency", names(all_table))
names(all_table)<-gsub("Acc", "Accelerometer", names(all_table))
names(all_table)<-gsub("Gyro", "Gyroscope", names(all_table))
names(all_table)<-gsub("Mag", "Magnitude", names(all_table))
names(all_table)<-gsub("BodyBody", "Body", names(all_table))

#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(table,"independent_tidy_data.txt",row.name=FALSE)

