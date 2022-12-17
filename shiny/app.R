# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(plotly)
library(tidyverse)
library(RColorBrewer)
# in order to publish
library(packrat)
library(rsconnect)

###############
## PRELIMINARIES
###############

# Load data
clean_data_global <- read_csv(url("https://raw.githubusercontent.com/tillfurger/stock_vs_gdp/master/shiny/shiny_data/data_full_shiny_long.csv"))

# create colorblind friendly color palette --> check with colorblindly
palette <- colorRampPalette(brewer.pal(n = 9, name = "RdBu"))(6)

# round values to be nicely displayed in plotly tooltip
clean_data_global$value <- round(clean_data_global$value,3)

###############
## DATA CLEANING
###############

# filter for three countries (low-middle- + high-income country)
data_app <- subset(clean_data_global, clean_data_global$name=="United States"| clean_data_global$name=="Mexico"| clean_data_global$name=="Indonesia")

# create variable specifying if: absolute, quarterly, or yearly returns
data_app$type <- ifelse(grepl("q_growth", data_app$variable), "Quarterly", ifelse(grepl("y_growth", data_app$variable), "Yearly", "Absolute"))

# create variable specifying if: gdp or stock index
data_app$series <- ifelse(grepl("gdp", data_app$variable), "GDP", ifelse(grepl("stock", data_app$variable), "Stock Index", "NA"))

# create variable to specify combination of country selected and series
data_app$combination <- paste(data_app$name, data_app$series)

# create variable to specify combination of country, growth rate selected and series
data_app$combination_frequency <- paste(data_app$combination, data_app$type)

# if mean values, add this to variable name for legend in shiny app
#data_app$combination_frequency <- ifelse(data_app$)


# create variable containing average return of each variable "combination_frequency"
data_app <- data_app %>% group_by(combination_frequency) %>% mutate(ave_value = round(mean(value, na.rm = T),3))

# keep only growth rates
data_app <- subset(data_app, data_app$type !="Absolute")

# rename variable value "return" to make it fit with code written below

data_app$return <- data_app$value

###############
## SHINY APP
###############


ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Stock Market Capitalization vs. GDP"),
                sidebarLayout(                              #layout with input and output definitions
                  sidebarPanel(                             #sidebar panel for inputs
                    
                    
                    
                    # Select type of data to plot
                    selectizeInput(inputId = "Interval", label = strong("Select Frequency"),
                                   choices = unique(data_app$type),
                                   selected = "Quarterly"),
                    
                    # Select date range to be plotted
                    dateRangeInput("dates", 
                                   label = strong("Select Date Range (yy/mm/dd)"),
                                   start = "2000-01-01",
                                   end = "2022-11-01",
                                   min = "2000-01-01",
                                   max = "2022-11-01",
                                   format = "yy/mm/dd",
                                   separator = " - "),
                    br(),
                    p("Please note that keyboard input does not work, only clicking to select date range.")
                    
                  ),
                  
                  
                  # Output: Description, lineplot, and reference (main panel for displaying outputs)
                  mainPanel(
                    checkboxGroupInput("country", label = strong("Select countries to include"), 
                                       choices = unique(data_app$name),
                                       selected = c("United States", "Mexico"), inline = T),
                    h2(strong("Line Chart", align = "center")),
                    plotlyOutput(outputId = "p", height = "300px"),
                    br(), br(),
                    h2(strong("Boxplots", align = "center")),
                    plotlyOutput(outputId = "boxplots"),
                    br(), br(),
                    h2(strong("Histogram", align = "center")),
                    plotlyOutput(outputId = "histograms"),
                    textOutput(outputId = "desc"),
                  )
                )
                
)


# Define server function
server <- function(input, output, session) { 
  
  # Create reactive dataframe
  data_plot <- reactive({
    
    # Filter data based on user input
    data_app %>%
      filter(type == input$Interval) %>%
      filter(date >= input$dates[1] & date <= input$dates[2]) %>%
      filter(name %in% input$country)
    
  })
  
  
  # Create output
  output$p <- renderPlotly({
    
    # Create plot
    p <- plot_ly(data_plot(), x = ~date, y = ~return, color = ~combination_frequency, type = "scatter", mode = "lines",
                 line = list(width = 1.5),
                 hoverinfo = "text",
                 text = ~paste("Country: ", name, "<br>", "Date: ", date, "<br>", "Growth Rate: ", return, "%"), colors = palette)   %>%
      add_trace(data = data_plot(), x = ~date, y = ~ave_value, color = ~combination_frequency, type = "scatter", mode = "lines",  line = list(dash = "dash"),
                hoverinfo = "text",
                text = ~paste("Country: ", name, "<br>", paste0("Avg. Growth Rate ", data_plot()$series, ": "), ave_value, "%"),
                name = paste0(data_plot()$name," Mean ", data_plot()$series, " Growth Rate")) %>%
      layout(title = "Stock Market Capitalization vs. GDP",
             xaxis = list(title = "Date",
                          showgrid=FALSE),
             yaxis = list(title = "Growth Rate",
                          showgrid=FALSE, tickformat = ".2%"))
    
    # Return plot
    p
  })
  
  output$boxplots <- renderPlotly({
    
    # Create plot
    p <- plot_ly(data_plot(), x = ~name, y = ~return, color = ~combination_frequency, type = "box",
                 hoverinfo = "text",
                 text = ~paste("Country: ", name, "<br>", "Date: ", date, "<br>", "Growth Rate: ", return, "%"), colors = palette) %>%
      layout(title = "Stock Market Capitalization and GDP Growth Rates by Country",
             xaxis = list(title = "",
                          showgrid=FALSE),
             yaxis = list(title = "Growth Rate",
                          showgrid=FALSE, tickformat = ".2%"))
    
    
    # Return plot
    p
    
  })
  
  output$histograms <- renderPlotly({
    
    # Create plot
    p <- plot_ly(data_plot(), x = ~return, color = ~combination_frequency, type = "histogram", colors = palette) %>%
      layout(title = "Histogram of Growth Rates by Country",
             xaxis = list(title = "Growth Rate",
                          showgrid=FALSE, tickformat = ".2%"),
             yaxis = list(title = "Frequency",
                          showgrid=FALSE))
    
    
    # Return plot
    p
    
  })
  
  
}

# Create Shiny object
shinyApp(ui = ui, server = server)




