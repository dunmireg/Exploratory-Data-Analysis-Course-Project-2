NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
SCC$EI.Sector <- as.character(SCC$EI.Sector)
SCC$Short.Name <- as.character(SCC$Short.Name)

SCC.comb <- SCC[grep("Fuel Comb", SCC$EI.Sector),]
SCC.coal <- SCC.comb[grep("Coal", SCC.comb$Short.Name),]
SCC.coal2 <- SCC[grep("Coal", SCC$EI.Sector),]
res <- rbind(SCC.coal, SCC.coal2)
res <- unique(res)

res$SCC <- as.character(res$SCC)
codes <- res$SCC
sub <- subset(NEI, NEI$SCC %in% codes)
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

myplot <- ggplot(result, aes(x = Year, y = Total)) + 
  geom_bar(stat = "identity", aes(fill = result$Year)) + 
  guides(fill = FALSE) + theme(legend.position = "none") + 
  geom_text(aes(label = round(Total, 0), size = 1, hjust = 0.5, vjust = 2))