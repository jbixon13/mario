library(plumber)

root <- plumber$new()

diamond_api <- plumber$new("diamond/plot.R")
root$mount("/diamond", diamond_api)

mpg_api <- plumber$new("mpg/plot.R")
root$mount("/mpg", mpg_api)

root$run()


