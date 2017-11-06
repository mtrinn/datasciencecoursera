# run_analysis.R

library(readr)
library(dplyr)
library(ggplot2)
library(reshape2)


# we load the features

features<-read_csv("D:\\rfiles\\UCI HAR Dataset\\features.txt",col_names=FALSE)
names(features)<-"features"

# we remove the numbers in front of the feature names

features$features<-sub("^(\\d+\\W+)", "",features$features)

# we load the activity labels

activitylabels<-read_csv("D:\\rfiles\\UCI HAR Dataset\\activity_labels.txt",col_names=FALSE)

names(activitylabels)<-"activity"

activitylabels$activity<-sub("^(\\d+\\W+)", "",activitylabels$activity)

activitylabels$n<-index(activitylabels)

# we load the test data

body_acc_x_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\body_acc_x_test.txt",sep="")

body_acc_y_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\body_acc_y_test.txt",sep="")

body_acc_z_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\body_acc_z_test.txt",sep="")

body_gyro_x_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\body_gyro_x_test.txt",sep="")

body_gyro_y_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\body_gyro_y_test.txt",sep="")

body_gyro_z_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\body_gyro_z_test.txt",sep="")

total_acc_x_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\total_acc_x_test.txt",sep="")

total_acc_y_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\total_acc_y_test.txt",sep="")

total_acc_z_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\Inertial Signals\\total_acc_z_test.txt",sep="")

subject_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\subject_test.txt")

names(subject_test)<-"subject"

X_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\X_test.txt")

y_test<-read.table("D:\\rfiles\\UCI HAR Dataset\\test\\y_test.txt")

# we name the columns of X according to the features

names(X_test)<-t(features)


# we load the train data

body_acc_x_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\body_acc_x_train.txt",sep="")

body_acc_y_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\body_acc_y_train.txt",sep="")

body_acc_z_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\body_acc_z_train.txt",sep="")

body_gyro_x_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_x_train.txt",sep="")

body_gyro_y_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_y_train.txt",sep="")

body_gyro_z_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\body_gyro_z_train.txt",sep="")

total_acc_x_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\total_acc_x_train.txt",sep="")

total_acc_y_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\total_acc_y_train.txt",sep="")

total_acc_z_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\Inertial Signals\\total_acc_z_train.txt",sep="")

subject_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\subject_train.txt")

names(subject_train)<-"subject"

X_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\X_train.txt")

y_train<-read.table("D:\\rfiles\\UCI HAR Dataset\\train\\y_train.txt")

# we name the columns of X according to the features

names(X_train)<-t(features)

# we mere the training and test data

X_total<-rbind(X_test,X_train)

y_total<-rbind(y_test,y_train)

# we merge the result activities with the labels

y_total2 <- merge(y_total, activitylabels, by.x="V1",by.y="n")

# we combine the subject identification for the test and train data 

subject_total<-rbind(subject_test,subject_train)

# we combine all

all_data<-cbind(subject_total,y_total2,X_total)

head(all_data)

all_data$y<-all_data$V1

all_data$V1<-NULL

# we calculate the statistics mean and standard deviation

melted <- melt(all_data,id.vars=c("activity","subject"))

stat_all_data<-melted %>% group_by(variable) %>% summarise(mean=mean(value), sd=sd(value))

names(stat_all_data)[1]<="measurement"

stat_by_activity_subject_all_data<-melted %>% group_by(activity,subject,variable) %>% summarise(mean=mean(value), sd=sd(value))

names(stat_by_activity_subject_all_data)[3]<-"measurement"

# summary statistics for all variables

stat_all_data

# summary statistics for all variables

tidy_Data<-stat_by_activity_subject_all_data

write.table(tidy_Data,file="tidy_data.txt",row.name=FALSE)


