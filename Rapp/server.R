# server.R

library(ggplot2)
csv <- read.csv("../csvbuilder/output.csv")

# Change region to OTH if total region count is < 5
for (i in 1:length(csv$Region)) { 
	if (sum(csv$Region == csv$Region[i]) < 5) { 
		csv$Region[i] <- "OTH" }
	}

# Reorder by count function for geom_bar since 
# I guess that's not an option?
reorder_size <- function(x) {
	factor(x, levels = names(sort(table(x))))
}

shinyServer(function(input, output) {
	output$plot <- renderPlot({
		args <- switch(input$var,
			"Character Counts" = csv$Character,
			"Platform Counts" = csv$Platform,
			"Region Counts" = csv$Region)

		ggplot(csv) + geom_bar(mapping = aes(reorder_size(args)))
	})
})