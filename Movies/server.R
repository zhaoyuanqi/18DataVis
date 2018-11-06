library(shiny)
require(dplyr)
require(mosaic)
library(ggvis)
if (FALSE) library(RSQLite)
source("helpers.R")
# Version: Scatter-plot 1.2.1 - ggvis (country data)

####################################################################
#               DATA PROCESSING AND OUTPUT
# Uses the data and user input to output the correct graphics.
####################################################################

# input$bins
# Define server logic 
shinyServer(function(input, output, clientData, session) {
  
  observe({
    xAxis_options <- quantDataOptions[quantDataOptions != input$yAxis]
    updateSelectInput(session, "xAxis", choices=xAxis_options, 
                      selected = input$xAxis)
    
    yAxis_options <- quantDataOptions[quantDataOptions != input$xAxis]
    updateSelectInput(session, "yAxis", choices=yAxis_options, 
                      selected = input$yAxis)
  })
  
  #Creates a dataframe based on the options the user selected
  filteredData <- reactive({
    #Puts together x variable, y variable data
    ID = Data[[DataPointID]]
    xData = Data[[input$xAxis]] %>% applyScale(input$xScale)
    yData = Data[[input$yAxis]] %>% applyScale(input$yScale)
    tempData = data.frame(ID, xData, yData)
    
    #adds color data if applicable
    if(input$useColor == "quant"){
        tempData$colorData <- Data[[input$quantPointColor]] %>% 
            applyScale(input$colorScale)
    } else if (input$useColor == "cat") {
        tempData$colorData <- Data[[input$catPointColor]]
    } 

    
    cleanData(tempData)
  })
  
  #Function for showing country-year, x, and y information when hovering over 
  #data points
  make_data_tooltip <- reactive({
      data_tooltip <- function(point) {
          e <- 2.71828
          
          # Purpose: Generates tooltip text
          if (is.null(point)) return(NULL)
          if (is.null(point$ID)) return(NULL)
          
          #Adjusts for logs in displaying the X and Y values of the points
          Xval <- switch(input$xScale,
                         "ln"= round(e ^ point$xData - 1),
                         "sqrt"= point$xData * point$xData,
                         "square" = sqrt(point$xData),
                         point$xData)
          Yval <- switch(input$yScale,
                         "ln"= round(e ^ point$yData - 1),
                         "sqrt"= point$yData * point$yData,
                         "square" = sqrt(point$yData),
                         point$yData)
          
          message <- paste0("<b>", point$ID, "</b><br>",
                            input$xAxis, "=", Xval, "<br>",
                            input$yAxis, "=", Yval)
          
          message
      }
      data_tooltip
  })
  
  #A reactive expression with the ggvis plot
  vis <- reactive({
    currentData <- filteredData()

    #Prepares the title for the graph
    graphTitle = paste(input$yAxis, input$xAxis, sep=" by ")
    
    if(input$useColor != "none"){
      if(input$useColor == "quant"){
        colorDataName = input$quantPointColor
      } else if (input$useColor == "cat") {
        colorDataName = input$catPointColor
      } 
      graphTitle <- paste(graphTitle, "with", colorDataName, "for color")
    }
    
    currentVis <- currentData %>% 
      ggvis(x = ~xData, y = ~yData) %>%
      #UPDATE NEEDED:  Compact this code and the code in the color option
      layer_points(fill := graphColor, size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   stroke:= graphColor, key := ~ID) %>%
      #Sets titles for axes
      add_axis("x", title = input$xAxis) %>%
      add_axis("y", title = input$yAxis) %>%     
      #Starts the scales for the axes at 0 - Removed
      #scale_numeric("x", domain = c(0, 1.05 * max(currentData$xData))) %>%
      #scale_numeric("y", domain = c(0, 1.05 * max(currentData$yData))) %>%
      #Calls the function that displays text when hovering over a point
      #See helpers.R for actual function
      add_tooltip(make_data_tooltip(), "hover") %>%
      #UPDATE NEEDED: Adjust the plot to adapt to the screen size
      set_options(width = 400, height = 400) 
    
    #Option: Add color data
    if(input$useColor != "none"){
      currentVis <- currentVis %>% 
        layer_points(fill = ~colorData, size := 50, size.hover := 200,
                     fillOpacity := 0.7, fillOpacity.hover := 0.5,
                     stroke = ~colorData, key := ~ID) %>%
          add_legend("fill", title=colorDataName) %>%
          add_legend("stroke", title=colorDataName) 
    }
    
    #Option: Add fitted line
    if(input$fittedLine){
      currentVis <- currentVis %>% 
          layer_model_predictions(model = "lm", se = TRUE)
    }
   
    currentVis
  })
 
  #Plots the visualization
  bind_shiny(vis, "plot1")

  output$corCoefOut <- renderText({
    if(input$fittedLine){
      corCoef <- toString(cleanCor(applyScale(Data[[input$xAxis]], input$xScale),
               applyScale(Data[[input$yAxis]], input$yScale)))
      paste("r = ", corCoef)
    }
  })
  
   output$numDataPoints <- renderText ({
    currentData <- filteredData()    
    toString(length(currentData[[1]]))
  })
})





