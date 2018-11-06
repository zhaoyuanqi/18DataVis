#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
  treedata <- reactive({
    if (input$dataset == "iris1"){
      Pedal.Length <- iris$Petal.Length
      Pedal.Width <- iris$Petal.Width
      response <- iris$Species
      ret <- cbind.data.frame(Pedal.Length, Pedal.Width, response)
    } else if (input$dataset == "iris2") {
      Sepal.Length <- iris$Sepal.Length
      Sepal.Width <- iris$Sepal.Width
      response <- iris$Species
      ret <- cbind.data.frame(Sepal.Length,Sepal.Width, response)
    } else if (input$dataset == "turtles"){
      Carapace.Length <- turtles$carapace.length
      Carapace.Width <- turtles$carapace.width
      response <- turtles$sex
      ret <- cbind.data.frame(Carapace.Length, Carapace.Width, response)
    }
    ret
  })
  
  treeName <- reactive({
    
    if (input$dataset == "iris1"){
      obj1.name <- "Pedal.Length"
      obj2.name <- "Pedal.Wdith"
    } else if (input$dataset == "iris2"){
      obj1.name <- "Sepal.Length"
      obj2.name <- "Sepal.Width"
    } else if (input$dataset =="turtles"){
      obj1.name <- "Carapace.Length"
      obj2.name <- "Carapace.Width"
    }
    c(obj1.name, obj2.name)
  })
  
  minmax <- reactive({
    c(min(treedata()[,1]),
      max(treedata()[,1]),
      min(treedata()[,2]),
      max(treedata()[,2])
    )
  })
  observe({
    updateSliderInput(session, "xslider", value = minmax()[1],
                      min = minmax()[1], max = minmax()[2], step = 0.1)
    updateSliderInput(session, "ysliderleft", value = minmax()[3],
                      min = minmax()[3], max = minmax()[4], step = 0.1)
    updateSliderInput(session, "ysliderright", value = minmax()[3],
                      min = minmax()[3], max = minmax()[4], step = 0.1)
  })
  
  output$accuracy <- renderText({
    # area 1: x <= xslider & y >= ysliderleft
    subset1 <- treedata()[(treedata()[,1] <= input$xslider) & (treedata()[,2] >= input$ysliderleft), ]
    data.frame1 = count(subset1, "response")
    max.freq1 = max(data.frame1$freq, na.rm = TRUE)
    # species type in area 1
    type1 = as.character(data.frame1$response[data.frame1$freq == max.freq1])
    predict = ifelse((treedata()[,1] <= input$xslider) & (treedata()[,2] >= input$ysliderleft), type1, "0")
    
    # area 2: x <= xslider & y < ysliderleft
    subset2 <- treedata()[(treedata()[,1] <= input$xslider) & (treedata()[,2] < input$ysliderleft), ]
    data.frame2 = count(subset2, "response")
    max.freq2 = max(data.frame2$freq, na.rm = TRUE)
    # species type in area 2
    type2 = as.character(data.frame2$response[data.frame2$freq == max.freq2])
    predict = ifelse((treedata()[,1] <= input$xslider) & (treedata()[,2] < input$ysliderleft), type2, predict)
    
    # area 3: x > xslider & y >= ysliderright
    subset3 <- treedata()[(treedata()[,1] > input$xslider) & (treedata()[,2] >= input$ysliderright), ]
    data.frame3 = count(subset3, "response")
    max.freq3 = max(data.frame3$freq, na.rm = TRUE)
    # species type in area 3
    type3 = as.character(data.frame3$response[data.frame3$freq == max.freq3])
    predict = ifelse((treedata()[,1] > input$xslider) & (treedata()[,2] >= input$ysliderright), type3, predict)
    
    # area 4: x > xslider & y < ysliderright
    subset4 <- treedata()[(treedata()[,1] > input$xslider) & (treedata()[,2] < input$ysliderright), ]
    data.frame4 = count(subset4, "response")
    max.freq4 = max(data.frame4$freq, na.rm = TRUE)
    # species type in area 4
    type4 = as.character(data.frame4$response[data.frame4$freq == max.freq4])
    predict = ifelse((treedata()[,1] > input$xslider) & (treedata()[,2] < input$ysliderright), type4, predict)
    
    accuracy = ifelse(treedata()$response==predict, 1, 0)
    accuracy.pct = sum(accuracy)/length(accuracy)
    paste("Accuracy of your classification:", round(accuracy.pct,digits=2))
  })
  
  
  output$distPlot <- renderPlot({
    x1 = minmax()[1]
    x2 = input$xslider
    x3 = minmax()[2]
    if (input$left == TRUE && input$right == TRUE){
      ggplot(data = treedata(), aes(x=treedata()[,1], y=treedata()[,2], color=response)) + 
        geom_point()  + 
        theme(legend.position="none") + 
        labs(x = treeName()[1], y = treeName()[2]) +
        geom_vline(xintercept = as.numeric(input$xslider), color = "red") +
        geom_segment(aes(x = x1, y = input$ysliderleft, xend = x2, yend = input$ysliderleft)) +
        geom_segment(aes(x=x2,y=input$ysliderright,xend=x3,yend=input$ysliderright))
    } else if (input$left == TRUE){
      ggplot(data = treedata(), aes(x=treedata()[,1], y=treedata()[,2], color=response)) + 
        geom_point()  + 
        theme(legend.position="none") + 
        labs(x = treeName()[1], y = treeName()[2]) +
        geom_vline(xintercept = as.numeric(input$xslider), color = "red") +
        geom_segment(aes(x = x1, y = input$ysliderleft, xend = x2, yend = input$ysliderleft))
    } else if (input$right == TRUE){
      ggplot(data = treedata(), aes(x=treedata()[,1], y=treedata()[,2], color=response)) + 
        geom_point()  + 
        theme(legend.position="none") + 
        labs(x = treeName()[1], y = treeName()[2]) +
        geom_vline(xintercept = as.numeric(input$xslider), color = "red") +
        geom_segment(aes(x=x2,y=input$ysliderright,xend=x3,yend=input$ysliderright))
    } else {
      ggplot(data = treedata(), aes(x=treedata()[,1], y=treedata()[,2], color=response)) + 
        geom_point()  + 
        theme(legend.position="none") + 
        labs(x = treeName()[1], y = treeName()[2]) +
        geom_vline(xintercept = as.numeric(input$xslider), color = "red") 
    }
  })
  
  output$sample <- renderPlot({
    if (input$display){
      tree.out= tree(response~., data=treedata())
      plot(tree.out)
      text(tree.out, pretty=0)
    } else {
      plot(1, type="n", axes=F, xlab="", ylab="")
    }
  })
  output$sampleTree <- renderPlot({
    tree.out= tree(response~., data=treedata())
    plot(tree.out)
    text(tree.out, pretty=0)
  })
})
