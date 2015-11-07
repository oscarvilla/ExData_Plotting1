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
##plot
par(mfrow = c(2,2))
with(data, {
##plot 1        
        plot.ts(data$Global_active_power, xlab = "", xaxt = "n", 
                     ylab= "Global Active Power")
        axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
##plot 2
        plot.ts(data$Voltage, xaxt = "n", 
                ylab= "Voltage", xlab = "datetime")
        axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
##plot 3
        plot.ts(data$Sub_metering_1, xlab = "", ylab = "Energy sub metering", xaxt = "n", 
                col = "black", ylim = c(0, 38))
        par(new = T)
        plot.ts(data$Sub_metering_2, xlab = "", ylab = "", xaxt = "n", col = "red", 
                yaxt = "n", ylim = c(0, 38))
        par(new = T)
        plot.ts(data$Sub_metering_3, xlab = "", ylab = "", xaxt = "n", col = "blue", 
                yaxt = "n", ylim = c(0, 38))
        axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
        axis(2, at = c(0, 10, 20, 30), labels = c("0", "10", "20", "30"))
        legend("topright", pch = 1, col = c("black", "red", "blue"), 
               legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
               bty = "n", xjust = 0, yjust = 0)
##plot 4
        plot.ts(data$Global_reactive_power, xaxt = "n", 
                ylab= "Global_reactive_power", xlab = "datetime")
        axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
        })
##end plot
## Saving the .png file
dev.copy(png, file = "plot4.png")
dev.off()
##Returning to the begining path
setwd(current_dir)