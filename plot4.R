library(dplyr)

## set folder with file "household_power_consumption.txt" as wd, 
## and file path to this txt file, save labels in variable v
setwd("D:/Education/R/exdata_data_household_power_consumption")
file_path="household_power_consumption.txt"
v <- as.character(read.table(file_path, sep=";", nrows=1))

## Read txt file in "data" without labels, convert date in standard format YYYY-MM-DD
## Merge date and time columns into one
## Rewrite "data" by selecting only two dates 2007-02-01 and 2007-02-02
## Set other columns except date and time as numeric
data <- read.table(file_path, sep = ";", skip=1) %>%
  mutate(V10=strptime(paste(V1,V2, sep=" "), "%d/%m/%Y %H:%M:%S")) %>%
  mutate(V1 = as.Date(V1, format = "%d/%m/%Y")) %>%
  mutate_at(vars(3:9), as.numeric) %>%
  filter(grepl("2007-02-01|2007-02-02", V1))

## Labeling all columns
colnames(data) <- c(v, "Date_time")

## Plotting 4 graphs and saving as "plot4.png"
png("plot4.png", width=480, height=480)
par (mfrow=c(2,2), mar=c(5,5,3,3))

## 1st graph
plot(data$Date_time, data$Global_active_power, col = "black", type = "l", xlab="", ylab = "Global Active Power (kilowatts)", xaxt = "n")
axis(1, at=pretty(data$Date_time, n=2), labels=c("Thu", "Fri", "Sat"))

## 2nd graph
with(data, plot(Date_time, Voltage, col = "black", type = "l", xlab="datetime", ylab = "Voltage", xaxt = "n"))
axis(1, at=pretty(data$Date_time, n=2), labels=c("Thu", "Fri", "Sat"))


## 3rd graph
with(data, plot(Date_time, Sub_metering_1, col = "black", type = "l", xlab="", ylab = "Energy sub metering", xaxt = "n"))
lines(data$Date_time, data$Sub_metering_2, col = "red", type = "l")
lines(data$Date_time, data$Sub_metering_3, col = "blue", type = "l")
legend("topright", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty= 1, col=c("black", "red", "blue"), bty="n")
axis(1, at=pretty(data$Date_time, n=2), labels=c("Thu", "Fri", "Sat"))

## 4th graph
with(data, plot(Date_time, Global_reactive_power, col = "black", type = "l", xlab="datetime", ylab = "Global_reactive_power", xaxt = "n"))
axis(1, at=pretty(data$Date_time, n=2), labels=c("Thu", "Fri", "Sat"))

dev.off()