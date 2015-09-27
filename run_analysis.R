library(dplyr)

feat <- read.table('UCI HAR Dataset/features.txt', stringsAsFactors=F, col.names=c('num','domain'))
domain <- feat$domain

strain <- read.table('UCI HAR Dataset/train/subject_train.txt', col.names="subject")
xtrain <- read.table('UCI HAR Dataset/train/X_train.txt', col.names=domain)
ytrain <- read.table('UCI HAR Dataset/train/y_train.txt', col.names="activity")
stest <- read.table('UCI HAR Dataset/test/subject_test.txt', col.names="subject")
xtest <- read.table('UCI HAR Dataset/test/X_test.txt', col.names=domain)
ytest <- read.table('UCI HAR Dataset/test/y_test.txt', col.names="activity")

act_lab <- read.table('UCI HAR Dataset/activity_labels.txt')
ytrain <- transform(ytrain, activity=factor(activity, labels=act_lab[,2]))
ytest <- transform(ytest, activity=factor(activity, labels=act_lab[,2]))

means <- grep('mean', feat$domain)
stds <- grep('std', feat$domain)
keep <- sort(c(means, stds))
xtrain_simp <- xtrain[,keep]
xtest_simp <- xtest[,keep]

train <- cbind(strain, ytrain, xtrain_simp)
test <- cbind(stest, ytest, xtest_simp)

all <- arrange(rbind(train, test), subject)
all_tbl <- tbl_df(all)
all_tbl <- all_tbl %>% group_by(subject, activity) %>% summarize_each(funs(mean))


write.table(all_tbl, file='Tidy.txt')
