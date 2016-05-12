# server.R

# To whom it may concern: this is my first R experience.
# Please do not judge me too harshly.  Hope you like spaghetti.

library(ggplot2)
library(dplyr)
csv <- read.csv("../csvbuilder/output.csv") %>%
  filter(LP > 7000)
raw <- csv

# Data mangling

characters <- c("Alex", "Birdie", "Cammy", "Chun Li", "Claw", "Dhalsim", "Dictator", "Fang", 
  "Guile", "Karin", "Ken", "Laura", "Nash", "Necalli", "R. Mika", "Rashid", "Ryu", "Zangief")

source("summaryplots.R", local = TRUE)
source("matchupplots.R", local = TRUE)

# Change region to OTH if total region count is < 5
#for (i in 1:length(csv$Region)) { 
#  if (sum(csv$Region == csv$Region[i]) < 5) { 
#    csv$Region[i] <- "OTH" }
#}



# Reorder by count function for geom_bar since 
# I guess that's not an option?
reorder_size <- function(x) {
  factor(x, levels = names(sort(table(x))))
}

#ggplot(csv, aes(x = Character, fill = Platform)) + geom_bar(position = "dodge")

shinyServer(function(input, output) {

  output$summary1 <- renderPlot({
    args <- switch(input$regionrates,
      "Overall" = ggplot(Overall, aes(x = Character, y = Frequency,
      	  fill = Character)) + geom_bar(stat = "identity") + guides(fill = FALSE),
      "PSN vs. Steam" = ggplot(PSN, aes(x = Character, y = Frequency,
      	  fill = Platform)) + geom_bar(position = "dodge", stat = "identity"),
      "JPN vs USA" = ggplot(JPUS, aes(x = Character, y = Frequency,
      	  fill = Region)) + geom_bar(position = "dodge", stat = "identity"),
      "JPN vs Other" = ggplot(notJPN, aes(x = Character, y = Frequency,
      	  fill = Region)) + geom_bar(position = "dodge", stat = "identity"),
      "USA vs Other" = ggplot(notUSA, aes(x = Character, y = Frequency,
      	  fill = Region)) + geom_bar(position = "dodge", stat = "identity")
    )

    args + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

  })	

  output$summary2 <- renderPlot({
    ggplot(csv, aes(x = Character, y = LP, fill = Character)) +
      stat_summary(fun.y = "mean", geom = "bar") + guides(fill = FALSE) +
      coord_cartesian(ylim = c(8000, 9500))
      theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))

  })

  output$matchup <- renderPlot({
    charspicked <- input$charchoice
    
    if (input$matchplot == "Matchup Winrates") {
      if (length(charspicked) != 0) { 
        ggplot(matchdf, aes(x = Opponent, y = Winrate, group = 1)) + 
        geom_point() + 
        geom_point(data = matchdf[matchdf$Character %in% charspicked,], 
        	aes(color = Character, shape = Character, size = 15)) +
        	guides(size = FALSE) +
        theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
      }
	  else {
        ggplot(matchdf, aes(x = Opponent, y = Winrate, color = Character, group = 1)) + 
          geom_point() +
          theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
	  }
	}
	else {
	  ggplot(archdf, aes(x = Opponent, y = Winrate, group = 1)) + 
          geom_point(data = matchdf) +
          geom_point(aes(color = Archetype, , shape = Archetype, size = 20)) +
          guides(size = FALSE) +
          theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
	}

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