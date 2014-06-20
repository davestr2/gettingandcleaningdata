file <- "data.zip"   ##  Name of the file after it is down loaded
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" #Where file is at
data_path <- "UCI HAR Dataset"
output_flder <- "output"



#Going to need the plyr package, that was installed earlier in the class
#Check to see if it was already done, if not install it

if(!is.element("plyr", installed.packages()[,1])){
        print("Installing packages")
        install.packages("plyr")
}

library(plyr)


##  Check to see if the file is already down loaded and in the working directory and the file is called data.zip

if(!file.exists(file)){
        
        ##Downloads the data file
        print("downloading Data")
        download.file(url,file, mode = "wb")
        
}


##  Create the output file if it dowes not exists


if(!file.exists(output_flder)){
        print("Creating result folder")
        dir.create(output_flder)
}

##reads a table from the zip data file and applies cols
getTable <- function (filename,cols = NULL){
        
        print(paste("Getting table:", filename))
        
        f <- unz(file, paste(data_path,filename,sep="/"))
        
        data <- data.frame()
        
        if(is.null(cols)){
                data <- read.table(f,sep="",stringsAsFactors=F)
        } else {
                data <- read.table(f,sep="",stringsAsFactors=F, col.names= cols)
        }
        
        
        data
        
}

# Read the three files (subject, y, and X and then combine by columns)


getData <- function(type, features){
        
        print(paste("Getting data", type))
        
        subject_data <- getTable(paste(type,"/","subject_",type,".txt",sep=""),"id")
        y_data <- getTable(paste(type,"/","y_",type,".txt",sep=""),"activity")
        x_data <- getTable(paste(type,"/","X_",type,".txt",sep=""),features$V2)
        
        return (cbind(subject_data,y_data,x_data))
}

##saves the data into the output folder


saveResult <- function (data,name){
        
        print(paste("Saving data", name))
        
        file <- paste(output_flder, "/", name,".csv" ,sep="")
        write.csv(data,file)
}



# Read the features file which has the column names

#features used for col names when creating train and test data sets
features <- getTable("features.txt")

## Read and combine the files from the directoy into on file

train <- getData("train",features)
test <- getData("test",features)

##  Combine the train and the test data by row


data <- rbind(train, test)

# rearrange the data using id
data <- arrange(data, id)



##  Make the activity most discript using the activity labels

## Appropriately labels the data set with descriptive activity names. 
activity_labels <- getTable("activity_labels.txt")

data$activity <- factor(data$activity, levels=activity_labels$V1, labels=activity_labels$V2)



## Keep the columns on the mean and standard deviation for each measurement.

dataset1 <- data[,c(1,2,grep("std", colnames(data)), grep("mean", colnames(data)))]


# save dataset1 into output folder
saveResult(dataset1,"dataset1")

## Creates a seconddata set with the average of each variable for each activity and each subject.

dataset2 <- ddply(dataset1, .(id, activity), .fun=function(x){ colMeans(x[,-c(1:2)]) })

# Adds "_mean" to colnames
colnames(dataset2)[-c(1:2)] <- paste(colnames(dataset2)[-c(1:2)], "_mean", sep="")

# Save tidy dataset2 into output folder
saveResult(dataset2,"dataset2")