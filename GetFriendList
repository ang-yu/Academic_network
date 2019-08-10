### ####
### This is to extract the friend list via Twitter API

install.packages("twitteR")
install.packages("tm")
install.packages("rtweet")
install.packages("NLP")


library("twitteR")
library("NLP")
library("tm")
library("rtweet")


consumer_key <- 'VPXR0O6pTFZvRWL95fKp736s4'
consumer_secret <- '5Bb1TDnsCcC1U0BfHfALucPAdugFmK6G9wgvyElPue9LDJo5Us'
access_token <- '1143210205854892032-L9WgZxHZzLGfqFr6n9J4gqP0bQBTrf'
access_secret <- '8DMaWUl34MDvPRXzLwnpMdwaUhaFe9HMBynUy637ZvWlr'

setup_twitter_oauth(consumer_key,
                    consumer_secret,
                    access_token,
                    access_secret)

token <- create_token(
  app = "Academic_network",
  consumer_key,
  consumer_secret,
  access_token,
  access_secret)


name_list <- read.csv("/Users/pons/Documents/AN/top40_complete_080919.csv", header=T)

name_list$has_twitter <- 1
name_list$has_twitter[is.na(name_list$screenName)] <- 0
table(name_list$has_twitter)   ## 0: 560, 1:445

#gender x has_twitter
#table(name_list$has_twitter, name_list$gender)
#chisq.test(name_list$has_twitter, name_list$gender)

#create variable: generation 
#name_list$generation <- NA
#name_list$generation[name_list$job_yr<=2000] <- 1
#name_list$generation[2000<name_list$job_yr & name_list$job_yr<=2010] <- 2
#name_list$generation[2010<name_list$job_yr] <- 3

#generation x has_twitter 
#table(name_list$has_twitter, name_list$generation)
#chisq.test(name_list$has_twitter, name_list$generation)


# generate the data for the basic information for the users themselves

name_list$screenName <- as.character(name_list$screenName)
#name_list$screenName <- gsub(" ", "", name_list$screenName) 

lookup_vector <- vector()
for (i in 1: length(name_list$screenName)) {
  lookup_vector[i] <- lookupUsers(name_list$screenName[i], includeNA=F)
  
}
