---
title: "Pilot: NDVI Time Series of Living England AOI"
author: "SM"
date: "2023-06-16"
output: html_document
---

```{r setup, echo=FALSE, message=FALSE,warning=FALSE, error=FALSE}
library(sf)
library(sp)
library(terra)
library(raster)
library(dplyr)
library(caret)
library(caretEnsemble)
library(ForestTools)
library(lidR)
library(randomForest)
library(e1071)
library(rgdal)
library(rgeos)
library(Rcpp)
library(rmarkdown)
library(knitr)
library(MASS)
library(car)
library(reticulate)
library(rstudioapi)
library(leaflet)
library(magrittr)
library(jsonlite)
library(processx)
library(leafem)
library(crayon)
library(R6)
library(cli)
library(rgee)
#rgee::ee_install(py_env = "rgee") ## installtion necessary only once
#devtools::install_github(("gearslaboratory/gdalUtils"))
library(gdalUtils)
#library(gdalUtilities)
#webshot::install_phantomjs(force = TRUE)
#knit_hooks$set(webgl = hook_webgl)
#knit_hooks$set(rgl.static = hook_rgl)
knitr::opts_chunk$set(echo = TRUE, warning=FALSE, error=FALSE, message = FALSE)
set.seed(123)
```

## Action:

The following report documents pilot code for evaluating spectral indices (NDVI) for identifying change in Living England AOI. This includes deployment of google earth engine through python and rgee package for data acquisition and rendering of spectral mosaics, as well as development of acccuracy metrics using caret modelling package in R.

### Assign Python(3.10.6) version in use
```{r, eval=FALSE}
reticulate::use_python("/usr/bin/python3.10",
                       required = TRUE)
reticulate::py_config()
```
### Initialize Earth Engine
```{r}
# Necessary only once in each environment/IDE
ee_Initialize() 
# To activate Google Cloud/Tidyverse API for data storage/sharing
# ee_Initialize(user = 'seamusrobertmurphy@gmail.com', drive = TRUE, gcs = TRUE) 
```

### Run diagnostics on Earth Engine Installation
```{r}
ee_check()

ee_check_python()
ee_check_credentials()
ee_check_python_packages()
```
### Derive DTM from Global SRTM data
```{r}
srtm <- ee$Image("USGS/SRTMGL1_003")
# Set vizualization parameters
viz <- list(
  max = 4000,
  min = 0,
  palette = c("#000000","#5AAD5A","#A9AD84","#FFFFFF")
)
# Visualize
Map$addLayer(
  eeObject = srtm,
  visParams =  viz,
  name = 'SRTM'
)
```