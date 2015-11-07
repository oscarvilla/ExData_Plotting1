current_dir <- getwd()
if (file.exists("plots")){
        setwd(file.path(getwd(), "plots"))
} else {
        dir.create(file.path(getwd(), "plots"))
        setwd(file.path(getwd(), "plots"))
        
}
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", temp)
data <- read.table(unz(temp, "household_power_consumption.txt"), sep = ";", 
                   nrows = 2880, skip = 66637, check.names = T, na.strings = "?")
names(data) <- names(read.table(unz(temp, "household_power_consumption.txt"), 
                                sep = ";", nrows = 1, header = T))
unlink(temp)
library(lubridate)
dateTime <- dmy_hms(paste(data$Date, data$Time))
data <- cbind(dateTime, data[3:9])
##Shut down opened devices
dev.off(which = dev.cur())
##Plotting
plot.ts(data$Global_active_power, xlab = "", xaxt = "n", ylab= "Global Active Power (Kilowatts)")
axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
## Saving the .png file
dev.copy(png, file = "plot2.png")
dev.off()
##Returning to the begining path
setwd(current_dir)