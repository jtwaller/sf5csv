# Overall
temp <- summary(csv$Character)
Overall <- data.frame(Character = names(temp), Count = temp, row.names = NULL)
Overall$Frequency <- Overall$Count / sum(Overall$Count)

# For below: maybe a cleaner way?  Hard to get frequencies right
# in the final geom_bar(position = "dodge") plot.
# The way I'm doing it here calculates the freqencies
# seperately first them combines into one data frame

# PSN vs. Steam

temp <- summary(csv[csv$Platform == "PSN", ]$Character)
# row.names = NULL to prevent conflict during later rbind
PSN <- data.frame(Character = names(temp), Count = temp, row.names = NULL)
PSN$Platform <- "PSN"
PSN$Frequency <- PSN$Count / sum(PSN$Count)

temp <- summary(csv[csv$Platform == "STEAM", ]$Character)
temp <- data.frame(Character = names(temp), Count = temp)
# Have to calculate frequencies seperately so both sets sum to 1
temp$Frequency <- temp$Count / sum(temp$Count)
temp$Platform <- "Steam"

PSN <- rbind(PSN, temp)

# JP vs US
temp <- summary(csv[csv$Region == "JPN", ]$Character)
JPUS <- data.frame(Character = names(temp), Count = temp, row.names = NULL)
JPUS$Region <- "JPN"
JPUS$Frequency <- JPUS$Count / sum(JPUS$Count)

temp <- summary(csv[csv$Region == "USA", ]$Character)
temp <- data.frame(Character = names(temp), Count = temp)
temp$Frequency <- temp$Count / sum(temp$Count)
temp$Region <- "USA"

JPUS <- rbind(JPUS, temp)

# "(JPN/USA) vs. Overall"

# notUSA
temp <- summary(csv[csv$Region != "USA", ]$Character)
notUSA <- data.frame(Character = names(temp), Count = temp, row.names = NULL)
notUSA$Region <- "Other"
notUSA$Frequency <- notUSA$Count / sum(notUSA$Count)

temp <- summary(csv[csv$Region == "USA", ]$Character)
temp <- data.frame(Character = names(temp), Count = temp)
temp$Frequency <- temp$Count / sum(temp$Count)
temp$Region <- "USA"

notUSA <- rbind(notUSA, temp)

# notJPN
temp <- summary(csv[csv$Region != "JPN", ]$Character)
# row.names = NULL to prevent conflict during later rbind
notJPN <- data.frame(Character = names(temp), Count = temp, row.names = NULL)
notJPN$Region <- "Other"
notJPN$Frequency <- notJPN$Count / sum(notJPN$Count)

temp <- summary(csv[csv$Region == "JPN", ]$Character)
temp <- data.frame(Character = names(temp), Count = temp)
# Have to calculate frequencies seperately so both sets sum to 1
temp$Frequency <- temp$Count / sum(temp$Count)
temp$Region <- "JPN"

notJPN <- rbind(notJPN, temp)
