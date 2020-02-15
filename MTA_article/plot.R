library(plumber)
library(tidyverse)
library(ggplot2)
library(plotly)

#* @apiTitle MTA article plotly export

#* Enable CORS
#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#* Return plotly object - plot 1
#* @serializer htmlwidget
#* @get /plot1
function() {
  p <- ggplot(mpg) + 
    geom_point(aes(x = displ, y = hwy)) +
    theme_classic()
  
  ggplotly(p) %>% 
    config(displayModeBar = F)
}

#* Return plotly object - plot 2
#* @serializer htmlwidget
#* @get /plot2
function() {
  p <- ggplot(mpg) + 
    geom_point(aes(x = displ, y = hwy)) +
    theme_classic()
  
  ggplotly(p) %>% 
    config(displayModeBar = F)
}

#* Return plotly object - plot 3
#* @serializer htmlwidget
#* @get /plot3
function() {
  p <- ggplot(mpg) + 
    geom_point(aes(x = displ, y = hwy)) +
    theme_classic()
  
  ggplotly(p) %>% 
    config(displayModeBar = F)
}

#* Return plotly object - plot 4
#* @serializer htmlwidget
#* @get /plot4
function() {
  p <- ggplot(mpg) + 
    geom_point(aes(x = displ, y = hwy)) +
    theme_classic()
  
  ggplotly(p) %>% 
    config(displayModeBar = F)
}