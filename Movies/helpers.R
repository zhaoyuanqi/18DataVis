library(shiny)
require(dplyr)
require(mosaic)
# Version: Scatter-plot 1.2.1 - ggvis (country data)
####################################################################
#                     HELPER FUNCTIONS
####################################################################

# Scale options: Gives operations for scaling the data 
# (ex. logarithmic vs. standard data)                    Title           Value        
scaleOptions <- c("Standard"    =   "none",
                  "Natural Log" =   "ln",
                  "Square Root" =   "sqrt",
                  "Square"      =   "square")

applyScale <- function(data, scale){
  # purpose: applies the given scale to data
  # Preconditions: data must be a numerical vector
  #   scale must match a function given in scaleOptions
  #   Preconditions are unverified, since the function is for internal
  #     use only.        
  # Postconditions: If scale is...
  #   none, data will be returned unchanged
  #   ln, the natural log of every value in data will be returned
  #   sqrt, the square root of every value will be returned
  #   square, the square of every value in data will be returned
  #   something else, data will be returned unchanged.
  
  #Generates errors when there are NAs in data
  newData = as.numeric(data)
  if(scale == "ln"){
    newData = log(newData + 1)
  } else if (scale == "sqrt") {
    newData = sqrt(newData)
  } else if (scale == "square"){
    newData = newData * newData
  }
  
  newData
}

cleanCor <- function(x, y){
  # Purpose: Takes vectors with NA values, removes those values, and 
  #   returns a correlation
  # Preconditions: x and y are the same length and contain mostly
  #   numeric values
  # Postconditions: returns the correlation coefficient between x
  #   and y, excluding any lines where either had a missing value or
  #   0 as a value.
  #   The returned value has 4 significant figures
  
  newData = data.frame(x, y)
  newData = newData[complete.cases(newData), ]
  signif(cor(newData[[1]], newData[[2]]), digits = 4)
}


cleanData <- function(data){
  # Purpose: removes all rows with NA and NaN in data.
  # Preconditions: data is a dataframe.
  # Postconditions: returns data with all of rows that contain
  #   NA, NaN.
  newData = data
  for (i in 1:ncol(newData)){
    newData = filter(newData, !is.nan(newData[[i]]))
    newData = filter(newData, !is.na(newData[[i]]))
  }
  newData
}

