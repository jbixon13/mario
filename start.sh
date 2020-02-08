#!/bin/bash

# assigns port based on Heroku env var
R -e 'source("plumber.R"); if(Sys.getenv("PORT") == "") Sys.setenv(PORT = 8080); root$run(host = "0.0.0.0", port=as.numeric(Sys.getenv("PORT")))'
