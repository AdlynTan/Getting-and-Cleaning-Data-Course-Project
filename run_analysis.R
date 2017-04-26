##STEP 1 LOAD DATA
##1. Obtain the data
##2. Download the file and unzip
if(!file.exists('data')) dir.create('data')
fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile= './data/dataset.zip')
unzip('./data/dataset.zip', exdir = './data')

##3. Install packages
install.packages("dplyr")
install.packages("data.table")
library(dplyr)
library(data.table)
## 4. Check if zip has already been unzipped?
if(!file.exists("./data/UCI HAR Dataset")){
  unzip(zipfile="./data/project_Dataset.zip",exdir="./data")
}
## 5. List all the files of UCI HAR Dataset folder to identify which file to be used
path <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path, recursive=TRUE)

##Decision made from looking at the list:
##The files that will be used to load data are listed as follows:
# train/X_train.txt
# test/X_test.txt
# test/y_test.txt
# train/y_train.txt
# train/subject_train.txt
# test/subject_test.txt

##STEP 2:LOAD INFORMATION FROM ALL THE TEST AND TRAIN DATASETS
## Read data from the files into the variables
## 1. Read the label files
labelTest  <- read.table(file.path(path, "test" , "Y_test.txt" ),header = FALSE)
labelTrain <- read.table(file.path(path, "train", "Y_train.txt"),header = FALSE)
## 2. Read the Subject files
SubjectTrain <- read.table(file.path(path, "train", "subject_train.txt"),header = FALSE)
SubjectTest  <- read.table(file.path(path, "test" , "subject_test.txt"),header = FALSE)

## 3. Read set files
setTest  <- read.table(file.path(path, "test" , "X_test.txt" ),header = FALSE)
setTrain <- read.table(file.path(path, "train", "X_train.txt"),header = FALSE)

## 4. Read list of features
features <- read.table(file.path(path, "features.txt"),header=FALSE)

## Test: Check properties

str(labelTest)
str(labelTrain)
str(SubjectTrain)
str(SubjectTest)
str(setTest)
str(setTrain)
str(features)

## STEP 3: MERGE TRAINING AND TEST DATA TO FORM ONE SINGLE DATASET

## 1.Concatenate the data tables by rows
dataSubject <- rbind(SubjectTrain, SubjectTest)
dataActivity<- rbind(labelTrain, labelTest)
dataFeatures<- rbind(setTrain, setTest)

## 2. Set names to variables for each column in the dataset
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
names(dataFeatures)<- features$V2

## 3. Merge columns to get the whole data frame 
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

## STEP 4: Extracts only the measurements on the mean and standard deviation for each measurement.
## 1. Subset Name of Features by measurements on the mean and standard deviation
## i.e taken Names of Features with "mean()" or "std()"
## Extract using grep
subdataFeaturesCols<-features$V2[grep("mean\\(\\)|std\\(\\)", features$V2)]
## 2. Subset the data frame Data by seleted names of Features
selectedCols<-c(as.character(subdataFeaturesCols), "subject", "activity" )
Data<-subset(Data,select=selectedCols)
## 3. Test : Check the structures of the data frame Data
str(Data)

## STEP 5: Uses descriptive activity names to name the activities in the data set
## 1. Read descriptive activity names from "activity_labels.txt"
activityLabels <- read.table(file.path(path, "activity_labels.txt"),header = FALSE)
## 2. Factorize Variale activity in the data frame Data using descriptive activity names
Data$activity<-factor(Data$activity,labels=activityLabels[,2])
## 3. Test Print
head(Data$activity,100)
head(Data)

## STEP 6: Appropriately labels the data set with descriptive variable names
#gsub() function replaces all matches of a string, 
#if the parameter is a string vector, 
#returns a string vector of the same length and with the same attributes
names(Data)<-gsub("^t", "Time", names(Data))
names(Data)<-gsub("^f", "Frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))
## Test Print (List all the names of the variables)
names(Data)

## STEP 7: Creates a independent tidy data set

tidyData<-aggregate(. ~subject + activity, Data, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "tidydata.txt",row.name=FALSE,quote = FALSE, sep = '\t')