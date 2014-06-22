# This is plot6 for the Exploratory Data Analysis class offered by Johns Hopkins
# on Coursera. This graph answers how emissions from motor vehicles have changed
# across Baltimore City vs Los Angeles County. To construct the graph, this code
# requires the NEI and SCC data sets unzipped and loaded into the working directory
# (zip files can be found https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip).
# The code then outputs a png file into the working directory with the result.

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#coerce to a character and grep using same Motor Vehicle regular expression on plot 5 (there will be differences of opinion)
SCC$EI.Sector <- as.character(SCC$EI.Sector)
SCC.car <- SCC[grep("Mobile.*On-Road", SCC$EI.Sector),] 

#Get the appropriate SCC codes coerced as characters and create subsets of NEI data for Baltimore and LA
SCC.car$SCC <- as.character(SCC.car$SCC)
codes <- SCC.car$SCC
NEI.Bmore <- NEI[NEI$fips == "24510",] #2096 observations
NEI.LA <- NEI[NEI$fips == "06037",] #9320 observations

#Get only those observations from Baltimore and LA with appropriate codes
NEI.Bmore.MV <- subset(NEI.Bmore, NEI.Bmore$SCC %in% codes) #1119 observations
NEI.LA.MV <- subset(NEI.LA, NEI.LA$SCC %in% codes) #980 observations

#Construct data frames for the total emissions grouped by year
result.Bmore <- aggregate(NEI.Bmore.MV$Emissions, by = list(NEI.Bmore.MV$year), FUN = sum)
result.LA <- aggregate(NEI.LA.MV$Emissions, by = list(NEI.LA.MV$year), FUN = sum)

#Rename columns for Baltimore then add an empty numeric column. This column will 
#hold a normalized value for total emssions, that is comparing emissions from motor vehicles
#to 1999 levels (eg 1999 = 1 then the next year shows the change from 1999). This is normalized
#to be able to compare between Baltimore and LA without worrying about scale
colnames(result.Bmore) <- c("Year", "Total")
result.Bmore$City <- paste(rep("BMORE", 4))
result.Bmore$Normal <- numeric(length = 4)
for (i in 1:length(result.Bmore$Normal)) {result.Bmore[i,4] <- result.Bmore[i,2]/result.Bmore[1,2]}

#Rename columns for LA then add an empty numeric column. This column will 
#hold a normalized value for total emssions, that is comparing emissions from motor vehicles
#to 1999 levels (eg 1999 = 1 then the next year shows the change from 1999). This is normalized
#to be able to compare between Baltimore and LA without worrying about scale
colnames(result.LA) <- c("Year", "Total")
result.LA$City <- paste(rep("LA", 4))
result.LA$Normal <- numeric(length = 4)
for (i in 1:length(result.LA$Normal)) {result.LA[i,4] <- result.LA[i,2]/result.LA[1,2]}

#combine data frames into final frame and coerce appropriate values
result <- rbind(result.Bmore, result.LA)
result$Year <- factor(result$Year)
result$Total <- round(result$Total, 2)
result$Normal <- round(result$Normal, 2)

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

#load gridExtra
if(require(gridExtra)) {
  library(gridExtra)
} else {
  install.packages("gridExtra")
  if (require(gridExtra)) {
    library(gridExtra)
  } else {
    stop("Could not load gridExtra")
  }
}

#Construct two plots and output to a png file. The two files allow one to do different comparisons: the first
#plot with absolute numbers shows comparisons while the second plot shows relative changes from 1999. 
#Please also note this plot is significantly larger than the previous plots to accomodate both subplots. 
#Note also there will be an error message "ymax not defined" this is not a problem
png(filename = "plot6.png", height = 900, width = 1500)

#This plot displays the absolute values of Emissions from Baltimore and LA with values added
myplot <- ggplot(result, aes(x = Year, y = Total, fill = City)) + 
  geom_bar(stat = "identity", position = position_dodge()) + 
  geom_text(aes(x = Year, y = round(Total), label = Total, vjust = -1), position = position_dodge(width = 0.9)) +
  ggtitle(expression("Total PM2.5 Emissions from Motor Vehicles 1999-2008")) +
  xlab(expression("Year")) + ylab(expression("Total PM2.5 from Motor Vehicles (tons)"))

#This plot shows normalized values, allowing a quick comparison without worrying about scale. Note the use of size
#in geom_line means that LA is much thicker, demonstrating it has much higher values. 
myplot2 <- ggplot(result, aes(x = Year, y = Normal, group = City, colour = City)) + 
  geom_line(aes(size = City)) + geom_point() +
  ggtitle(expression("PM2.5 Emissions Normalized using 1999 as base year")) +
  xlab(expression("Year")) + ylab(expression("Normalized PM2.5 relative to 1999"))

print(grid.arrange(myplot, myplot2, ncol = 2))
dev.off()