data <- read.csv("2006-cleaned.csv")
census2010 <- read.csv("NYC_Blocks_2010CensusData_Plus_Precincts.csv")
if(!exists("precincts")) precincts <- readShapeSpatial("nypp_2013/OGRGeoJSON.shp")
data_arrests<- data[data$arstmade=="Y",]

#    Total dataset ----
existingPrecincts <- unique(data$pct)

incidentData <- data.frame("Precinct"=existingPrecincts,
                           "Area"=rep(NA,76), 
                           "Population"=rep(NA,76), 
                           "Total"=rep(NA, 76), 
                           "byArea"=rep(NA,76), 
                           "byPop"=rep(NA,76))
inc <- c()
for(i in 1:76){ 
     inc[i] <- length(data_arrests$adrpct[data_arrests$adrpct==existingPrecincts[i]])
}
incidentData$Total <- inc
incidentData$Area <- precincts$Shape_Area/29085296
incidentData$byArea <- incidentData$Total/incidentData$Area


pop <- c()
for(i in 1:76){
     pop[i] <- sum(census2010$P0010001[census2010$precinct==existingPrecincts[i]], na.rm = T)
     
}
incidentData$Population <- pop
incidentData$byPop <- incidentData$Total/incidentData$Population

# -----

#    aggregate number of arrests
arrested_race <- as.data.frame(table(data_arrests$pct, data_arrests[,"race"]))
names(arrested_race)[1] <- "Precinct"
names(arrested_race)[2] <- "Race"

arr_race <- data.frame("Precinct" = existingPrecincts,
                       "W"=rep(NA, 76), 
                       "B"=rep(NA, 76),
                       "I"=rep(NA, 76),
                       "A"=rep(NA, 76),
                       "Q"=rep(NA, 76),
                       "P"=rep(NA, 76)
                         )
     for(precinct in 1:76){
          for(race in c("W","B","I","A","Q","P")){
               arr_race[precinct, race] <- sum(arrested_race$Freq[arrested_race$Precinct==existingPrecincts[precinct] & arrested_race$Race==race])
          }
     }
arr_race <- cbind(arr_race, "HispA" = arr_race$Q + arr_race$P)
names(arr_race)[2] <- "WhiteA"
names(arr_race)[3] <- "BlackA"
names(arr_race)[4] <- "NativeA"
names(arr_race)[5] <- "AsPacA"
arr_race$Q<- NULL
arr_race$P<- NULL

pop_race <- data.frame("Precinct" = existingPrecincts,
                       "P0020005"=rep(NA, 76), 
                       "P0020006"=rep(NA, 76),
                       "P0020007"=rep(NA, 76),
                       "P0020008"=rep(NA, 76),
                       "P0020009"=rep(NA, 76),
                       "P0020002"=rep(NA, 76)
                       )
     for(precinct in 1:76){
          for(race in c("P0020005", "P0020006", "P0020007", "P0020008", "P0020009", "P0020002")) 
          pop_race[precinct,race] <- sum(census2010[census2010$precinct==existingPrecincts[precinct], race], na.rm = T)
     }
names(pop_race)[2] <- "White"
names(pop_race)[3] <- "Black"
names(pop_race)[4] <- "Native"
names(pop_race)[5] <- "Asian"
names(pop_race)[6] <- "Pacific"
names(pop_race)[7] <- "Hispanic"
pop_race <- cbind(pop_race, "AsPac" = pop_race$Asian + pop_race$Pacific)
pop_race <- cbind(pop_race, "Hisp" = pop_race$Hispanic)
pop_race$Asian <- NULL
pop_race$Pacific <- NULL
pop_race$Hispanic <- NULL



incidentData <- merge(incidentData, pop_race)
incidentData <- merge(incidentData, arr_race)

#Removes unnecessary objects to free up memory
rm(pop_race, arr_race,i,inc,pop,race, precinct, arrested_race, census2010, data, data_arrests, existingPrecincts)

precincts_cprm <- precincts[precincts$Precinct!=22,]
incidentData_cprm <- incidentData[incidentData$Precinct!=22,]
