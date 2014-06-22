# This is plot4 for the Exploratory Data Analysis class offered by Johns Hopkins
# on Coursera. This graph answers how emissions from coal combustion
# related sources have changed across the United States. To construct the graph, this code
# requires the NEI and SCC data sets unzipped and loaded into the working directory
# (zip files can be found https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip).
# The code then outputs a png file into the working directory with the result.

#read data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

#make appropriate columns characters
SCC$EI.Sector <- as.character(SCC$EI.Sector)
SCC$Short.Name <- as.character(SCC$Short.Name)

#grep based on "Fuel Comb" and "Coal" to get values and then combine them (removing duplicates) to
#produce one final data frame. There are many different opinions on what to consider coal combustion sources, 
#I chose to be as inclusive as possible by filtering all sources of combustion and coal. This will include some 
#sources such as coal syngas and liquified coal that others may not include. This will
# also include 2 entries of lignite under Short.Name but no mention of "coal" under
# EI.Sector (lignite is brown coal). Note the trend does not change depending
#on how you filter for coal combustion. 
SCC.comb <- SCC[grep("Fuel Comb", SCC$EI.Sector),] #530 observations
SCC.coal <- SCC.comb[grep("Coal", SCC.comb$Short.Name),] #91 observations
SCC.coal2 <- SCC[grep("Coal", SCC$EI.Sector),] #99 observations
res <- rbind(SCC.coal, SCC.coal2)
res <- unique(res) ##103 observations

#use the SCC values obtained above to get the NEI data that are from coal combustion sources
res$SCC <- as.character(res$SCC)
codes <- res$SCC
sub <- subset(NEI, NEI$SCC %in% codes)

#produce final data frame summing emissions and grouping by year
result <- aggregate(sub$Emissions, by = list(sub$year), FUN = sum)
colnames(result) <- c("Year", "Total")
result$Year <- factor(result$Year)

if(require(ggplot2)) {
  library(ggplot2)
} else {
  install.packages("ggplot2")
  if(require(ggplot2)) {
    library(ggplot2)
  } else {
    stop("could not load ggplot2")
  }
    
}

#construct barplot using ggplot. Note the use of stat = identity and filling results by year.
#I've also included the actual values as a geom_text variable to make things easier to see.
png(filename = "plot4.png")
myplot <- ggplot(result, aes(x = Year, y = Total)) + 
  geom_bar(stat = "identity", aes(fill = Year)) + 
  geom_text(aes(label = round(Total, 2), hjust = 0.5, vjust = 2)) +
  ggtitle(expression("Emissions from Coal Combustion Sources in US from 1999 to 2008")) +
  xlab(expression("Year")) + ylab(expression("PM2.5 Emissions from Coal Combustion (tons)"))
print(myplot)
dev.off()