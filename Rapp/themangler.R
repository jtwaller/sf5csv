# just a couple things to help me test

library(dplyr)

csv <- read.csv("../csvbuilder/output.csv")
ten <- csv[1:10, ]

characters <- c("Alex", "Birdie", "Cammy", "Chun", "Claw", "Dhalsim", "Dictator", "Fang", 
  "Karin", "Ken", "Laura", "Nash", "Necalli", "RMika", "Rashid", "Ryu", "Zangief")
charcount <- 1

# Replace Win% column with total wins and 
# Replace Game Count with total losses
columnstart = match("AlexWin", names(csv))
for (i in columnstart:length(ten)) {
  if (i %% 2 == 0) {
    # Rename Columns
    names(ten)[i] <- paste0(characters[charcount], "Win", sep = '')
    names(ten)[i+1] <- paste0(characters[charcount], "Loss", sep = '')
    # Overwrite values
    ten[i] <- round(ten[i]/100 * ten[i+1]) 
    ten[i+1] <- ten[i+1] - ten[i] 
    charcount <- charcount + 1
  }
}

#print(ten)