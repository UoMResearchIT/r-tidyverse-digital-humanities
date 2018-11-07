# Convert the twitter data to tidy format for the
# course
# David Mawdsley 7 Nov 18
library(tidyverse)
library(lubridate)

datadir <- "rawdata/"
outdir <- "_episodes_rmd/data/"

toload <- list.files(datadir, "matrix_", full.names = TRUE)

readData <- function(infiles){
  allData <- list()
  
  for(f in infiles){
    thisdata <- read_csv(f) # Note trailing , causes warnings. FIXME
    currentword <- str_match(f, "matrix_(.+)\\.csv")[,2]
    
    thisdata <- thisdata %>%
      select(-"__") %>% 
      filter(!is.na(METROPOLITAN_CODE)) %>% 
      gather("date", "cases", -METROPOLITAN_NAME, -METROPOLITAN_CODE) %>% 
      mutate(date = ymd(date)) %>%
      mutate(stateCode = str_match(METROPOLITAN_NAME, "; (.+)$")[,2]) %>% 
      mutate(county = str_match(METROPOLITAN_NAME, "^(.+);")[,2]) %>% 
      filter(str_length(stateCode) == 2) %>%  # How to handle counties a/c state boundaries?? Deleting for now.
      filter(date >= ymd("2013-10-07")) %>% # Data collection appears to start here
      mutate(word = currentword) # Extract word from filename
    
    allData[[currentword]] <- thisdata
    
  }
  return(bind_rows(allData))
}

twitterDataCounty <- readData(toload) 

twitterData <- twitterDataCounty %>% 
  group_by(date, stateCode, word) %>% 
  summarise(cases = sum(cases))%>%  
  ungroup() %>% 
  mutate(dataDay = difftime(date, min(date), units = "days") + 1)

tokenData <- twitterData %>% 
  filter(word == "tokens_cbsa") %>% 
  select(-word) %>% 
  rename(total = cases)

twitterData <- twitterData %>%
  filter(word != "tokens_cbsa") 

stateCodes <- read_csv(paste0(datadir, "/states.csv")) %>% 
  rename(stateCode = Abbreviation)

stateRural <- read_csv(paste0(datadir, "/DEC_00_SF1_P002.csv")) %>% 
  rename(state = `GEO.display-label`, urban = VD03, rural = VD05, total = VD01) %>% 
  mutate(ruralpct = rural / total * 100) %>% 
  mutate(majorityUrbanRural = ifelse(ruralpct > 50, "Majority rural pop", "Majority urban pop")) %>% 
  inner_join(stateCodes, by=c("state" = "State")) %>% 
  select(state, stateCode, ruralpct, majorityUrbanRural)


write_csv(twitterData, paste0(outdir, "twitterData.csv"))
write_csv(tokenData, paste0(outdir, "tokenData.csv"))
write_csv(stateRural, paste0(outdir, "stateData.csv"))


