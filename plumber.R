library(plumber)

root <- plumber$new()

hello_api <- plumber$new("hello/world.R")
root$mount("/hello", hello_api)

mta_article_api <- plumber$new("MTA_article/plot.R")
root$mount("/MTA_article", mta_article_api)