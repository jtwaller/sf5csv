csv$"LP/Game" <- round(csv$LP / csv$Games, 2)

eff <- csv[order(-csv$"LP/Game"),]

# c(player, Char, Eff, (games,lp,region,platform))
efftable <- eff[,c(1,6,44,2:5)]

# character efficiency
chareff <- data.frame(matrix(nrow = length(characters) + 1, ncol = 2))
colnames(chareff) <- c("Character", "LP/Game")
chareff$Character = c("Average", characters)

# There's something I'm not understanding about colSums.
# csv[,2:3] is the columns of Games and LP
# colSums(csv[,2:3]) is possible, but I can't sum one at at time?
# e.g.,
# > colSums(csv$Games)
#   Error in colSums(csv$Games) : 
#   'x' must be an array of at least two dimensions

sums <- colSums(csv[,2:3])
avgeff <- sums[2] / sums[1]

# Set average char efficiency
chareff[1,2] <- avgeff

for (i in 1:length(characters)) {
  tempsums <- colSums(csv[csv$Character == characters[i],2:3])

  # i + 1 to skip Average in character column
  chareff[i + 1, 2] = round(tempsums[2] / tempsums[1], 2)
}

