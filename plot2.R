# This is plot2 for the Exploratory Data Analysis class offered by Johns Hopkins
# on Coursera. This graph answers if total emissions of PM2.5 have decreased
# in Baltimore City from 1999 to 2008. To construct the graph, this code
# requires the NEI and SCC data sets unzipped and loaded into the working directory
# (zip files can be found https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip).
# The code then outputs a png file into the working directory with the result.
# Note this uses the base plotting system

#read the files
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#get only values corresponding to Baltimore City, fips = 24510
sub <- NEI[NEI$fips == "24510",]

#get result data frame, which sums emissions grouped by year
result <- aggregate(sub$Emissions, by = list(sub$year), FUN = sum)

png(filename = "plot2.png")

#Produce plot with Year on x axis and total PM2.5 values on y axis. A line has been provided
#to show the "trend" although the totals are discrete values.
myplot <- barplot(height = result$x, names.arg = result$Group.1, 
                  col = "light blue", xlab = "Year", ylab = "Total Pm2.5 Emissions (tons)", 
                  main = "Total PM2.5 Emissions from all Sources in Baltimore City by Year")
lines(myplot, y = result$x, lwd = 2, col = "red")
text(myplot, result$x-1000, labels=round(result$x, 2))
dev.off()
