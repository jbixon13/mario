library(plumber)
library(tidyverse)
library(ggplot2)
library(plotly)

#* @apiTitle MPG plotly export

#* Return plotly object
#* @serializer htmlwidget
#* @get /plot
function() {
  p <- ggplot(mpg) + 
    geom_point(aes(x = displ, y = hwy)) +
    theme_classic()
  
  ggplotly(p) %>% 
    config(displayModeBar = F)
}
