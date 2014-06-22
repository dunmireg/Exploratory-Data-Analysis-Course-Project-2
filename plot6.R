NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
SCC$EI.Sector <- as.character(SCC$EI.Sector)
SCC.car <- SCC[grep("Mobile.*On-Road", SCC$EI.Sector),] #may want to follow up

SCC.car$SCC <- as.character(SCC.car$SCC)
codes <- SCC.car$SCC
NEI.Bmore <- NEI[NEI$fips == "24510",]
NEI.LA <- NEI[NEI$fips == "06037",]

NEI.Bmore.MV <- subset(NEI.Bmore, NEI.Bmore$SCC %in% codes)
NEI.LA.MV <- subset(NEI.LA, NEI.LA$SCC %in% codes)

result.Bmore <- aggregate(NEI.Bmore.MV$Emissions, by = list(NEI.Bmore.MV$year), FUN = sum)
result.LA <- aggregate(NEI.LA.MV$Emissions, by = list(NEI.LA.MV$year), FUN = sum)

colnames(result.Bmore) <- c("Year", "Total")
result.Bmore$City <- paste(rep("BA", 4))


colnames(result.LA) <- c("Year", "Total")
result.LA$City <- paste(rep("LA", 4))

result <- rbind(result.Bmore, result.LA)
result$Year <- factor(result$Year)
result$Total <- round(result$Total, 2)
library(ggplot2)

myplot <- ggplot(result, aes(x = Year, y = Total, fill = City)) + 
  geom_bar(stat = "identity", position = position_dodge()) + 
  geom_text(aes(x = Year, y = round(Total), label = Total, vjust = -1), position = position_dodge(width = 0.9))