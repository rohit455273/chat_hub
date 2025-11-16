# Base image with R + Shiny pre-installed
FROM rocker/shiny:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libssl-dev libcurl4-openssl-dev libxml2-dev libsasl2-dev \
    curl wget gnupg && \
    apt-get clean

# Install R packages
RUN R -e "install.packages(c('shiny','glue','DBI','jsonlite','httr','waiter','shinyToastify','dplyr','mongolite'), repos='https://cloud.r-project.org')"

# Copy app to container
WORKDIR /app
COPY . .

# Expose app port
EXPOSE 8080

# Run Shiny directly (best for container scaling)
CMD R -e "shiny::runApp('/app', host='0.0.0.0', port=8080)"
