# Use an R runtime as a base image
FROM rocker/shiny:latest

# Install system libs
RUN apt-get update && apt-get install -y \
    libssl-dev libcurl4-openssl-dev libxml2-dev \
    && rm -rf /var/lib/apt/lists/*
    
# Make a directory in the container
RUN mkdir /home/chat

RUN mkdir /home/chat/WWW

# Copy the Shiny app files into the container
COPY app.R /home/chat/app.R

COPY google-analytics.html /home/chat/google-analytics.html
# Install R dependencies
RUN R -e "install.packages(c('shiny','glue','lubridate','DBI','RSQLite','jsonlite','httr','waiter','shinyToastify','dplyr', 'ggplot2', 'lubridate','magrittr','gargle', 'digest','uuid','blastula','mongolite','googleAuthR'))"

# Expose the application port
#EXPOSE 8000
EXPOSE 8080

# Command to run the Shiny app
CMD ["R", "-e", "shiny::runApp('/home/chat/app.R',host='0.0.0.0', port=8080)"]