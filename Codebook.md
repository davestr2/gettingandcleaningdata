	The purpose of this project was to collect, work woth and clean a data set. The data that was selected to be used came from a study about wearable computing. The data used represents data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones  



The flow of the R script is as follows:

1)	Check to see if library "plyr" is installed, if not install it

2)	Check to see if the zip file exists, if not download it

3)	Check to see if the output folder exists, is not create it

4)	Read in the features.txt file

5)	Read in the real data from the two directories and create one big file

6)	Get the Activity lables and make the Activity most descriptive

7)	Save the combined data set with only the columns re want (id, activity and those with "mean" and "std"

8)	Create and save a second data set that has the mean of all the columns except id and activity 


The original datasets have columns described in the features.txt file. If this analysis, only those columns that were either the mean or the standard deviation (std) were used.


