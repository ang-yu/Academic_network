# see overlapping between Hannah's and Top 40 sociologist list
# latest update: 08112019

setwd("~/Library/Mobile Documents/com~apple~CloudDocs/.Trash/Master Jihye/USC/Summer 2019/SICSS UCLA/group project")

library(haven)
hannah <- read_dta("SocData_for_sharing.dta")
hannah <- hannah[order(hannah$name),]
top40 <- read.csv("Top 40 Faculty List 2019 ASA Guide.csv")
top40 <- top40[, c(1:3)]
top40 <- top40[order(top40$Faculty.Name),]
top40 <- top40[!is.na(top40$ID),]

overlap1 <- hannah[hannah$name %in% top40$Faculty.Name,]
overlap2 <- hannah[top40$Faculty.Name %in% hannah$name,]
merge1 <- merge(hannah, top40, by.x = c("name"), by.y = c("Faculty.Name"), all = T)
bothoverlap <- merge1[!(is.na(merge1$cid)|is.na(merge1$ID)),]

write.csv(bothoverlap, "overlap.csv", row.names = F)

