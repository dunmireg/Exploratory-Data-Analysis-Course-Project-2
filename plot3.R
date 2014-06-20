NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

NEI$type <- as.factor(NEI$type)
install.packages("ggplot2")
library(ggplot2)
sub <- NEI[NEI$fips == "24510",]
qplot(year, Emissions, data = sub, facets = .~type)