# Base image https://hub.docker.com/u/rocker/
FROM rocker/r-base:latest

## create directories
RUN mkdir -p /data
RUN mkdir -p /code
RUN mkdir -p /output

## copy files
COPY /code/packages.R /code/packages.R
COPY /code/plot_data.R /code/plot_data.R

## install R-packages
RUN Rscript /code/packages.R