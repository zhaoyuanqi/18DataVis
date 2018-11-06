### This code is created by Dennis Lui under the supervision of Shonda Kuiper
### Fall 2017

#library(shiny)
#library(ggplot2)
#library(plyr)
#library(tree)


library(shiny)
if(!("ggplot2") %in% installed.packages()){install.packages("ggplot2")}
library(ggplot2)
if(!("plyr") %in% installed.packages()){install.packages("plyr")}
library(plyr)
if(!("tree") %in% installed.packages()){install.packages("tree")}
library(tree)


data <- iris

var <- c("Sepal Length" = "Sepal.Length",
         "Sepal Width" = "Sepal.Width",
         "Petal Length"= "Petal.Length",
         "Petal Width"= "Petal.Width")


dataset <-c("Iris1" = "iris1",
            "Iris2" = "iris2",
            "Turtles" = "turtles")

turtles <- read.table(file = "http://www.public.iastate.edu/~maitra/stat501/datasets/turtles.dat", 
                      col.names = c("gender", "carapace length",  "carapace width", "carapace height"))

turtles$sex <- ifelse(turtles$gender==1,"Female", "Male")