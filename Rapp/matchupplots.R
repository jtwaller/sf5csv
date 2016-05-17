# Replace Win% column with total wins and 
# replace Game Count with total losses

charcount <- 1

# Per character wins and losses derived from win% and total games

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

# There has to be a better way to do this?
# As is, make a temp vector of col titles, make a no-data frame,
# Then colname the vector into the column titles

temp = c("Character", names(csv[8:length(csv)])) # Character, Alexwin... ZangiefLoss
charsums <- data.frame(matrix(ncol = length(temp), nrow = length(characters)))
colnames(charsums) <- temp

# This doesn't seem right... colSums and filters seems cleaner
# Refer to *Abomination Solution* below
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
    # matchdf[character,winrate] <- opponentwin/opponenttotalgame
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

library(reshape)
# http://www.ats.ucla.edu/stat/r/faq/reshape.htm
matchdf <- reshape(matchdf, 
  varying = colnames(matchdf[2:length(matchdf)]),
  v.names = "Winrate",
  timevar = "Opponent",
  times = colnames(matchdf[2:length(matchdf)]),
  direction = "long",
  new.row.names = 1:1000)

# Archetype plots

archetypes <- c("Command Grabbers", "Fireballers", "Grapplers")
cmdgrab <- c("Alex", "Birdie", "Claw", "Laura", "Necalli", "R. Mika", "Zangief")
fireball <- c("Chun Li", "Dhalsim", "Fang", "Guile", "Ken", "Nash", "Rashid", "Ryu")
grappler <- c("Alex", "Birdie", "Laura", "R. Mika", "Zangief")

temp <- c("Archetype", names(csv[8:length(csv)])) # Character, Alexwin... ZangiefLoss
archsums <- data.frame(matrix(ncol = length(temp), nrow = length(archetypes)))
colnames(archsums) <- temp

# *Abomination solution*
archsums[1,] <- c(archetypes[1], colSums(charsums[charsums$Character %in% cmdgrab, 2:length(charsums)])) 
archsums[2,] <- c(archetypes[2], colSums(charsums[charsums$Character %in% fireball, 2:length(charsums)])) 
archsums[3,] <- c(archetypes[3], colSums(charsums[charsums$Character %in% grappler, 2:length(charsums)])) 

archdf <- data.frame(matrix(ncol = length(characters) + 1, nrow = length(archetypes)))
colnames(archdf) <- c("Archetype", characters)
for (i in 1:length(archetypes)) {
  archdf[i,1] <- archetypes[i]
  for (j in 1:length(characters)) {
    # archdf[archetype,winrate] <- opponentwin/opponenttotalgame
    # don't really know why I need to cast as.numeric here... from colSums?
    archdf[i,j + 1] <- as.numeric(archsums[i,j*2]) / (as.numeric(archsums[i,j*2]) + as.numeric(archsums[i,j*2 + 1]))
  }
}

# Remove spaces from matchdf column names
colnames(archdf) <- gsub(" ", "", colnames(archdf))
archdf <- reshape(archdf, 
  varying = colnames(archdf[2:length(archdf)]),
  v.names = "Winrate",
  timevar = "Opponent",
  times = colnames(archdf[2:length(archdf)]),
  direction = "long",
  new.row.names = 1:1000)