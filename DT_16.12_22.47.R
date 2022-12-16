# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(plotly)
library(tidyverse)
#in order to publish
library(packrat)
library(rsconnect)


# Load data 
clean_data_global <- read_csv("/Users/martinastieger/Desktop/data_full_shiny_long.csv")

#add variable defining interval of values.. kann man das so machen??
#"Quarterly" <- subset(clean_data_global$variable = "gdp_q_growth") 
#"Quarterly" <- subset(clean_data_global$variable ="stock_index_q_growth") 
#"Yearly"<- subset(clean_data_global$variable = "gdp_y_growth") 
#"Yearly"<- subset(clean_data_global$variable = "stock_index_y_growth")

#With grep function
Quarterly <- clean_data_global[grep("gdp_q_growth", clean_data_global$variable), ]
Quarterly <- clean_data_global[grep("stock_index_q_growth", clean_data_global$variable), ] 
Yearly <- clean_data_global[grep("gdp_y_growth", clean_data_global$variable), ] 
Yearly <- clean_data_global[grep("stock_index_y_growth", subset(clean_data_global$variable), ]


#add variable defining region
Region <- clean_data_global$region
North_America <- clean_data_global[grep("North America", clean_data_global$region), ]
#Europe <- 
#East_Asia <- 
#Latin_America <- 
#Define subset for Europe etc.also with grep function 


#add variable defining country level
High_income_country <- clean_data_global[grep("High income", clean_data_global$income_level), ]
#Middle_income_country <- clean_data_global$Upper_middle_income TBD
#Low_income_country <- clean_data_global$Lower_middle_income TBD

#rename variables to be nicely displayed in plotly tooltip
clean_data_global$return <- round(clean_data_global$q_return,3)

#reorder stock data
#clean_stock_data_spy500<- clean_stock_data_spy500[order(as.Date(clean_stock_data_spy500$date, format="%Y/%m/%d")),]


# Define UI

ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Stock Market Capitalization vs. GDP"),
                sidebarLayout(                              #layout with input and output definitions
                  sidebarPanel(                             #sidebar panel for inputs
                    
                    
                    
                    # Select type of data to plot
                    selectizeInput(inputId = "Interval", label = strong("Select frequency"),
                                   choices = unique(clean_data_global$variable),
                                   selected = "Quarterly"),
                    
                    # Select date range to be plotted
                    
                    # start and end are always specified in yyyy-mm-dd
                    
                    
                    dateRangeInput("dates", #Daterange noch ändern!!
                                   label = "Date range:",
                                   start = "2000-01-01",
                                   end = "2022-11-01",
                                   min = "2000-01-01",
                                   max = "2022-11-01",
                                   format = "yy/mm/dd",
                                   separator = " - "),
                    
                  ),
                  
                  #Select Region
                  selectInput("region", "Select a region:",
                  choices = c("North America", "Europe & Central Asia", "Latin America & Caribbean", "East Asia & Pacific"),
                  selected = "North America"),
                 # plotlyOutput() - hier reinnehmen??
                  
                  # Output: Description, lineplot, and reference (main panel for displaying outputs)
                  mainPanel(
                    
                    checkboxInput("smooth", label = ("High income country"), value = TRUE),
                    checkboxInput("smooth", label = ("Middle income country"), value = TRUE),
                    checkboxInput("smooth", label = ("Low income country"), value = TRUE),
                    plotlyOutput(outputId = "p", height = "300px"),
                    textOutput(outputId = "desc"),
                  )
                )
)
# Define server function
server <- function(input, output, session) { #do i have to add "session"??
  
  # Subset data GDP
  selected_intervals_gdp <- reactive({
    clean_data_global %>%
      filter(interval == input$Interval,
             date >= input$dates[1],
             date <= input$dates[2])
  })
  
  # Subset data Stock market
  selected_intervals_stock <- reactive({
    clean_data_global %>%
      filter(interval == input$Interval,
             date >= input$dates[1],
             date <= input$dates[2])
  })
  
  
  #Checkbox
  output$value <- renderPlotly({
    if(input$smooth) {
      h1("Output is shown")
    } else {
      h1("Output is hidden")
    }}) #render plotly now?? Should I work with "switch"? Need several loops and diff names bc 3 different checkboxes! 
  #need different logic too -> filter 
  
  #Use input from dropdown menu 'region'
  selected_region <-  clean_data_global %>%
    filter(region == input$region)
  
  #output$region_plot <- renderPlotly({
  #data <- data[data$region == input$region,]
  #data
  #})
  
  #Wann muss man das renderPlotly machen, erst ganz am Schluss? Zeugs ist ja gar nicht interaktiv..
  
  
  # Create scatterplot object the plotOutput function is expecting
  output$p <- renderPlotly({
    
    # Create plot
    p <- plot_ly(selected_intervals_gdp(), x = ~date, y = ~return, type = "scatter", mode = "lines", color = I("#0072B2"), name = "GDP") %>%
      add_trace(data = selected_intervals_spy(), x = ~date, y = ~return, type = "scatter", mode = "lines", color = I("#D55E00"), name = "SPY") %>%
      add_trace(data = selected_intervals_gdp(), x = ~date, y = ~mean(return, na.rm=T), type = "scatter", mode = "lines", color = I("#0072B2"), name = "Mean GDP Return", line = list(dash = "dash")) %>%
      add_trace(data = selected_intervals_spy(), x = ~date, y = ~mean(return, na.rm=T), type = "scatter", mode = "lines", color = I("#D55E00"), name = "Mean SPY Return", line = list(dash = "dash")) %>%
      layout(title = "Stock Market Capitalization vs. GDP",
             xaxis = list(title = "Date",
                          showgrid=FALSE),
             yaxis = list(title = "Return", tickformat = ".2%", 
                          showgrid=FALSE)) %>%
      layout(hoverlabel = list(bgcolor = "white", bordercolor = "grey", font = list(color = "black")),
             plot_bgcolor = I("white"),
             paper_bgcolor = I("white"))
    
    # Return plot
    p
    
  })
  
  
}

# Create Shiny object
shinyApp(ui = ui, server = server)
