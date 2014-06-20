NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

result <- aggregate(NEI$Emissions, by = list(NEI$year), FUN = sum)
myplot <- barplot(height = result$x, names.arg = result$Group.1, 
    col = "light blue", xlab = "year", ylab = "Total Pm2.5 Emissions (ton)", 
    main = "Total Emissions from all Sources by Year")
lines(myplot, y = result$x, lwd = 2, col = "red")


