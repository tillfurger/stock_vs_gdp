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
clean_data_global <- read_csv("data/processed/data_full_shiny_long.csv")


#round values to be nicely displayed in plotly tooltip
clean_data_global$value <- round(clean_data_global$value,3)

#first try with three countries (low-middle- + high-income country)
data_app <- subset(clean_data_global, clean_data_global$name=="United States"| clean_data_global$name=="Mexico"|clean_data_global$name=="Indonesia")

#create variable specifying if: absolute, quarterly, or yearly returns
data_app$type <- ifelse(grepl("q_growth", data_app$variable), "Quarterly", ifelse(grepl("y_growth", data_app$variable), "Yearly", "Absolute"))

#keep only growth rates
data_app <- subset(data_app, data_app$type !="Absolute")

#rename variable value "return" to make it fit with code written below

data_app$return <- data_app$value

#reorder stock data
#clean_stock_data_spy500<- clean_stock_data_spy500[order(as.Date(clean_stock_data_spy500$date, format="%Y/%m/%d")),]


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
                                   label = "Date range:",
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
                    
                    checkboxInput("smooth", label = ("United States"), value = TRUE),
                    checkboxInput("smooth", label = ("Mexico"), value = TRUE),
                    checkboxInput("smooth", label = ("Indonesia"), value = TRUE),
                    plotlyOutput(outputId = "p", height = "300px"),
                    textOutput(outputId = "desc"),
                  )
                )
                
)


# Define server function
server <- function(input, output, session) { #do i have to add "session"??
  
  # Subset data GDP
  selected_data <- reactive({
    data_app %>%
      filter(type == input$Interval,
             date >= input$dates[1],
             date <= input$dates[2]
      )
  })
  
  
  
  #Checkbox
  # output$p <- renderPlotly({
  #   if(input$smooth) {
  #     h1("Output is shown") #hier muss dann der plot rein
  #   } else {
  #     h1("Output is hidden")
  #   }}) #render plotly now?? Should I work with "switch"? Need several loops and diff names bc 3 different checkboxes! 
  # #need different logic too -> filter 
  # 
  # #Use input from dropdown menu 'region'
  # selected_region <-  clean_data_global %>%
  #   filter(region == input$region)
  # 
  # #output$region_plot <- renderPlotly({
  # #data <- data[data$region == input$region,]
  # #data
  # #})
  # 
  # #Wann muss man das renderPlotly machen, erst ganz am Schluss? Zeugs ist ja gar nicht interaktiv..
  # 
  
  # Create scatterplot object the plotOutput function is expecting
  output$p <- renderPlotly({ #hier muss dann der plot rein
    
    # Create plot
    p <- plot_ly(selected_data(), x = ~date, y = ~return, type = "scatter", mode = "lines", color = I("#0072B2"), name = "GDP") %>%
      add_trace(data = selected_data(), x = ~date, y = ~return, type = "scatter", mode = "lines", color = I("#D55E00"), name = "SPY") %>%
      add_trace(data = selected_data(), x = ~date, y = ~mean(return, na.rm=T), type = "scatter", mode = "lines", color = I("#0072B2"), name = "Mean GDP Return", line = list(dash = "dash")) %>%
      add_trace(data = selected_data(), x = ~date, y = ~mean(return, na.rm=T), type = "scatter", mode = "lines", color = I("#D55E00"), name = "Mean SPY Return", line = list(dash = "dash")) %>%
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
