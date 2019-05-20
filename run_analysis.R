library(dplyr) 
#UIC HAR dataset name of the folder downloaded in the zipfile
setwd("UCI HAR Dataset")


x_act <- read.table("./train/X_train.txt")
y_act   <- read.table("./train/Y_train.txt") 
sub_act <- read.table("./train/subject_train.txt")

 
x   <- read.table("./test/X_test.txt")
y   <- read.table("./test/Y_test.txt") 
sub <- read.table("./test/subject_test.txt")


features <- read.table("./features.txt") 

activity_labels <- read.table("./activity_labels.txt") 
x_total   <- rbind(x_act, x)
y_total   <- rbind(y_act, y) 
sub_total <- rbind(sub_act, sub) 


sel_features <- variable_names[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total      <- x_total[,sel_features[,1]]

# name columns
colnames(x_total)   <- sel_features[,2]
colnames(y_total)   <- "activity"
colnames(sub_total) <- "subject"

# dataset merging
total <- cbind(sub_total, y_total, x_total)
total$activity <- factor(total$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
total$subject  <- as.factor(total$subject) 


total_mean <- total %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 
#create new text file
write.table(total_mean, file = "./new_dataset.txt", row.names = FALSE, col.names = TRUE) 
