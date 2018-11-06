library(shiny)
require(dplyr)
require(mosaic)
# Version: Scatter-plot 1.2.1 - ggvis (country data)
####################################################################
#                    DATA SELECTION
# If the data and titles are properly set in this section, the
#   rest of the program should automatically update to take the
#   changes into account.
####################################################################

# Import Data
Data <- read.csv("MoviesData.csv")
Data <- select(Data, -X)

# Assign names for the different data being used. The names should
# correspond to the columns in Data (the dataframe)
dataNames <- c("Name", #1
               "Gross Domestic Total Sales ($)", #2
               "Genre", #3
               "MPAA Rating", #4
               "Runtime (mins)", #5
               "Production Budget (US $ millions)", #6
               "Widest Release (# of theaters)", #7
               "In Release (# of days)", #8
               "Tomatometer Critic Review (%)", #9
               "Audience Score (%)", #10
               "Reviews Counted (# critic reviews)", #11
               "User Ratings (# of user reviews)" #12
               )
colnames(Data) <- dataNames

#Replaces all the 0s with NAs for this data
#for(i in 1:ncol(Data)){
#  Data[[i]] = replace(Data[[i]], Data[[i]]==0, NA)
#}

# Choose which columns will be accessible to the user of the app.
# The title of the option is what will be displayed in the app.
# The options will be displayed in the same order as they are in
# the list.

# Quantitative data options
quantDataOptions <- c("Gross Domestic Total Sales ($)" = dataNames[2],
                      "Runtime (mins)" = dataNames[5],
                      "Production Budget (US $ millions)" = dataNames[6],
                      "Widest Release (# of theaters)" = dataNames[7],
                      "In Release (# of days)" = dataNames[8],
                      "Tomatometer Critic Review (%)" = dataNames[9],
                      "Audience Score (%)"= dataNames[10],
                      "Reviews Counted (# critic reviews)"  = dataNames[11],
                      "User Ratings (# of user reviews)" = dataNames[12]
                      )

#Sets default variables
defaultXvar <- dataNames[9] #Tomatometer Critic Review
defaultYvar <- dataNames[10] #Audience Score

#Categorical data options
catDataOptions <- c("Genre" = dataNames[3],
                    "MPAA Rating" = dataNames[4]
                    )

#Gives an ID to each data point
DataPointID <- dataNames[1]


####################################################################
#                             UI SPECS
# Master controls for various graphic choices in the UI
####################################################################

# Colors

#Governs the color all titles
titleColor <- "color:darkred"

#Governs the colors of the menu selection titles
menuTitleColor <- "color:darkred"

#Governs the color the scatterplot
graphColor <- "black"

# Text

# Title for the app as a whole
appTitle <- "Visualizing 2014 Movie Data with Scatterplots"
