library(shiny)
require(dplyr)
#install_github("dtkaplan/DCFdevel");
require(DCFdevel)
# require(ggmap)
require(mosaic)
require(rworldmap)
require(RColorBrewer)

# Steps to clean up data and produce lim_world_data_new.csv from lim_world_data_new.csv
#CIAmilitary <-read.csv("lim_world_data.csv");
#CIAmilitary = mutate(CIAmilitary, totalmil = military*GDP/100);
#CIAmilitary = select(CIAmilitary, -military);
#CIAmilitary = mutate(CIAmilitary, lnmilitary = log(totalmil+1));
#CIAmilitary = mutate(CIAmilitary, militarypop = totalmil/(pop));
#CIAmilitary = mutate(CIAmilitary, milGDP = totalmil/(GDP));
#CIAmilitary = filter(CIAmilitary, country !="Kuwait");
#CIAmilitary = filter(CIAmilitary, totalmil !="NA");

# Mil Spend
CIAmilitary <-read.csv("/data/home/graphics2/Military_Spending_Basic/CIAmilitary_basic.csv")
CIAmilitary <- select(CIAmilitary, -X)
CIAmilitaryColNames <- c("Country", #1
                         "Population", #2
                         "GDP", #3
                         "Annual Military Spending", #4
                         "Log of Annual Military Spending", #5
                         "Military Spending per Capita", #6
                         "Military Spending to GDP") #7
colnames(CIAmilitary) <- CIAmilitaryColNames
CIAmilitary <- CIAmilitary[CIAmilitary$Country != "Kuwait",]

#names and data that will be displayed in tables organized from most to least
CIAmilitaryDisplayNames <- c("Country",
                             "Population (millions)",
                             "GDP ($millions)",
                             "Annual Military Spending ($millions)",
                             "Military Spending per Capita ($/person)",
                             "Military Spending Relative to GDP (%)")
displayData <- data.frame(CIAmilitary[[CIAmilitaryColNames[1]]],
                          CIAmilitary[[CIAmilitaryColNames[2]]] / 1000000,
                          CIAmilitary[[CIAmilitaryColNames[3]]] / 1000000,
                          CIAmilitary[[CIAmilitaryColNames[4]]] / 1000000,
                          CIAmilitary[[CIAmilitaryColNames[6]]] /100,
                          CIAmilitary[[CIAmilitaryColNames[7]]]
                          )

colnames(displayData) <- CIAmilitaryDisplayNames

# input$bins
# Define server logic required to draw a histogram
shinyServer(function(input, output, clientData, session) {

    
  output$distPlot <- renderPlot({
      
     print(input$Variables)


    if(input$radio == 1){
      #If the user chooses histogram, make a histrogram based on the type of
      # data selected
      currentPlot <- histogram(CIAmilitary[[input$Variables]],
                              main = paste(input$Variables,
                                           "for all Countries", sep=" "),
                              xlab = input$Variables, col="darkblue")

    } else if (input$radio == 2){
      #If the user chooses world map, make a world map based on the type of data
      # selected.

      #finds the approrpiate data for the color of the map
      currentData <- data.frame(Country = CIAmilitary[["Country"]],
                                 Data = CIAmilitary[[input$Variables]])



      #makes and colors the map
#       currentPlot <- makeWorldMap(currentData, "Country") +
#           geom_polygon(color = "darkblue") +
#           ggtitle(paste(input$Variables, "by Country", sep=" ")) +
#           geom_polygon(aes(fill=Data))

      currentPlot <- {
           map <- joinCountryData2Map(dF = currentData,
                                      joinCode = "NAME",
                                      nameJoinColumn = "Country") %>%
                mapCountryData("Data",
                               ylim = c(-55, 80),
                               catMethod = "fixedWidth",
                               colourPalette = brewer.pal(7, "YlGnBu"),
                               borderCol = "black",
                               missingCountryCol = "darkgrey",
                               oceanCol = "lightgrey",
                               mapTitle = paste(input$Variables, 
                                                "by Country"),
                               addLegend = FALSE)
           do.call( addMapLegend, c(map,
                                    legendWidth=0.5,
                                    legendMar = 4,
                                    horizontal = TRUE))
      }

    }


    currentPlot
  })



  output$viewOne <- renderTable({
    #sorts CIAmilitary by chosen variable
    displayData = arrange(displayData, CIAmilitary[[input$Variables]])
    displayData <- displayData[!is.na(displayData[[4]]),]
    head(displayData, n = input$obs)
  })

  output$viewTwo <- renderTable({
    #sorts CIAmilitary by chosen variable
    displayData = arrange(displayData, CIAmilitary[[input$Variables]])
    displayData <- displayData[!is.na(displayData[[4]]),]
    tail(displayData, n = input$obs)
  })

  output$viewOneTitle <- renderText({
      paste("Countries with Lowest", input$Variables)
  })

  output$viewTwoTitle <- renderText({
      paste("Countries with Highest", input$Variables)
  })
})
