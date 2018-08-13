library(dplyr)
library(ggplot2)

SCC <- readRDS("C:/Users/Rohan Bali/Desktop/Source_Classification_Code.rds")
NEI <- readRDS("C:/Users/Rohan Bali/Desktop/summarySCC_PM25.rds")
options(scipen=999)
 #Question 1
total_PM25_emission <- aggregate(Emissions~year,data = NEI, sum)
barplot(total_PM25_emission$Emissions,xlab="Year",
        ylab="PM2.5 Emissions",
        main="Total PM2.5 Emissions From All US Sources")
#Question 2
Baltimore_City <- subset(NEI, fips == '24510')
totalBalCity_Emission <- aggregate(Emissions~year, data = Baltimore_City, sum)
totalBalCity_Emission
barplot(totalBalCity_Emission$Emissions,xlab="Year", ylab="PM2.5 Emissions", main = "Total PM2.5 Emission From Baltimore_city")
#Question 3
ggplot(aes(x = year, y = Emissions, fill=type), data=Baltimore_City)+geom_bar(stat="identity")+
  facet_grid(.~type)+
  labs(x="year", y=("Total PM2.5 Emission")) + 
  labs(title=expression("PM2.5 Emissions, Baltimore_City"))+
  guides(fill=FALSE)
#Question 4
Combustion_SCC <- grep("comb",SCC$SCC.Level.One,ignore.case = TRUE)
Coal_SCC <- grep("coal",SCC$SCC.Level.Four, ignore.case = TRUE)
Coal_Combustion <- (Combustion_SCC & Coal_SCC)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]
ggplot(combustionNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity") +
 labs(x="year", y=expression("Total PM 2.5 Emission ")) + 
  labs(title=expression("PM2.5 Coal Combustion Source Emissions Across US from 1999-2008"))
#Question 5
motor_vehicle <- grep("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE)
SCC_vehicle <- SCC[motor_vehicle,]$SCC
NEI_vehicle <- NEI[NEI$SCC %in% SCC_vehicle, ]
Baltimore_Vehicles <- NEI_vehicle[NEI_vehicle$fips==24510,]
ggplot(Baltimore_Vehicles, aes(factor(year), Emissions)) + geom_bar(stat = "identity") + xlab("Year") + ylab("Emissions") + 
  labs(title=expression("PM2.5 Motor Vehicle Source Emissions in Baltimore from 1999-2008"))
#Question 6
Baltimore_Vehicles$city <- "Baltimore_City"
LA_Vehcicles <- NEI_vehicle[NEI_vehicle=="06037",]
LA_Vehcicles$city <- "LA_city"
LA_Baltimore <- rbind(Baltimore_Vehicles,LA_Vehcicles)
ggplot(LA_Baltimore,aes(x=factor(year), y= Emissions, fill = city)) + geom_bar(aes(year),stat = 'identity') +
  facet_grid(scales="free", space="free", .~city) + guides(fill=FALSE) + theme_bw() + labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM2.5 Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

