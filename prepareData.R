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
      # filter(!between(date, dmy("20-10-2014"), dmy("28-10-2014"))) %>% # Tweets weren't properly collected in these period
      # filter(!(date %in% c(dmy("26-03-2014"), dmy("29-03-2014")))) %>% # Tweets weren't properly collected on these dates
      mutate(cases = ifelse(between(date, dmy("20-10-2014"), dmy("28-10-2014")) | 
                              (date %in% c(dmy("26-03-2014"), dmy("29-03-2014"))),
                            NA, cases)) %>% 
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
  rename(totalTokens = cases)

twitterData <- twitterData %>%
  filter(word != "tokens_cbsa") 

stateCodes <- read_csv(paste0(datadir, "/states.csv")) %>% 
  rename(stateCode = `State Code`)

stateRural <- read_csv(paste0(datadir, "/DEC_00_SF1_P002.csv")) %>% 
  rename(state = `GEO.display-label`, urban = VD03, rural = VD05, totalPop = VD01) %>% 
  mutate(ruralpct = rural / totalPop * 100) %>% 
  mutate(majorityUrbanRural = ifelse(ruralpct > 50, "Majority rural pop", "Majority urban pop")) %>% 
  inner_join(stateCodes, by=c("state" = "State")) %>% 
  select(state, stateCode, ruralpct, majorityUrbanRural, totalPop)



# Join the region and division data to the twitter data
twitterData <-  twitterData %>%
  inner_join(stateCodes %>% select(-State)) %>% 
# And the total number of tokens
  inner_join(tokenData) %>%
  inner_join(stateRural %>%
	     select(stateCode, totalPop, ruralpct))


# Add extra data from AN 

newData <- read_csv("rawdata/LI_DEMO.txt")

newDataState <- newData %>% 
  group_by(STATE) %>% 
  summarise(BLACK_2010 = weighted.mean(BLACK_2010, TOTPOP_2000),
            TOTPOP_2000 = sum(TOTPOP_2000))

# Sense check the total populations
# newDataState %>% 
#   summarise(totpop = sum(TOTPOP_2000))
# 
# newDataState %>% 
#   arrange(desc(TOTPOP_2000))
# newDataState %>% 
#   arrange((TOTPOP_2000))

# Compare total population estimates
# twitterData %>% 
#   filter(word == "anime") %>% 
#   filter(date == ymd("2013-10-07")) %>% 
#   inner_join(stateCodes %>% select(State, stateCode)) %>% 
#   mutate(stateLower = tolower(State)) %>%  
#   inner_join(newDataState %>%  select(STATE, TOTPOP_2000), by=c("stateLower" = "STATE")) %>% 
#   filter(!between(TOTPOP_2000 / totalPop, 0.9, 1.1)) %>% # just look at state far from approx equality
#   ggplot(aes(x = totalPop, y = TOTPOP_2000, label = State)) + geom_point() + geom_text() +
#   geom_abline(slope = 1, intercept = 0)


twitterData <- twitterData %>% 
  inner_join(stateCodes %>% select(State, stateCode)) %>% 
  mutate(stateLower = tolower(State)) %>%  
  inner_join(newDataState %>%  select(STATE, BLACK_2010), by=c("stateLower" = "STATE")) %>% 
  select(-stateLower) 

write_csv(twitterData, paste0(outdir, "twitterData.csv"))
write_csv(tokenData, paste0(outdir, "tokenData.csv"))
write_csv(stateRural, paste0(outdir, "stateData.csv"))


