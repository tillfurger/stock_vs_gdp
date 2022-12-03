# helper functions
calculate_returns = function(df, interval) {
  
  if (interval == "Quarterly") {
    
    df<- df[order(as.Date(df$date, format="%Y/%m/%d")),]
    
    df$q_return = diff(df$value)/lag(df$value)
    
  }
  
}