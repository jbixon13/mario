library(plumber)
library(tidyverse)
library(ggplot2)
library(plotly)

#* @apiTitle Diamond plotly export

#* Enable CORS
#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#* Return plotly object
#* @serializer htmlwidget
#* @get /plot
function() {
  p <- ggplot(diamonds) + 
    geom_bar(aes(x = cut, fill = clarity), position = 'dodge') +
    theme_classic()
  
  ggplotly(p) %>% 
    config(displayModeBar = F)
}
