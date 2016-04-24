# ui.R

shinyUI(fluidPage(
  titlePanel("SF5 Leaderboard Data"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore the top 500 players on 
        the ranked ladder from sfv.fightinggame.community"),
    
      selectInput("var", 
        label = "Choose a variable to display",
        choices = c("Percent White", "Percent Black",
          "Percent Hispanic", "Percent Asian"),
        selected = "Percent White"),
    
      sliderInput("range", 
        label = "Range of interest:",
        min = 0, max = 100, value = c(0, 100))
    ),
  
    mainPanel(plotOutput("plot"))
  )
))