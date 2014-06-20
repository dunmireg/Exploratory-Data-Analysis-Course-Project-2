NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
sub <- NEI[NEI$fips == "24510",]
result <- aggregate(sub$Emissions, by = list(sub$year), FUN = sum)


myplot <- barplot(height = result$x, names.arg = result$Group.1, 
                  col = "light blue", xlab = "year", ylab = "Total Pm2.5 Emissions (ton)", 
                  main = "Total Emissions from all Sources in Baltimore City by Year")
lines(myplot, y = result$x, lwd = 2, col = "red")
