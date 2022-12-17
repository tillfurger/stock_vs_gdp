# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(plotly)
library(tidyverse)
library(RColorBrewer)
#in order to publish
library(packrat)
library(rsconnect)


# Load data 
clean_data_global <- read_csv("../data/processed/data_full_shiny_long.csv")

#create colorblindriendly color palette --> check with colorblindly
palette <- colorRampPalette(brewer.pal(n = 9, name = "RdBu"))(6)

#round values to be nicely displayed in plotly tooltip
clean_data_global$value <- round(clean_data_global$value,3)

#first try with three countries (low-middle- + high-income country)
data_app <- subset(clean_data_global, clean_data_global$name=="United States"| clean_data_global$name=="Mexico"| clean_data_global$name=="Japan")

#create variable specifying if: absolute, quarterly, or yearly returns
data_app$type <- ifelse(grepl("q_growth", data_app$variable), "Quarterly", ifelse(grepl("y_growth", data_app$variable), "Yearly", "Absolute"))

#keep only growth rates
data_app <- subset(data_app, data_app$type !="Absolute")

#rename variable value "return" to make it fit with code written below

data_app$return <- data_app$value

#reorder stock data


# Define UI

ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Stock Market Capitalization vs. GDP"),
                sidebarLayout(                              #layout with input and output definitions
                  sidebarPanel(                             #sidebar panel for inputs
                    
                    
                    
                    # Select type of data to plot
                    selectizeInput(inputId = "Interval", label = strong("Select frequency"),
                                   choices = unique(data_app$type),
                                   selected = "Quarterly"),
                    
                    # Select date range to be plotted
                    
                    # start and end are always specified in yyyy-mm-dd
                    
                    
                    dateRangeInput("dates", #Daterange noch ändern!!
                                   label = strong("Select date range (yy/mm/dd)"),
                                   start = "2000-01-01",
                                   end = "2022-11-01",
                                   min = "2000-01-01",
                                   max = "2022-11-01",
                                   format = "yy/mm/dd",
                                   separator = " - "),
                    
                  ),
                  
                  #Select Region
                  # selectInput("region", "Select a region:",
                  # choices = c("North America", "Europe & Central Asia", "Latin America & Caribbean", "East Asia & Pacific"),
                  # selected = "North America"),
                  # plotlyOutput() - hier reinnehmen??
                  
                  # Output: Description, lineplot, and reference (main panel for displaying outputs)
                  mainPanel(
                    checkboxGroupInput("country", label = strong("Select countries to plot"), 
                                       choices = unique(data_app$name),
                                       selected = c("United States", "Mexico", "Indonesia")),
                    plotlyOutput(outputId = "p", height = "300px"),
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
    p <- plot_ly(data_plot(), x = ~date, y = ~return, color = ~name, type = "scatter", mode = "lines",
                 line = list(width = 1.5),
                 hoverinfo = "text",
                 text = ~paste("Country: ", name, "<br>", "Date: ", date, "<br>", "Return: ", return, "%"), colors = palette)   %>%
      add_trace(data = data_plot(), x = ~date, y = ~mean(return, na.rm=T), color = ~name, type = "scatter", mode = "lines",  line = list(dash = "dash"),
                hoverinfo = "text",
                text = ~paste("Country: ", name, "<br>", "Avg. Return: ", mean(return, na.rm=T), "%")) %>%
      layout(title = "Stock Market Capitalization vs. GDP",
             xaxis = list(title = "Date",
                          showgrid=FALSE),
             yaxis = list(title = "Return",
                          showgrid=FALSE, tickformat = ".2%"))
    
    # Return plot
    p
    
  })
  
  
}

# Create Shiny object
shinyApp(ui = ui, server = server)
