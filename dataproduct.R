url<-"http://www.dof.ca.gov/research/demographic/state_census_data_center/historical_census_1850-2010/documents/2010-1850_STCO_IncCities-FINAL.xls"
download.file(url, "CApopulation.xls", mode="wb")

library(xlsx)
library(reshape2)

capopulRaw<-read.xlsx2("CApopulation.xls", sheetName="1850-2010")

#Tidy the dataset by removing unrelavant rows and remove repeated columns.
#Only row 2:613 consist the data that is interesint.
#Column 3 consist the Incorporation date, which is not in our interest.

capopulo<-capopulRaw[2:613,-3] 

#Store the dates for concensors in to a vector.
condates<-as.vector(as.matrix((capopulo[1, c(3:19)])))
condates<-gsub("\n","",condates)
condates<-gsub("\\.","",condates)
condates<-as.Date(condates, "%b %d, %Y")
condates_char<-as.character(condates)

colnames(capopulo)<-c("County","City", condates_char)
capopucln<-capopulo[-1,]

#Getting rid of the Empty rows
emptyRows<-(rowSums(capopucln=="")==ncol(capopucln))
capopucln1<- capopucln[!emptyRows,]

#Replacing the City without specific entries with (All Area)
capopucln1$City<-ifelse(capopucln1$City=="", "(All Area)", as.character(capopucln1$City))

capopMelt<-melt(capopucln1, id=c("County","City"), measure.vars=condates_char)
head(capopMelt, n=100)

countydata<-capopMelt[grepl("Los Angeles", capopMelt$County),]
plotdata<-countydata[grepl("(All Area)", countydata$City),]

plotdata$value<-ifelse(plotdata$value=="n/a", "", plotdata$value)
plotdata$variable<-as.Date(plotdata$variable)
plot(plotdata$value~plotdata$variable, type="b", xlab="date", ylab="population", main=paste(plotdata$County[1], plotdata$City[1]," "), col="blue")

popNum<-as.numeric(plotdata$value)
popDate<-as.numeric(as.Date(plotdata$variable))[!is.na(popNum)]
popNumValid<-popNum[!is.na(popNum)]
fit<-lm(popNumValid~log(popDate/100000+1))

newDate<-as.numeric(as.Date("2013-05-23"))
newPop<-round(log(newDate/100000+1)*coef(fit)[[2]]+coef(fit)[[1]],digit=0)
corPop<-ifelse(newPop<0, 0, newPop)

