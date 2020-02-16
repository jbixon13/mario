library(plumber)
library(tidyverse)
library(RSocrata)
library(lubridate)
library(janitor)
library(ggplot2)
library(scales)
library(plotly)

#* @apiTitle MTA article plotly export

#* Enable CORS
#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

# read in MTA data from Socrata API
MTA_KPI <- RSocrata::read.socrata('https://data.ny.gov/resource/cy9b-i9w9.json?$where=period_year > 2014&agency_name=NYC Transit')

# convert period to date, convert KPI to numeric
transit <- MTA_KPI %>% 
  mutate(period = ymd(paste0(period, '-01'))) %>% 
  mutate(monthly_actual = as.numeric(monthly_actual)) %>% 
  clean_names()

#* Return plotly object - plot 1
#* @serializer htmlwidget
#* @get /plot1
function() {
  # ridership
  transit_ridership <- transit %>% 
    filter(indicator_name == 'Total Ridership - Subways') %>% 
    mutate(monthly_actual = round((monthly_actual))

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

#* Return plotly object - plot 2
#* @serializer htmlwidget
#* @get /plot2
function() {
  # On-Time Performance
  transit_otp <- transit %>% 
    filter(indicator_name == 'On-Time Performance (Terminal)') %>% 
    mutate(monthly_actual = monthly_actual / 100)

  # plot On-Time Performance
  plt_otp <- transit_otp %>% 
    ggplot(aes(x = period, y = monthly_actual)) +
    geom_point(color = 'steelblue4', alpha = .7) + 
    geom_smooth(method = 'lm') + 
    ylab('Monthly On-Time Performance - All Lines') +
    scale_y_continuous(labels = percent) +
    theme_classic()

  ggplotly(plt_otp) %>% 
    layout(title = list(text = 'Subway cars are arriving at their destination on schedule less.',
                        font = list(size = 15
                        )
    )
    ) %>% 
    config(displayModeBar = FALSE, scrollZoom = FALSE)
}

#* Return plotly object - plot 3
#* @serializer htmlwidget
#* @get /plot3
function() {
  # wait assessment
  transit_wait <- transit %>% 
    filter(indicator_name == 'Subway Wait Assessment ') %>% 
    mutate(monthly_actual = monthly_actual / 100)

  # plot wait assessment
  plt_wait <- transit_wait %>% 
    ggplot(aes(x = period, y = monthly_actual)) +
    geom_point(color = 'steelblue4', alpha = .7) + 
    geom_smooth(method = 'lm') + 
    ylab('Subway Wait Assessment - All Lines') +
    scale_y_continuous(labels = percent) +
    theme_classic()

  ggplotly(plt_wait) %>% 
    layout(title = list(text = 'Subway cars are less routinely spaced during peak hours.', 
                        font = list(size = 15
                        )
    )
    ) %>% 
    config(displayModeBar = FALSE, scrollZoom = FALSE) 
}

#* Return plotly object - plot 4
#* @serializer htmlwidget
#* @get /plot4
function() {
  # mean distance between failures
  transit_fail <- transit %>% 
    filter(indicator_name == 'Mean Distance Between Failures - Subways') 

  # plot mean distance between failures
  plt_fail <- transit_fail %>% 
    ggplot(aes(x = period, y = monthly_actual)) +
    geom_point(color = 'steelblue4', alpha = .7) + 
    geom_smooth(method = 'lm') + 
    ylab('Mean Distance Between Failures (Miles)') +
    scale_y_continuous(labels = comma) +
    theme_classic()

  ggplotly(plt_fail) %>% 
    layout(title = list(text = 'Subway cars are breaking down more frequently.',
                        font = list(size = 15
                        )
    )
    ) %>% 
    config(displayModeBar = FALSE, scrollZoom = FALSE)
}