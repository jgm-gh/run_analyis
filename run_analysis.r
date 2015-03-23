## run_analysis.r

colnames <- read.table("features.txt", stringsAsFactors = F)

d_train <- read.table("train/X_train.txt")
d_test <- read.table("test/X_test.txt")
d_merged <- rbind(d_train, d_test)
names(d_merged) <- colnames[,2]

colnames_mean_std <- grepl("mean", colnames[,2]) | grepl("std", colnames[,2])

d_merged_mean_std <- d_merged[, colnames[,2][colnames_mean_std]]

subject_train <- read.table("train/subject_train.txt")
subject_test <- read.table("test/subject_test.txt")

subject <- rbind(subject_train, subject_test)

activity_train <- read.table("train/y_train.txt")
activity_test <- read.table("test/y_test.txt")
activity <- rbind(activity_train, activity_test)

activity_labels <- read.table("activity_labels.txt")
activity <- sapply(activity, function(x) activity_labels[x,2])

d_merged_mean_std <- cbind(subject, activity, d_merged_mean_std)
names(d_merged_mean_std)[1] <- "subject"
names(d_merged_mean_std)[2] <- "activity"

d_tidy <- data.frame()

for(k in 3:ncol(d_merged_mean_std))
{
    d <- data.frame(tapply(d_merged_mean_std[,k],
                           list(subject[[1]], activity), mean))
    
    d <- cbind(rep(names(d_merged_mean_std)[k], nrow(d)), 1:nrow(d), d)
    names(d)[1] <- "VARIABLE"
    names(d)[2] <- "SUBJECT"
                       
    d_tidy <- rbind(d_tidy, d)
}
