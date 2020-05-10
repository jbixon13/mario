library(plumber)
library(tidyverse)
library(RSocrata)
library(lubridate)
library(janitor)
library(paws)
library(jsonlite)

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