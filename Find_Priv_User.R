#This could probably be better implemented but it works so take it or leave it or improve it and leave comments
#Change the setwd to where your list of files are located
#Change the inputfiles list to the files named in the directory
#The outputfile will drop newly created files in the directory specified by setwd
#Created and last updated by Tyler Williams 20180503
# :{

old <- Sys.time()
setwd("")
inputfiles = c("file1.csv","file2.csv","file3.csv")
for(inputfile in inputfiles){
rich <- "Enriched_"
outputfile = paste(rich,inputfile)
CSV_read_in <- read.csv(file=inputfile, stringsAsFactors = FALSE)
#CSV_read_in <- na.omit(CSV_read_in)
#CSV_read_in[is.na(CSV_read_in)] <- 0
#CSV_read_in <- na.omit(CSV_read_in)
CSV_read_in$PrivledgedConfidence <- 0
new <- Sys.time() - old
print(new)

x <- grep("svc|service|admin|administrator",CSV_read_in$MemberOf, ignore.case = TRUE)
for(rn in 1:length(x))CSV_read_in$PrivledgedConfidence[x[rn]] <- 1

y <- grep("svc|service|admin|administrator",CSV_read_in$UserPrincipalName, ignore.case = TRUE)
for(rn in 1:length(x))CSV_read_in$PrivledgedConfidence[x[rn]] <- 1

z <- (grep("TRUE",CSV_read_in$TrustedForDelegation))
for(rn in 1:length(z))CSV_read_in$PrivledgedConfidence[z[rn]] <- 1

xx <- (grep("svc|service|admin|administrator",CSV_read_in$SamAccountName, ignore.case = TRUE))
for(rn in 1:length(xx))CSV_read_in$PrivledgedConfidence[xx[rn]] <- 1

yy <- (grep("svc|service|admin|administrator",CSV_read_in$DistinguishedName, ignore.case = TRUE))
for(rn in 1:length(yy))CSV_read_in$PrivledgedConfidence[yy[rn]] <- 1

print(Sys.time())
write.csv(CSV_read_in,outputfile, row.names = FALSE)
new <- Sys.time() - old
print(new)
}
print(new)
