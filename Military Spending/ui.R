library(shiny)
# Mil Spend
# Define UI for application that plots random distributions 

#names copied from server.R
CIAmilitaryColNames <- c(" ","Country","Population","GDP",
                         "Annual Military Spending",
                         "Log of Annual Military Spending",
                         "Military Spending per Capita",
                         "Military Spending to GDP")

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel(span("Visualizing Military Spending by Country", style = "color:darkblue")),
  
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    
    radioButtons("radio", (span("Choose a type of graph:", style = "color:darkblue")),
                 choices = list("Histogram" = 1, "Spatial Map" = 2
                 ),selected = 1),
    
    selectInput(inputId = "Variables", (span("Choose variables and data display:", style = "color:darkblue")),
                choices = c("Military Spending ($)" = CIAmilitaryColNames[5],
                            "Log of Military Spending ($)" = CIAmilitaryColNames[6],
                            "Population (people)" = CIAmilitaryColNames[3],
                            "GDP ($)" = CIAmilitaryColNames[4],
                            "Military Spending per Capita ($/person)" = CIAmilitaryColNames[7],
                            "Military Spending/GDP ($/$)" = CIAmilitaryColNames[8])),
    p("Select the Number of Observations to see more or less rows of data
      within the tables.",align = "center"),
    numericInput("obs", (span("Number of observations to view:", style = "color:darkblue")), 3, min=1),
    p("Additional resources for instructors:", align = "center"),
    a("Stats2Labs",
      href="http://web.grinnell.edu/individuals/kuipers/stat2labs/MilitarySpending.html", 
      align="center")

  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    plotOutput("distPlot"),
    h3(textOutput("viewOneTitle")),
    tableOutput("viewOne"),
    h3(textOutput("viewTwoTitle")),
    tableOutput("viewTwo")
  )
))