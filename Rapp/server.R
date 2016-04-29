# server.R

# Ye who enter here: this is my first R programming experience
# so don't expect anything here to be coded well.

library(ggplot2)
library(dplyr)
csv <- read.csv("../csvbuilder/output.csv") %>%
  filter(LP > 7000)
raw <- csv

# Data mangling

# Change region to OTH if total region count is < 5
for (i in 1:length(csv$Region)) { 
  if (sum(csv$Region == csv$Region[i]) < 5) { 
    csv$Region[i] <- "OTH" }
}

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

# Reorder by count function for geom_bar since 
# I guess that's not an option?
reorder_size <- function(x) {
  factor(x, levels = names(sort(table(x))))
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

#ggplot(csv, aes(x = Character, fill = Platform)) + geom_bar(position = "dodge")

shinyServer(function(input, output) {

  output$summary <- renderPlot({
    ggplot(csv, aes(x = Character)) + geom_bar()


  })

  output$text <- renderPrint({
    summary(raw[2:6], maxsum = 20)
  })

#  output$plot <- renderPlot({
#    args <- switch(input$matchplot,
#      "Character Counts" = csv$Character,
#      "Platform Counts" = csv$Platform,
#      "Region Counts" = csv$Region)
#    ggplot(csv) + geom_bar(mapping = aes(args)) + xlab(input$matchplot)
#	})

})