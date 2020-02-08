library(plumber)

#* @apiTitle Wake up Plumber API

#* Enable CORS
#* @filter cors
cors <- function(res) {
    res$setHeader("Access-Control-Allow-Origin", "*")
    plumber::forward()
}

#* Default GET route.
#* @get /world
function() {
  list(status = "OK")
}
