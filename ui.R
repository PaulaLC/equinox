fluidPage(
  

  titlePanel('Equinox Spring 17 -  Elevator Pitch'),
  
  fluidRow(      
    
    sidebarPanel(
      width=12,
      sliderInput(inputId = "time_call",
                  label = "Time",
                  min = 7.5, max = 11, step = 0.04, value = 7.7,  animate=TRUE),
      hr(),
      helpText("Select arrival time")
    ),

    mainPanel(width=12,
      tabsetPanel(type = "tabs", 
                  tabPanel("Elevator route", plotOutput("elevator")), 
                  tabPanel("Lifts by time arrivals", plotOutput("main_plot")), 
                  tabPanel("Arrivals distribution", plotOutput("hist_plot")),
                  tabPanel("Table", tableOutput("table"))
      )
    )
    
  )
)
