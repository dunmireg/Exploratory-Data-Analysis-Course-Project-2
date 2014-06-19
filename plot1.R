NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

result <- aggregate(NEI$Emissions, by = list(NEI$year), FUN = sum)
myplot <- barplot(height = result$x, names.arg = result$Group.1, col = "light blue")

##need to add labels and title and line
