# This is plot1 for the Exploratory Data Analysis class offered by Johns Hopkins
# on Coursera. This graph answers if total emissions of PM2.5 have decreased
# across the United States from 1999 to 2008. To construct the graph, this code
# requires the NEI and SCC data sets unzipped and loaded into the working directory
# (zip files can be found https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip).
# The code then outputs a png file into the working directory with the result.

#Read in data from working directory
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#produce data frame of results. This takes all emissions from the Emissions 
#column, groups them by year, and performs the sum function. 
result <- aggregate(NEI$Emissions, by = list(NEI$year), FUN = sum)

png(filename = "plot1.png")

#Constructs a bar plot graphing Year on the bottom and Total PM2.5 Emissions on the y axis. 
#I've included a line just to show the general "trend" although these are obviously discrete values for 
#total Emissions. I've also included the actual discrete values
myplot <- barplot(height = result$x, names.arg = result$Group.1, 
    col = "light blue", xlab = "Year", ylab = "Total Pm2.5 Emissions (ton)", 
    main = "Total Pm2.5 Emissions in United States by Year")
lines(myplot, y = result$x, lwd = 2, col = "red")
text(myplot, result$x-1500000, labels=round(result$x, 2))
dev.off()