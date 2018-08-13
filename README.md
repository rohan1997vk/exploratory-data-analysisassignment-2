# exploratory-data-analysisassignment-2

Assignment
The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

Making and Submitting Plots
For each plot you should

Construct the plot and save it to a PNG file.
Create a separate R code file (plot1.R, plot2.R, etc.) that constructs the corresponding plot, i.e. code in plot1.R constructs the plot1.png plot. Your code file should include code for reading the data so that the plot can be fully reproduced. You should also include the code that creates the PNG file. Only include the code for a single plot (i.e. plot1.R should only include code for producing plot1.png)
Upload the PNG file on the Assignment submission page
Copy and paste the R code from the corresponding R file into the text box at the appropriate point in the peer assessment.
In preparation we first ensure the data sets archive is downloaded and extracted.

We now load the NEI and SCC data frames from the .rds files.


library(dplyr)
library(ggplot2)

SCC <- readRDS("C:/Users/Rohan Bali/Desktop/Source_Classification_Code.rds")
NEI <- readRDS("C:/Users/Rohan Bali/Desktop/summarySCC_PM25.rds")
options(scipen=999)

Question 1
First we'll aggregate the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.

#Question 1
total_PM25_emission <- aggregate(Emissions~year,data = NEI, sum)
barplot(total_PM25_emission$Emissions,xlab="Year",
        ylab="PM2.5 Emissions",
        main="Total PM2.5 Emissions From All US Sources")
        
        
        
        Question 2
First we aggregate total emissions from PM2.5 for Baltimore City, Maryland (fips="24510") from 1999 to 2008.


#Question 2
Baltimore_City <- subset(NEI, fips == '24510')
totalBalCity_Emission <- aggregate(Emissions~year, data = Baltimore_City, sum)
totalBalCity_Emission
barplot(totalBalCity_Emission$Emissions,xlab="Year", ylab="PM2.5 Emissions", main = "Total PM2.5 Emission From Baltimore_city")


Question 3
Using the ggplot2 plotting system,

#Question 3
ggplot(aes(x = year, y = Emissions, fill=type), data=Baltimore_City)+geom_bar(stat="identity")+
  facet_grid(.~type)+
  labs(x="year", y=("Total PM2.5 Emission")) + 
  labs(title=expression("PM2.5 Emissions, Baltimore_City"))+
  guides(fill=FALSE)

Question 4
First we subset coal combustion source factors NEI data.

Combustion_SCC <- grep("comb",SCC$SCC.Level.One,ignore.case = TRUE)
Coal_SCC <- grep("coal",SCC$SCC.Level.Four, ignore.case = TRUE)
Coal_Combustion <- (Combustion_SCC & Coal_SCC)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]
ggplot(combustionNEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity") +
 labs(x="year", y=expression("Total PM 2.5 Emission ")) + 
  labs(title=expression("PM2.5 Coal Combustion Source Emissions Across US from 1999-2008"))
  
  Question 5
First we subset the motor vehicles, which we assume is anything like Motor Vehicle in SCC.Level.Two.


#Question 5
motor_vehicle <- grep("vehicle", SCC$SCC.Level.Two, ignore.case = TRUE)
SCC_vehicle <- SCC[motor_vehicle,]$SCC
NEI_vehicle <- NEI[NEI$SCC %in% SCC_vehicle, ]
Baltimore_Vehicles <- NEI_vehicle[NEI_vehicle$fips==24510,]
ggplot(Baltimore_Vehicles, aes(factor(year), Emissions)) + geom_bar(stat = "identity") + xlab("Year") + ylab("Emissions") + 
  labs(title=expression("PM2.5 Motor Vehicle Source Emissions in Baltimore from 1999-2008"))
  
  
  Question 6
Comparing emissions from motor vehicle sources in Baltimore City (fips == "24510") with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"),
Baltimore_Vehicles$city <- "Baltimore_City"
LA_Vehcicles <- NEI_vehicle[NEI_vehicle=="06037",]
LA_Vehcicles$city <- "LA_city"
LA_Baltimore <- rbind(Baltimore_Vehicles,LA_Vehcicles)
ggplot(LA_Baltimore,aes(x=factor(year), y= Emissions, fill = city)) + geom_bar(aes(year),stat = 'identity') +
  facet_grid(scales="free", space="free", .~city) + guides(fill=FALSE) + theme_bw() + labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM2.5 Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))








