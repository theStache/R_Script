#Used in conjunction with FindPrivUser script, builds a master list of privileged users.
#Use at own risk, always review before using.
#Created 20180504 Tyler Williams v1
# :{

old <- Sys.time()
setwd("working\dir\with\files")
inputfiles = c("namedFile1inDir.csv","namedFile2inDir.csv","namedFile3inDir.csv")
outputfile = "MasterPrivList.csv"

namesfile = "namedFile1inDir.csv" 
#Used to build the new data frame with the correct column names
CSVread <- read.csv(file=namesfile, stringsAsFactors = FALSE)
CSVPrivList <- CSVread[0,]
for(inputfile in inputfiles){
CSV_read_in <- read.csv(file=inputfile, stringsAsFactors = FALSE)
CSVPrivList <- rbind(CSVPrivList, subset(CSV_read_in,CSV_read_in$PrivledgedConfidence==1))
new <- Sys.time() - old
print(new)
}
write.csv(CSVPrivList,outputfile, row.names = FALSE)
print(new)
