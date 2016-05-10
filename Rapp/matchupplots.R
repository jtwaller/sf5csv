# Replace Win% column with total wins and 
# replace Game Count with total losses
characters <- c("Alex", "Birdie", "Cammy", "Chun Li", "Claw", "Dhalsim", "Dictator", "Fang", 
  "Karin", "Ken", "Laura", "Nash", "Necalli", "R. Mika", "Rashid", "Ryu", "Zangief")
charcount <- 1

columnstart = match("AlexWin", names(csv))
for (i in columnstart:length(csv)) {
  if (i %% 2 == 0) {
    # Rename columns
    names(csv)[i] <- paste0(characters[charcount], "Win", sep = '')
    names(csv)[i+1] <- paste0(characters[charcount], "Loss", sep = '')
    # Overwrite values
    csv[i] <- round(csv[i]/100 * csv[i+1]) 
    csv[i+1] <- csv[i+1] - csv[i]
    charcount <- charcount + 1
  }
}

# Per character stats
# There has to be a better way to do this?
# As is, make a temp vector of col titles, make a no-data frame,
# Then colname the vector into the column titles

temp = c("Character", names(csv[8:length(csv)])) # Character, Alexwin... ZangiefLoss
charsums <- data.frame(matrix(ncol = length(temp), nrow = length(characters)))
colnames(charsums) <- temp

# Again, there must be a much better way here
for (i in 1:length(characters)) {
  charsums$Character[i] <- characters[i] #set character names
  tempdf <- filter(csv, Character == characters[i]) #temp frame for each char
  for (j in 8:length(csv)) {
    charsums[i,j-6] <- sum(tempdf[j]) # sum the columns 1 by 1 and assign
  }
}

matchdf <- data.frame(matrix(ncol = length(characters) + 1, nrow = length(characters)))
colnames(matchdf) <- c("Character", characters)
for (i in 1:length(characters)) {
  matchdf[i,1] <- characters[i]
  for (j in 1:length(characters)) {
    # matchdf[character,winrate] <- charsums(character,characterwin/charactertotalgame)
    matchdf[i,j + 1] <- charsums[i,j*2] / (charsums[i,j*2] + charsums[i,j*2 + 1])
  }
}

# Remove spaces from matchdf column names
colnames(matchdf) <- gsub(" ", "", colnames(matchdf))

# So I guess you can't have a data frame like so:
#       alex  birdie  chun
# obs1  value  value  value
# obs2  value  value  value
# obs3  value  value  value

# To make your data play nicely with ggplot I guess you have to reshape to

# character playedagainst winrate
# obs1      alex          value
# obs1      birdie        value
# obs1      chun          value
# ...
# obs2
# obs2
# obs2

# ggplot(matchdf, aes(x = playedagainst, y = winrate)) + geom_line()

# this seems a bit ridiculous to me so I must be missing something
# but I've spent too long trying to plot my original dataframe
# so I'm just gonna reshape the thing and get it over with.

library(reshape)
# http://www.ats.ucla.edu/stat/r/faq/reshape.htm
matchdf <- reshape(matchdf, 
  varying = colnames(matchdf[2:length(matchdf)]),
  v.names = "Winrate",
  timevar = "Opponent",
  times = colnames(matchdf[2:length(matchdf)]),
  direction = "long",
  new.row.names = 1:1000)

# matchdf[which(temp$Character == "Alex"), ]

# ggplot(temp[which(temp$Character == "Alex"), ], aes(x = Opponent, y = Winrate, group = 1)) + geom_point(stat = "identity")

# ggplot(matchdf, aes(x = Opponent, y = Winrate, color = Character, group = 1)) + geom_point(stat = "identity")

