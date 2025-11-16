# Base image for Shiny apps
FROM rocker/shiny:latest

# Install system libraries needed by Shiny + mongolite + curl apps
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2-dev \
    libsasl2-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install required R packages
RUN R -e "install.packages(c('shiny', 'glue', 'DBI', 'jsonlite', 'httr', 'waiter', 'shinyToastify', 'dplyr', 'gargle', 'mongolite'), repos='https://cloud.r-project.org')"

# Set workdir and copy the app files
WORKDIR /srv/shiny-server
COPY . .

# Expose shiny port
EXPOSE 3838

# Start shiny server
CMD ["/usr/bin/shiny-server"]
