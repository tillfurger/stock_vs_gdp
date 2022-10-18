library(ggplot2)
library(dplyr)
library(hrbrthemes)
# import data
data <- read.csv(data/coding-environment-excercise.csv)

data <- read.csv("data/coding-environment-exercise.csv")

#ensure date is stored as date variable
data$date <- as.Date(data$date)

# Most basic bubble plot
p <- ggplot(data, aes(x=date, y=value)) +
  geom_line(color="#69b3a2") + 
  xlab("") +  
  ylab("Value") + 
  scale_x_date(date_breaks = "1 month", date_labels = "%m/%Y") +
  theme_ipsum() +
  theme(axis.text.x=element_text(angle=60, hjust=1)) 
p

ggsave("output/myplot.png", width = 10, height = 8, dpi = 100)
