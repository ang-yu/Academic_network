library("twitteR")
library("wordcloud")
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


name_list <- read.csv("~/Downloads/Academic Network/AP name list.xlsx - Warren AP Data.csv", header=T)
name_list$uncertain[is.na(name_list$uncertain)] <- 0
name_list$private.account[is.na(name_list$private.account)] <- 0

name_list$has_twitter <- NA
name_list$has_twitter[!is.na(name_list$twitter_username)] <- 1
name_list$has_twitter[is.na(name_list$twitter_username)] <- 0
table(name_list$has_twitter)
table(name_list$has_twitter, name_list$gender)
chisq.test(name_list$has_twitter, name_list$gender)

# (I added the following—Weijun)
#create variable: generation 
name_list$generation <- NA
name_list$generation[name_list$job_yr<=2000] <- 1
name_list$generation[2000<name_list$job_yr & name_list$job_yr<=2010] <- 2
name_list$generation[2010<name_list$job_yr] <- 3

#generation x has_twitter 
table(name_list$has_twitter, name_list$generation)
chisq.test(name_list$has_twitter, name_list$generation)
    #X-squared = 23.295, df = 2, p-value = 8.739e-06

#create twitter_list
twitter_list <- name_list[!is.na(name_list$twitter_username) & name_list$uncertain==0 & name_list$private.account==0,]


# generate the data for the basic information for the users themselves

twitter_list$twitter_username <- as.character(twitter_list$twitter_username)
twitter_list$twitter_username <- gsub(" ", "", twitter_list$twitter_username) 

lookup_vector <- vector()
for (i in 1: length(twitter_list$twitter_username)) {
  
  lookup_vector[i] <- lookupUsers(twitter_list$twitter_username[i], includeNA=F)
  
}

followersCount <- vector()
friendsCount <- vector()
created <- vector()
description <- vector()
id <- vector()
lastStatus_created <- vector()
name <- vector()
location <- vector()
screenName <- vector()
for (i in 1: length(lookup_vector)) {
  
  followersCount[i] <- lookup_vector[[i]]$followersCount
  friendsCount[i] <- lookup_vector[[i]]$friendsCount
  created[i] <- as.character(as.Date(lookup_vector[[i]]$created))
  description[i] <- lookup_vector[[i]]$description
  id[i] <- lookup_vector[[i]]$id
  name[i] <- lookup_vector[[i]]$name
  location[i] <- lookup_vector[[i]]$location
  screenName[i] <- lookup_vector[[i]]$screenName
  
  # There are people who haven't tweeted anything, lastStatus_created will be NAs for them
  lastStatus_created[i] <- ifelse(!is.null(lookup_vector[[i]]$lastStatus$created), as.character(as.Date(lookup_vector[[i]]$lastStatus$created)), NA)

}

self_data <- as.data.frame(cbind(id, screenName, name, followersCount, friendsCount, created, description, lastStatus_created, location))
self_data$created <- as.Date(self_data$created)
self_data$lastStatus_created <- as.Date(self_data$lastStatus_created)


self_data_merged <- merge(self_data, twitter_list, by.x = "screenName", by.y = "twitter_username", all = T)
self_data_merged$followersCount <- as.numeric(as.character(self_data_merged$followersCount))
self_data_merged$friendsCount <- as.numeric(as.character(self_data_merged$friendsCount))

self_data_merged$active <- ifelse(substr(self_data_merged$lastStatus_created, 1, 4)==2019, 1, 0)
self_data_merged$active[is.na(self_data_merged$active)] <- 0   # for those who haven't tweeted ever
table(self_data_merged$active)


# gender inequality in # of followers
table(self_data_merged$gender)
t.test(self_data_merged$followersCount[self_data_merged$gender=="F"], self_data_merged$followersCount[self_data_merged$gender=="M"])


# asymmetric recognition ratio
self_data_merged$ratio <- self_data_merged$followersCount/self_data_merged$friendsCount
self_data_merged$ratio[self_data_merged$ratio==Inf] <- NA
t.test(self_data_merged$ratio[self_data_merged$gender=="F"], self_data_merged$ratio[self_data_merged$gender=="M"])

# asymmetric recognition ratio among active users
t.test(self_data_merged$ratio[self_data_merged$gender=="F" & self_data_merged$active==1], self_data_merged$ratio[self_data_merged$gender=="M" & self_data_merged$active==1])


# generational inequality in x followers  G1 vs G3
t.test(self_data_merged$followersCount[name_list$generation==1], self_data_merged$followersCount[name_list$generation==3])
      #t = -1.0405, df = 94.888, p-value = 0.3007


#Get friend list
install.packages('here')
install.packages("readr")
library(here)
library(readr)

#for all 136 faculty in the dataset get friends
friends <- list()
for (a in 1:length(id)){
  friends[[a]] <- get_friends(id[a], retryonratelimit = T)
}

# Combine data tables in list
friends <- bind_rows(friends) %>% 
  rename(friend = user_id)

write_csv(friends, here("twitter_friends.csv"))


#for all 136 faculty in the dataset get followers
followers <- list()
for (a in 1:length(id)){
  followers[[a]] <- get_followers(id[a], retryonratelimit = T)
  followers[[a]][2] <-  id[a]
}

# Combine data tables in list
followers <- bind_rows(followers) %>% 
  rename(follower = user_id) %>%
  rename(user=V2)
  
write_csv(followers, here("twitter_follower.csv"))

#import academic_followers and see the unique names
academic_followers <-read.csv("/Users/Ginger/academic_followers.csv", header=T) 
library(dplyr)
unique <- tapply(academic_followers$follower, academic_followers$user, FUN = function(x) length(unique(x)))

####Friends Networks Graph####
#import friends list
friends <-read.csv("/Users/Ginger/friends.csv", header=T)

# Select friends of sociology (06272019 10:33am friends_list)
friends_sociology <- friends[friends$user_id %in% friends$user,]

write_csv(friends_sociology, here("soc_friends.csv"))

# merge network data and gender attribute
soc_friends <- merge(friends_sociology, self_data_merged, by.x = "user", by.y = "id", all=T)
view(soc_friends)

write.csv(soc_friends,here("soc_friends_gender.csv"))

#looking for reciprical ties
#soc_friends$ab <- paste(soc_friends$user, soc_friends$user_id, sep = "-")
#soc_friends$ba <- paste(soc_friends$user_id, soc_friends$user, sep = "-")
#soc_friends$mutual <- ifelse(soc_friends$ba %in% soc_friends$ab, 1, 0)

library(tidyverse)
edge_list <- tibble(from = c(soc_friends$user), to = c(soc_friends$user_id))
node_list <- tibble(id= soc_friends$user, soc_friends$gender)
colnames(node_list)[2] <- "gender"
colnames(node_list)[1] <- "name"

#edge_list delete "938906192981757952"
#edge_list <- edge_list[!(edge_list$to=="938906192981757952"),]
#view(edge_list)

node_list <- unique(node_list)
head(edge_list)
head(node_list)

sum(!(edge_list$from %in% node_list$name))
sum(!(edge_list$to %in% node_list$name))

edge_list$to[!(edge_list$to %in% node_list$name)] # what is this for?

node_list$id # what is this for?

# comment on July 31, 2019: may need to drop some in edge_list$to if edge_list$to is not in node_list$name

#creating igraph objects
#recode gender "M" = 1, "F" = 2
node_list <- node_list %>%
  mutate(gender.r = recode(gender,"M" = 1, "F" = 2))

View(node_list)

library('igraph')
net <- graph_from_data_frame(d=edge_list, vertices=unique(node_list), directed=T) 
net

E(net)       # The edges of the "net" object
V(net)       # The vertices of the "net" object
V(net)$gender # Vertex attribute "gender"

# Get an edge list or a matrix:
#as_edgelist(net, names=T)
#as_adjacency_matrix(net)

# Or data frames describing nodes and edges:
#as_data_frame(net, what="edges")
#as_data_frame(net, what="vertices")

#plotting

# Generate colors based on gender:
colrs <- c("gold", "tomato")   #Male:gold; Female:tomato
V(net)$color <- colrs[V(net)$gender.r]

# The labels are currently node IDs.
# Setting them to NA will render no labels:
V(net)$label <- NA
V(net)$size <- 5

#change arrow size and edge color:
E(net)$arrow.size <- .1
E(net)$edge.color <- "black"
E(net)$edge.size <- .1

#set the network layout: mds
graph_attr(net, "layout") <- layout_with_mds
plot(net) 

legend(x=-1.5, y=-1.1, c("Male","Female"), pch=21,
       col="#777777", pt.bg=colrs, pt.cex=2, cex=.8, bty="n", ncol=1)
