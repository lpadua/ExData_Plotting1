#################################################################################       
# plot3.R                                                                       #
# Author: Luis Padua                                                            #
# Date: 26-Jun-2017                                                             #
# As part of Project 1 of Course Exploratory Data Analysis from Coursera        #
#
# dataset need to be download from:
#  https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip
#################################################################################

if (!file.exists("data")) {
        dir.create("data")
}

library(dplyr)

householdPC <- read.table("./data/household_power_consumption.txt", 
                          header = TRUE,sep = ";", na.strings = "?")
householdPC <- tbl_df(householdPC)

#creating a column that store the timestamp as a Date-Time R varible
test <- paste(as.character(householdPC$Date), as.character(householdPC$Time))
householdPC <- mutate(householdPC, 
                      tstamp = as.POSIXct(strptime(test, "%d/%m/%Y %H:%M:%S")))
rm(test)
householdPC$Date <- as.Date(as.character(householdPC$Date), "%d/%m/%Y")

#filtering to the only days required to this activity 2017-Fev-01 and 02
householdPC <- filter(householdPC, Date >= "2007-02-01" & Date <= "2007-02-02")

#plot3 is a scatter with timestamp on xaxis and Energy from sub-meters 1 2 and 3
with(householdPC, plot(tstamp, Sub_metering_1, 
                       type = "n",
                       ylab = "Energy sub metering",
                       xlab = ""))
#adding the lines of each sub_metering and their respective color
with(householdPC, points(tstamp, Sub_metering_1, type = "l"))
with(householdPC, points(tstamp, Sub_metering_2, type = "l", col = "red"))
with(householdPC, points(tstamp, Sub_metering_3, type = "l", col = "blue"))

#adding the legend
legend("topright", 
       lty = c(1, 1, 1),
       col = c("black", "red", "blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

#saving the plot to PNG file, the default size is 480x480
dev.copy(png, "plot3.png")
dev.off()