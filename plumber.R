library(plumber)

root <- plumber$new()

hello_api <- plumber$new("hello/world.R")
root$mount("/hello", hello_api)

diamond_api <- plumber$new("diamond/plot.R")
root$mount("/diamond", diamond_api)

mpg_api <- plumber$new("mpg/plot.R")
root$mount("/mpg", mpg_api)

mta_article_api <- plumber$new("MTA_article/plot.R")
root$mount("/MTA_article", mta_article_api)