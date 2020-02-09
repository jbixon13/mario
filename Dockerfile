#FROM rocker/r-ver:3.6.0
FROM rocker/r-apt:bionic

# install linux libs & binary R packages where possible
RUN apt-get update -qq && apt-get install -y \
  libssl-dev \
  libcurl4-gnutls-dev \
  libsodium-dev \
  libxml2-dev \
  libz-dev \
  r-cran-remotes \  
  r-cran-tidyverse \
  r-cran-ggplot2 \
  r-cran-plotly

# Install packages from source
RUN R -e "remotes::install_github('rstudio/plumber')"

# Copy all, use .dockerignore in root to exclude
COPY . /

# Make start.sh an executable
RUN chmod +x start.sh

# Expose port, will not be respected by Heroku
EXPOSE 8080

# run root plumber.R on container startup
ENTRYPOINT ["./start.sh"]
CMD ["plumber.R"]
