library(shiny)
require(dplyr)
library(ggvis)
source("helpers.R")
# Version: Scatter-plot 1.2.1 - ggvis (country data)
####################################################################
#                             UI DESIGN
# Code for creating the user interface
####################################################################

shinyUI(fluidPage(
 
  headerPanel(span(appTitle, style = titleColor)),

  # Sidebar with data setting options
  fluidRow(
    column(4,
      wellPanel(
           #Options for x axis data
           selectInput(inputId = "xAxis", (span("Choose data for x-axis:", style = menuTitleColor)),
                       choices = quantDataOptions, selected = defaultXvar),
           radioButtons("xScale", (span("Choose a scale x-axis data:", style = menuTitleColor)),
                        choices = scaleOptions, selected = "none", inline = TRUE),
           
           #Options for y axis data
           selectInput(inputId = "yAxis", (span("Choose data for y-axis:", style = menuTitleColor)),
                       choices = quantDataOptions, selected = defaultYvar),
           radioButtons("yScale", (span("Choose a scale y-axis data:", style = menuTitleColor)),
                        choices = scaleOptions, selected = "none", inline = TRUE),
           
           #Options for coloring the data points
           radioButtons(inputId="useColor", (span("Type of data use to color points:", style = menuTitleColor)),
                        choices = c("None" = "none", 
                                    "Quantitative Data" = "quant", 
                                    "Categorical Data" = "cat"), selected = "none"),
                   
           conditionalPanel("input.useColor=='quant'",
                            selectInput(inputId = "quantPointColor", (span("Choose data to color the points:", 
                                                                           style = menuTitleColor)),
                                        choices = quantDataOptions, selected = "none"),
                            radioButtons("colorScale", (span("Choose a scale point color data:", 
                                                             style = menuTitleColor)),
                                         choices = scaleOptions, selected = "none", inline = TRUE)
           ),
           
           conditionalPanel("input.useColor=='cat'",
                            selectInput(inputId = "catPointColor", (span("Choose data to color the points:", 
                                                                         style = menuTitleColor)),
                                        choices = catDataOptions, selected = "none")
           ),
           
           #Options for fitted line and correlation coefficient
           radioButtons("fittedLine", (span("Fitted line?", style = menuTitleColor)),
                        choices = c("Yes" = TRUE, "No" = FALSE), selected = FALSE, inline = TRUE),
           conditionalPanel("input.fittedLine",
                            p(textOutput("corCoefOut"), align = "center")
           ),
           
           p("Additional resources for instructors:", align = "center"),
           a("Stats2Labs",
             href="http://web.grinnell.edu/individuals/kuipers/stat2labs/MilitarySpending.html", 
             align="center")
      )  
    ),
  
  #Displays graphs
    column(8,
      ggvisOutput("plot1"),
      span("Number of data points:",
                     textOutput("numDataPoints"))
    )
  )
  
))