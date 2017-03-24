library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  output$main_plot <- renderPlot({
    ggplot(df1[df1$time_call <= max(input$time_call),], 
           aes(x=time_call, y=lift, colour=factor(lift))) + geom_point(size=5, alpha=0.6)

  })
  
  output$elevator <- renderPlot({
    ggplot(df1[df1$time_call <= max(input$time_call),], 
           aes(x=time_call, y=floor_to, colour=factor(lift))) + geom_line(size=1.5, alpha=0.7)
  })
  
  output$table <- renderTable({
    df1[df1$time_call <= max(input$time_call),]
  })
  
  output$hist_plot <- renderPlot({
    qplot(time_call,data=data.frame(time_call = df1[df1$time_call <= max(input$time_call), "time_call"]), geom="histogram", binwidth = 0.04)
    
  })
