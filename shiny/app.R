# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(plotly)
#in order to publish
library(packrat)
library(rsconnect)


# helper functions (can also put this into a sep. doc but same working directory!)
calculate_returns = function(df, interval) {
  
  if (interval == "Quarterly") {
    
    df<- df[order(as.Date(df$date, format="%Y/%m/%d")),]
    
    df$q_return = diff(df$value)/lag(df$value)
    
  }
  
}


# Load data 
clean_gdp_data_US <- read_csv("https://raw.githubusercontent.com/tillfurger/stock_vs_gdp/master/data/processed/clean_gdp_data.csv")
clean_stock_data_spy500 <- read_csv("https://raw.githubusercontent.com/tillfurger/stock_vs_gdp/master/data/processed/clean_stock_data.csv")

#add variable defining interval of values
clean_gdp_data_US$interval <- "Quarterly"
clean_stock_data_spy500$interval <- "Quarterly"
clean_gdp_data_US$type <- "US_gdp"
clean_stock_data_spy500$type <- "spy500"

#rename variables to be nicely displayed in plotly tooltip
clean_stock_data_spy500$return <- round(clean_stock_data_spy500$q_return,3)

#reorder stock data
clean_stock_data_spy500<- clean_stock_data_spy500[order(as.Date(clean_stock_data_spy500$date, format="%Y/%m/%d")),]

#calculate quarterly gdp returns
clean_gdp_data_US<- clean_gdp_data_US[order(as.Date(clean_gdp_data_US$date, format="%Y/%m/%d")),]

clean_gdp_data_US$return = round(diff(clean_gdp_data_US$value)/lag(clean_gdp_data_US$value),3)



# Define UI

ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Stock Market Capitalization vs. GDP"),
                sidebarLayout(                              #layout with input and output definitions
                  sidebarPanel(                             #sidebar panel for inputs
                    
                    
                    
                    # Select type of data to plot
                    selectizeInput(inputId = "Interval", label = strong("Select frequency"),
                                   choices = unique(clean_gdp_data_US$interval),
                                   selected = "Quarterly"),
                    
                    # Select date range to be plotted
                    
                    # start and end are always specified in yyyy-mm-dd
                    
                    
                    dateRangeInput("dates", 
                                   label = "Date range:",
                                   start = "2000-01-01",
                                   end = "2022-11-01",
                                   min = "2000-01-01",
                                   max = "2022-11-01",
                                   format = "yy/mm/dd",
                                   separator = " - "),
                    
                  ),
                  
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
    clean_gdp_data_US %>%
      filter(interval == input$Interval,
             date >= input$dates[1],
             date <= input$dates[2])
  })
  
  # Subset data SPY
  selected_intervals_spy <- reactive({
    clean_stock_data_spy500 %>%
      filter(interval == input$Interval,
             date >= input$dates[1],
             date <= input$dates[2])
  })
  
  
  
  
  #Checkbox
  output$value <- renderPlotly({input$smooth}) #render plotly now?? Should I work with "switch"?
  
  
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


