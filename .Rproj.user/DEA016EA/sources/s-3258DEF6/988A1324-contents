library(plumber)
library(tidyverse)
library(ggplot2)
library(plotly)

#* @apiTitle Plotly export

#* Return plotly object
#* @serializer htmlwidget
#* @get /plotly
function() {
  p <- ggplot(diamonds) + 
    geom_bar(aes(x = cut, fill = clarity), position = 'dodge') +
    theme_classic()
  
  ggplotly(p) %>% 
    config(displayModeBar = F)
}
