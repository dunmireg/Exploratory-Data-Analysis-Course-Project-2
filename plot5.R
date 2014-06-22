# This is plot5 for the Exploratory Data Analysis class offered by Johns Hopkins
# on Coursera. This graph answers how emissions from motor vehicles have changed
# across Baltimore City. To construct the graph, this code
# requires the NEI and SCC data sets unzipped and loaded into the working directory
# (zip files can be found https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip).
# The code then outputs a png file into the working directory with the result.

#read in data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
#coerce to character
SCC$EI.Sector <- as.character(SCC$EI.Sector)

#Use regular expression to get what I believe are motor vehicles. There will be differences of
#opinion but this avoids getting offroad machinery. This regular expression treats only 
#mobile and on-road objects as motor vehicles (aka cars)
SCC.car <- SCC[grep("Mobile.*On-Road", SCC$EI.Sector),]

#coerce to character, get the correct SCC codes, and then subset based on Baltimore City and proper codes
SCC.car$SCC <- as.character(SCC.car$SCC)
codes <- SCC.car$SCC
NEI.Bmore <- NEI[NEI$fips == "24510",]
NEI.Bmore.MV <- subset(NEI.Bmore, NEI.Bmore$SCC %in% codes) #1119 observations

#produce final data frame summing emissions and grouping by year
result <- aggregate(NEI.Bmore.MV$Emissions, by = list(NEI.Bmore.MV$year), FUN = sum)

colnames(result) <- c("Year", "Total")
result$Year <- factor(result$Year)

#load ggplot2
if(require(ggplot2)) {
  library(ggplot2)
} else {
  install.packages("ggplot2")
  if (require(ggplot2)) {
    library(ggplot2)
  } else {
    stop("Could not load ggplot2")
  }
}

#Construct plot. Note use of stat = identity to use Total values as opposed to frequency count.
#Also note I've added the total values for ease.
png(filename = "plot5.png")
myplot <- ggplot(result, aes(x = Year, y = Total)) +
  geom_bar(stat = "identity", aes(fill = Year)) +
  geom_text(aes(label = round(Total, 2), size = 1, hjust = 0.5, vjust = 2)) +
  ggtitle(expression("Emissions from Motor Vehicles in Baltimore from 1999 to 2008")) +
  xlab(expression("Year")) + ylab(expression("PM2.5 Emissions from Motor Vehicles (tons)"))
print(myplot)
dev.off()