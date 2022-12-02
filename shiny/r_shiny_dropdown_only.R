# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

# Load data 
clean_gdp_data_US <- read_csv("https://raw.githubusercontent.com/tillfurger/stock_vs_gdp/master/data/processed/clean_gdp_data.csv")
clean_stock_data_spy500 <- read_csv("https://raw.githubusercontent.com/tillfurger/stock_vs_gdp/master/data/processed/clean_stock_data.csv")

#add variable defining interval of values
clean_gdp_data_US$interval <- "Quarterly"
clean_stock_data_spy500$interval <- "Quarterly"
clean_gdp_data_US$type <- "US_gdp"
clean_stock_data_spy500$type <- "spy500"


# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Stock vs Gdp"),
                sidebarLayout(                              #layout with input and output definitions
                  sidebarPanel(                             #sidebar panel for inputs
                    
                    # Select type of data to plot
                    selectInput(inputId = "Interval", label = strong("Interval"),
                                choices = unique(clean_gdp_data_US$interval),
                                selected = "Quarterly"),
                    
                    # # Select date range to be plotted
                    # dateRangeInput("date", strong("Date range"), start = "2000-01-01", end = "2022-11-01",
                    #                min = "2000-01-01", max = "2022-11-01"),
                    
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
    clean_gdp_data_US %>%
      filter(interval == input$Interval)
  })
  
  
  # Create scatterplot object the plotOutput function is expecting
  output$lineplot <- renderPlot({
    color = "#434343"
    par(mar = c(4, 4, 1, 1))
    plot(x = selected_intervals()$date, y = selected_intervals()$value, type = "l",
         xlab = "Date", ylab = "GDP", col = color, fg = color, col.lab = color, col.axis = color)
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

# 
# 
# '''
# plotly
# could also do sliderInput (after "sidebar panel)
# 
# sliderInput(inputId = "bins",
#             label = "Number of bins:",
#             min = 1,
#             max = 50,
#             value = 30)


