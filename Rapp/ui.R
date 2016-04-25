# ui.R

shinyUI(fluidPage(
  titlePanel("SF5 Leaderboard Data"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore the top 500 players on 
        the ranked ladder from sfv.fightinggame.community"),
    
      selectInput("var", 
        label = "Choose which chart to display",
        choices = c("Character Counts", "Platform Counts",
          "Region Counts"),
        selected = "Character Counts")
    ),
  
    mainPanel(plotOutput("plot"))
  )
))