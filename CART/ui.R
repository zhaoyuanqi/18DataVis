#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

convertMenuItem <- function(out,tabName) {
  out$children[[1]]$attribs['data-toggle']="tab"
  out$children[[1]]$attribs['data-value'] = tabName
  out
}

dashboardPage(
  dashboardHeader(title = "Classification Tree!"),
  dashboardSidebar(
    sidebarMenu(
      convertMenuItem(menuItem("Try yourself",tabName = "yourself",icon=icon("dashboard"),
                               selectInput("dataset","choose a dataset",dataset),
                               hr(),
                               sliderInput("xslider","X Slider",min=0,max=5,value=2),
                               checkboxInput("left","Left Slider",value = FALSE),
                               sliderInput("ysliderleft","Y Slider",min=0,max=5,value=2),
                               checkboxInput("right","Right Slider",value=FALSE),
                               sliderInput("ysliderright","Y slider",min=0,max=5,value=2),
                               checkboxInput("display","Display Optimized Tree?",value=FALSE)),tabName="yourself"),
      convertMenuItem(menuItem("Optimized Tree",tabName = "optimized",icon=icon("bar-chart-o")),tabName = "optimized")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "yourself",
              column(width=12,
                     box(width=NULL,
                         status="primary",
                         title="Play around",
                         olidHeader = TRUE,
                         collapsible = TRUE,
                         plotOutput("distPlot", height = 300),
                         height = 350),
                     box(width=NULL,
                         status="primary",
                         title="Accuracy",
                         olidHeader = TRUE,
                         collapsible = TRUE,
                         verbatimTextOutput("accuracy"),
                         height = 100),
                     box(width=NULL,
                         status="primary",
                         title="Optimized Tree",
                         olidHeader = TRUE,
                         collapsible = TRUE,
                         plotOutput("sample", height = 200 ),
                         height = 250))),
      tabItem(tabName = "optimized",
              box(width=NULL,
                  status="primary",
                  title="Play around",
                  olidHeader = TRUE,
                  collapsible = TRUE,
                  plotOutput("sampleTree", height = 280 ),
                  height = 350)
              
      )
    )
  )
)


