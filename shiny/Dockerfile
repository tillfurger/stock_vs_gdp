# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest


#install packages
RUN R -e "install.packages(c('dplyr', 'readr', 'emojifont', 'plotly', 'tidyverse', 'shinyWidgets', 'RColorBrewer', 'packrat', 'rsconnect'))"

#expose port
EXPOSE 3838

#run app on container start
CMD ["R", "-e", "shiny::runApp(app.R,host = '0.0.0.0', port = 3838)"]
