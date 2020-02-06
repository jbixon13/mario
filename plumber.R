library(plumber)

root <- plumber$new()

diamond_api <- plumber$new("diamond/plot.R")
root$mount("/diamond", diamond_api)

mpg_api <- plumber$new("mpg/plot.R")
root$mount("/mpg", mpg_api)

root$run(host='0.0.0.0', port=8080)


