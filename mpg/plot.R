library(plumber)
library(tidyverse)
library(ggplot2)
library(plotly)

#* @apiTitle MPG plotly export

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
  p <- ggplot(mpg) + 
    geom_point(aes(x = displ, y = hwy)) +
    theme_classic()
  
  ggplotly(p) %>% 
    config(displayModeBar = F)
}
