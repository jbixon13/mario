library(plumber)
library(tidyverse)
library(RSocrata)
library(lubridate)
library(janitor)
library(paws)
library(jsonlite)
library(ggplot2)
library(scales)
library(plotly)

#* @apiTitle MTA article plot export

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
  select(-description) %>% 
  clean_names() 

# initialize s3 instance
s3 <- paws::s3()

#* Return JSON object - plot 1
#* @json 
#* @get /plot1
function() {
  # ridership
  transit_ridership <- transit %>% 
    filter(indicator_name == 'Total Ridership - Subways') %>% 
    mutate(monthly_actual = round((monthly_actual))) %>% 
    toJSON()
  
  # write json object to S3 storage
  s3$put_object(
    Body = transit_ridership,
    Bucket = 'mario-object-storage',
    Key = 'MTA-article/plot1.json'
  )
}

#* Return plotly object - plot 2
#* @json
#* @get /plot2
function() {
  # On-Time Performance
  transit_otp <- transit %>% 
    filter(indicator_name == 'On-Time Performance (Terminal)') %>% 
    mutate(monthly_actual = monthly_actual / 100) %>% 
    toJSON()

  # write json object to S3 storage
  s3$put_object(
    Body = transit_otp,
    Bucket = 'mario-object-storage',
    Key = 'MTA-article/plot2.json'
  )
}

#* Return plotly object - plot 3
#* @json
#* @get /plot3
function() {
  # wait assessment
  transit_wait <- transit %>% 
    filter(indicator_name == 'Subway Wait Assessment ') %>% 
    mutate(monthly_actual = monthly_actual / 100) %>% 
    toJSON()

  # write json object to S3 storage
  s3$put_object(
    Body = transit_wait,
    Bucket = 'mario-object-storage',
    Key = 'MTA-article/plot3.json'
  )
}

#* Return plotly object - plot 4
#* @json
#* @get /plot4
function() {
  # mean distance between failures
  transit_fail <- transit %>% 
    filter(indicator_name == 'Mean Distance Between Failures - Subways') %>% 
    toJSON()

  # write json object to S3 storage
  s3$put_object(
    Body = transit_fail,
    Bucket = 'mario-object-storage',
    Key = 'MTA-article/plot4.json'
  )
}

#* Return plotly object - plot 1
#* @serializer htmlwidget
#* @get /plot1viz
function() {
  # ridership
  transit_ridership <- transit %>% 
    filter(indicator_name == 'Total Ridership - Subways') %>% 
    mutate(monthly_actual = round((monthly_actual)))
  
  #plot ridership
  plt_ridership <- transit_ridership %>% 
    ggplot(aes(x = period, y = monthly_actual)) +
    geom_point(color = 'steelblue4', alpha = .7) + 
    geom_smooth(method = 'lm') + 
    ylab('Total Monthly Ridership - All Lines') +
    scale_y_continuous(labels = comma) +
    theme_classic()
  
  plt_ridership_viz <- ggplotly(plt_ridership) %>% 
    layout(title = list(text = 'There is no clear trend of monthly ridership',
                        font = list(size = 15)
                        )
           ) %>% 
    config(displayModeBar = FALSE, scrollZoom = FALSE) %>% 
    htmlwidgets::saveWidget(file = 'plotly_test.html', selfcontained = TRUE)
  
  file_name <- 'plotly_test.html'
  ridership_read <- file(file_name, 'rb')
  ridership_object <- readBin(read_file, 'raw', n = file.size(file_name))
  
  s3$put_object(
    Body = ridership_object,
    Bucket = 'mario-object-storage',
    Key = 'MTA-article/plotly_test.html',
    ContentType = 'text/html'
    )
  
}

