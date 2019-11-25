library(tidyverse)
library(httr)
library(jsonlite)
base_url <- 'http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/reverseGeocode?f=pjson&langCode=EN&location=%d,%d'


base_grid <- expand.grid(x = -180:180,y = -90:90)
{
st <- Sys.time()
result <- base_grid %>% 
  sample_n(100) %>% 
  mutate(api_url = sprintf(base_url, x, y)) %>% 
  as_tibble() %>% 
  mutate(addr = map(api_url, get_addr))
print(Sys.time() - st)
  }


get_addr <- function(.base_url) {
  # print(.base_url)
  # print('-------')
  address <- .base_url %>% 
    # sprintf(x, y) %>% 
    GET() %>% 
    .$content %>% 
    rawToChar() %>% 
    jsonlite::fromJSON()  %>% 
    .$address %>% 
    .$LongLabel
  
  if(address %>% is.null()){
    address <- '-'
  }
  # print(address)
  return(address)
}


####

library(foreach)
library(doParallel)
result %>% 
  unnest()
numcores <- detectCores() - 1
mycluster <- makeCluster(numcores)
registerDoParallel(mycluster)

record <- tibble()