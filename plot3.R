NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

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


sub <- NEI[NEI$fips == "24510",]
result <- aggregate(Emissions ~ year + type, data = sub, FUN = sum)
myplot <- ggplot(result, aes(x = year, y = Emissions, fill = year)) + geom_bar(stat = "identity") + facet_wrap(~type)