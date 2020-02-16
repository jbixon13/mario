library(plumber)
library(tidyverse)
library(RSocrata)
library(lubridate)
library(janitor)
library(ggplot2)
library(scales)
library(plotly)

# read in MTA data from Socrata API
MTA_KPI <- RSocrata::read.socrata('https://data.ny.gov/resource/cy9b-i9w9.json?$where=period_year > 2014&agency_name=NYC Transit')

# convert period to date variable
transit <- MTA_KPI %>% 
  mutate(period = ymd(paste0(period, '-01'))) %>% 
  clean_names()

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

#* Return plotly object - plot 5
#* @serializer htmlwidget
#* @get /plot5
function() {
  # ridership
  transit_ridership <- transit %>% 
    filter(indicator_name == 'Total Ridership - Subways') %>% 
    mutate(monthly_actual = round(as.numeric(monthly_actual)))

  #plot ridership
  plt_ridership <-  transit_ridership %>% 
    ggplot(aes(x = period, y = monthly_actual)) +
    geom_point(color = 'steelblue4', alpha = .7) + 
    geom_smooth(method = 'lm') + 
    ylab('Total Monthly Ridership - All Lines') +
    scale_y_continuous(labels = comma) +
    theme_classic()

  ggplotly(plt_ridership) %>% 
    layout(title = list(text = 'There is no clear trend of monthly ridership',
                        font = list(size = 15
                        )
    )
    ) %>% 
    config(displayModeBar = FALSE, scrollZoom = FALSE)
}