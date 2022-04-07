FROM openanalytics/r-shiny

MAINTAINER Tim M.Schendzielorz "tim.schendzielorz@googlemail.com"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libudunits2-dev \
    libssh2-1-dev \
    libcurl4-openssl-dev \
    libsasl2-dev \
    libv8-dev \
    libgdal-dev \
    protobuf-c-compiler \
    cargo \
    && rm -rf /var/lib/apt/lists/*

# basic shiny functionality
RUN R -e "install.packages(c('tidyverse', 'shiny', 'rmarkdown', 'knitr', 'flexdashboard', 'mapboxapi', 'sf', 'leaflet', 'DT'), dependencies = T, repo='http://cran.r-project.org')"

# copy the app to the image
RUN mkdir /root/oce_hubs
COPY hubs.Rmd /root/oce_hubs

RUN chmod -R 755 /root/oce_hubs

EXPOSE 3838

CMD ["R", "-e", "rmarkdown::run('/root/oce_hubs/hubs.Rmd', shiny_args = list(port = 3838, host = '0.0.0.0'))"]