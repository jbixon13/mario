#FROM rocker/r-ver:3.6.0
FROM rocker/r-apt:bionic

# install linux libs
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

# Install packages
#RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_github('rstudio/plumber')"
#RUN R -e "install.packages('tidyverse')"
#RUN R -e "install.packages('ggplot2')"
#RUN R -e "install.packages('plotly')"

# Copy all, use .dockerignore in root to exclude
COPY . /

# Expose port, will not be respected by Heroku
EXPOSE 8080

# run root plumber.R on container startup
ENTRYPOINT ["Rscript", "plumber.R"]

#CMD ["R"]