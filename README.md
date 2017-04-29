# Getting and Cleaning Data Course Project

This is a peer assessment for Getting and Cleaning Data Course on Coursera. R is used as the language to write the source file known as run_analysis.R. This fie consists of a few scripts that do the following:

1. The data is first loaded by downloading the dataset if it does not exist in the working directory.

2. Packages (deplyr and data.table) are installed and loaded. 

3. Check whether the UCI HAR data set has already been unzipped. 

4. List all the files of UCI HAR Dataset folder to identify which file to be used.
* The files that will be used to load data are listed as follows:
- train/X_train.txt
- test/X_test.txt
- test/y_test.txt
- train/y_train.txt
- train/subject_train.txt
- test/subject_test.txt

5. Load information from all the test and trin datasets.
* Read data from the files into the variables
- Read the label files ( "Y_test.txt","Y_train.txt")
- Read the Subject files( "subject_train.txt", "subject_test.txt")
- Read set files( "X_test.txt" ,"X_train.txt")
- Read list of features("features.txt")

6. Test: Check properties by using str.

7. Merge traiing and test data to form one single data. 
* Concatenate the data tables by rows
* Set names to variables for each column in the dataset
* Merge columns to get the whole data frame 

8. Extracts only the measurements on the mean and standard deviation for each measurement.
* Subset Name of Features by measurements on the mean and standard deviation (i.e taken Names of Features with "mean()" or "std()")
* Subset the data frame Data by seleted names of Features

9. Check the structures of the data frame Data by using str.

10. Descriptive activity names are used to name the activities in the data set.
* Read descriptive activity names from "activity_labels.txt"
* Factorize Variale activity in the data frame Data using descriptive activity names
* Test Print using head()

11. Appropriately labels the data set with descriptive variable names
* Test Print (List all the names of the variables) by using names()

12. Creates a independent tidy data set which consists of the mean value of each variable for each subject and activity pair.
* Final output file is tidydata.txt
