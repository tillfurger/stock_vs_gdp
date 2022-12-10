# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(plotly)
#in order to publish
library(packrat)
library(rsconnect)

# Load data 
clean_gdp_data_US <- read_csv("https://raw.githubusercontent.com/tillfurger/stock_vs_gdp/master/data/processed/clean_gdp_data.csv")
clean_stock_data_spy500 <- read_csv("https://raw.githubusercontent.com/tillfurger/stock_vs_gdp/master/data/processed/clean_stock_data.csv")

#add variable defining interval of values
clean_gdp_data_US$interval <- "Quarterly"
clean_stock_data_spy500$interval <- "Quarterly"
clean_gdp_data_US$type <- "US_gdp"
clean_stock_data_spy500$type <- "spy500"

#reorder stock data
clean_stock_data_spy500<- clean_stock_data_spy500[order(as.Date(clean_stock_data_spy500$date, format="%Y/%m/%d")),]

#calculate quarterly gdp returns
clean_gdp_data_US<- clean_gdp_data_US[order(as.Date(clean_gdp_data_US$date, format="%Y/%m/%d")),]

clean_gdp_data_US$return = diff(clean_gdp_data_US$value)/lag(clean_gdp_data_US$value)

  

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Stock market capitalization vs GDP"),
                sidebarLayout(                              #layout with input and output definitions
                  sidebarPanel(                             #sidebar panel for inputs
                  
                    # Select type of data to plot
                    selectizeInput(inputId = "Interval", label = strong("Select frequency"),
                                choices = unique(clean_gdp_data_US$interval),
                                selected = "Quarterly"),
                    
                    # Select date range to be plotted
                    dateRangeInput("date", strong("Select date range"), start = "2000-01-01", end = "2022-11-01",
                                  min = "2000-01-01", max = "2022-11-01"),
                    
                  ),
                  
                  # Output: Description, lineplot, and reference (main panel for displaying outputs)
                  mainPanel(

                    checkboxInput("smooth", label = ("High income country"), value = TRUE),
                    checkboxInput("smooth", label = ("High income country"), value = TRUE),
                    checkboxInput("smooth", label = ("High income country"), value = TRUE),

                    plotlyOutput(outputId = "lineplot", height = "300px"),
                    textOutput(outputId = "desc"),
                  )
                )
)

# Define server function
server <- function(input, output) {
  
  # Subset data GDP
  selected_intervals_gdp <- reactive({
    clean_gdp_data_US %>%
      filter(interval == input$Interval)
  })
  
  # Subset data SPY
  selected_intervals_spy <- reactive({
    clean_stock_data_spy500 %>%
      filter(interval == input$Interval)
  })
  
  # Create scatterplot object the plotOutput function is expecting
  output$lineplot <- renderPlotly({
    
    plot <- ggplot() +
      geom_line(data=selected_intervals_gdp(), aes(x=date, y=return), color="blue") +
      geom_hline(aes(yintercept = mean(selected_intervals_gdp()$return, na.rm = T)), linetype="dashed", color="blue") +
      geom_line(data=selected_intervals_spy(), aes(x=date, y=q_return), color="orange") +
      geom_hline(aes(yintercept = mean(selected_intervals_spy()$q_return)), linetype="dashed", color="orange") + 
      theme(panel.background = element_blank()) +
      scale_y_continuous(labels = scales::percent) +
      xlab("Date") +  
      ylab("Return")
    
    ggplotly(plot)
    
    # Display only if smoother is checked
    # if(input$smoother){
    #   smooth_curve <- lowess(x = as.numeric(selected_intervals()$date), y = selected_intervals()$close, f = input$f)
    #   lines(smooth_curve, col = "#E6553A", lwd = 3)
    # }
  })
  
  # # Pull in description of interval
  # output$desc <- renderText({
  #   interval_text <- filter(clean_gdp_data, type == input$Interval) %>% pull(Interval)
  #   paste(interval_text, "Blabla.")
  # })
}

# Create Shiny object
shinyApp(ui = ui, server = server)




