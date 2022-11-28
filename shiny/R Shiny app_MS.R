# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

# Load data (how?)
clean_gdp_data <- read_csv("https://github.com/tillfurger/stock_vs_gdp/blob/master/data/processed/clean_gdp_data.csv")
clean_stock_data <- read_csv("https://github.com/tillfurger/stock_vs_gdp/blob/master/data/processed/clean_stock_data.csv")

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Stock vs Gdp"),
                sidebarLayout(                              #layout with input and output definitions
                  sidebarPanel(                             #sidebar panel for inputs
                    
                    # Select type of data to plot
                    selectInput(inputId = "Interval", label = strong("Interval"),
                                choices = unique(clean_gdp_data$type),
                                selected = "Interval"),
                    
                    # Select date range to be plotted
                    dateRangeInput("date", strong("Date range"), start = "2000-01-01", end = "2022-11-01",
                                   min = "2000-01-01", max = "2022-11-01"),
                    
                    # Select whether to overlay smooth trend line
                    checkboxInput(inputId = "smoother", label = strong("Overlay smooth trend line"), value = FALSE),
                    
                    # Display only if the smoother is checked
                    conditionalPanel(condition = "input.smoother == true",
                                     sliderInput(inputId = "f", label = "Smoother span:",
                                                 min = 0.01, max = 1, value = 0.67, step = 0.01,
                                                 animate = animationOptions(interval = 100)),
                                     HTML("Higher values give more smoothness.")
                    )
                  ),
                  
                  # Output: Description, lineplot, and reference (main panel for displaying outputs)
                  mainPanel(
                    plotOutput(outputId = "lineplot", height = "300px"),
                    textOutput(outputId = "desc"),
                  )
                )
)

# Define server function
server <- function(input, output) {
  
  # Subset data
  selected_intervals <- reactive({
    req(input$date)
    validate(need(!is.na(input$date[1]) & !is.na(input$date[2]), "Error: Please provide both a start and an end date."))
    validate(need(input$date[1] < input$date[2], "Error: Start date should be earlier than end date."))
    clean_gdp_data %>%   #pipe operator: takes output of one function and passes it into another funct
      filter(
        interval == input$interval, #Wie machen? 
        date > as.POSIXct(input$date[1]) & date < as.POSIXct(input$date[2]  #??
        ))
  })
  
  
  # Create scatterplot object the plotOutput function is expecting
  output$lineplot <- renderPlot({
    color = "#434343"
    par(mar = c(4, 4, 1, 1))
    plot(x = selected_intervals()$date, y = selected_intervals()$close, type = "l",
         xlab = "Date", ylab = "GDP", col = color, fg = color, col.lab = color, col.axis = color)
    # Display only if smoother is checked
    if(input$smoother){
      smooth_curve <- lowess(x = as.numeric(selected_intervals()$date), y = selected_intervals()$close, f = input$f)
      lines(smooth_curve, col = "#E6553A", lwd = 3)
    }
  })
  
  # Pull in description of interval
  output$desc <- renderText({
    interval_text <- filter(clean_gdp_data, interval == input$interval) %>% pull(interval)
    paste(interval_text, "Blabla.")
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)



'''
plotly
could also do sliderInput (after "sidebar panel)

sliderInput(inputId = "bins",
            label = "Number of bins:",
            min = 1,
            max = 50,
            value = 30)


