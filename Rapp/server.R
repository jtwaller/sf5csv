# server.R

library(ggplot2)

data <- read.csv("../csvbuilder/output.csv")

shinyServer(function(input, output) {
	output$plot <- renderPlot({
		ggplot(data) + geom_bar(mapping = aes(x = "Character"))
	})
})