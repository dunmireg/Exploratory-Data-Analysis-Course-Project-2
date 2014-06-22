NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
SCC$EI.Sector <- as.character(SCC$EI.Sector)
SCC.car <- SCC[grep("Mobile.*On-Road", SCC$EI.Sector),] #may want to follow up

SCC.car$SCC <- as.character(SCC.car$SCC)
codes <- SCC.car$SCC
NEI.Bmore <- NEI[NEI$fips == "24510",]
NEI.Bmore.MV <- subset(NEI.Bmore, NEI.Bmore$SCC %in% codes)

result <- aggregate(NEI.Bmore.MV$Emissions, by = list(NEI.Bmore.MV$year), FUN = sum)

colnames(result) <- c("Year", "Total")
result$Year <- factor(result$Year)

if(require(ggplot2)) {
  library(ggplot2)
} else {
  install.packages("ggplot2")
  if (require(ggplot2) {
    library(ggplot2)
  } else {
    stop("Could not load ggplot2")
  }
}

myplot <- ggplot(result, aes(x = Year, y = Total)) + 
  geom_bar(stat = "identity", aes(fill = result$Year)) + 
  guides(fill = FALSE) + theme(legend.position = "none") + 
  geom_text(aes(label = round(Total, 0), size = 1, hjust = 0.5, vjust = 2))