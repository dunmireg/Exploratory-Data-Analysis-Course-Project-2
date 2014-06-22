# This is plot3 for the Exploratory Data Analysis class offered by Johns Hopkins
# on Coursera. This graph answers of the four types of sources which have seen 
# decreases in Baltimore City from 1999 to 2008. To construct the graph, this code
# requires the NEI and SCC data sets unzipped and loaded into the working directory
# (zip files can be found https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip).
# The code then outputs a png file into the working directory with the result.
# Note this uses ggplot2

#read in files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#coerce type and year as factors
NEI$type <- as.factor(NEI$type)
NEI$year <- as.factor(NEI$year)

##install.packages("ggplot2")
if(require(ggplot2)) {
  library(ggplot2)
} else {
  install.packages("ggplot2")
  if(require(ggplot2)) {
    library(ggplot2)
  } else {
    stop("Could not load ggplot2")
  }
}

#grab only Baltimore City data
sub <- NEI[NEI$fips == "24510",]
#produce final data frame
result <- aggregate(Emissions ~ year + type, data = sub, FUN = sum)

#Create ggplot, note use of stat = identity in geom_bar to ensure y axis is actual value and not count. 
#Uses type as a facet to separate different types
png(filename = "plot3.png")
myplot <- ggplot(result, aes(x = year, y = Emissions, fill = year)) + geom_bar(stat = "identity") + facet_wrap(~type) +
  ggtitle(expression("Total PM2.5 Emissions in Baltimore by Type")) + ylab(expression("Emissions PM2.5 (tons)")) + 
  xlab(expression("Year"))
print(myplot)
dev.off()