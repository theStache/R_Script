#Reads in CSV based on WinEvent 4768, selects column containing Username, Domain, IP.
#
#Use at own risk; Tyler Williams - tjwill86@gmail.com; 20180308 
# :{

ReformatIPs <- function(df, column_name) 
{
  ipv4_index <- grepl("^::ffff:", df[,column_name])
  df$upper[ipv4_index] <- strtoi(paste("0x",sub("^::ffff:(.{0,4}):(.{0,4})", "\\1", df[ipv4_index,column_name]), sep=""))
  df$lower[ipv4_index] <- strtoi(paste("0x",sub("^::ffff:(.{0,4}):(.{0,4})", "\\2", df[ipv4_index,column_name]), sep=""))
  df$octet2[ipv4_index] <- bitwAnd(df$upper[ipv4_index],0xff)
  df$octet1[ipv4_index] <- bitwShiftR(df$upper[ipv4_index],8)
  df$octet4[ipv4_index] <- bitwAnd(df$lower[ipv4_index],0xff)
  df$octet3[ipv4_index] <- bitwShiftR(df$lower[ipv4_index],8)
  df[ipv4_index,column_name] <- paste(df$octet1[ipv4_index], df$octet2[ipv4_index], df$octet3[ipv4_index], df$octet4[ipv4_index],sep=".")
  return(df[,column_name])
}
old <- Sys.time()
setwd("dir/contains/csv/")

#inputfile = "KerbEventsEnterpriseQueryData.csv"
#outputfile = "Rscript_ON_TESTDATA.csv"
inputfile = "1000RowsKerbData.csv"
csv_read_in <- read.csv(file=inputfile, stringsAsFactors = FALSE)
print(Sys.time())
csv_read_in$IP_WINDOWSEVENT <- ReformatIPs(csv_read_in, "IP_WINDOWSEVENT")
csv_read_in$HOSTNAME_TARGET <- toupper(csv_read_in$HOSTNAME_TARGET)

#stripping unused fields to help speed up the analysis
csv_read_in <- within(csv_read_in, rm("Data.Type"))
csv_read_in <- within(csv_read_in, rm("IS_GROUP"))
csv_read_in <- within(csv_read_in, rm("COUNT"))
csv_read_in <- within(csv_read_in, rm("Visibility"))
csv_read_in <- within(csv_read_in, rm("Id"))
csv_read_in <- within(csv_read_in, rm("Timestamp"))
print("StripCol")
print(new <- Sys.time() - old)

#Normalizing IP and Strippingdomain down to lowestlevel
csv_read_in <- unique(csv_read_in[,1:3]) #dedupes exact same rows
csv_read_in$IP_WINDOWSEVENT <- ReformatIPs(csv_read_in, "IP_WINDOWSEVENT")
#csv_read_in$HOSTNAME_TARGET <- sub("#thing to normalize hostname if needed#",'',csv_read_in$HOSTNAME_TARGET)
csv_read_in$HOSTNAME_TARGET <- toupper(csv_read_in$HOSTNAME_TARGET)
print("NormData")
print(new <- Sys.time() - old)

#building subsets of items that match criteria
svcNames <- subset(csv_read_in, grepl("*svc|service*", USERNAME_TARGET, ignore.case = TRUE))
wrkstationNames <- subset(csv_read_in, grepl("*\\$", USERNAME_TARGET, ignore.case = TRUE))
print("SubsetBuilder")
print(new <- Sys.time() - old)

for(xlen in 1:length(svcNames)){if(match <- grep(svcNames$IP_WINDOWSEVENT[xlen],wrkstationNames$IP_WINDOWSEVENT)){if(svcNames$HOSTNAME_TARGET[xlen] != wrkstationNames$HOSTNAME_TARGET[match]){print((paste(svcNames[xlen,],wrkstationNames[match,])))}}}         


#write.csv(checkMatch,outputfile, row.names = FALSE)
new <- Sys.time() - old
print(new)
