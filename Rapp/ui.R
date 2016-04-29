# ui.R

shinyUI(fluidPage(
  titlePanel("SF5 Leaderboard Data"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore the top 500 players on 
        the ranked ladder from sfv.fightinggame.community"),
    
      selectInput("choose",
      	label = "What're ya buyin?",
      	choices = c("Summary", "ggplot")),
    
      conditionalPanel("input.choose == 'ggplot'",
        selectInput("var", 
          label = "What're ya plottin?",
          choices = c("Character Counts", "Platform Counts",
            "Region Counts"),
          selected = "Character Counts") )
    ),
  
    mainPanel(
      conditionalPanel("input.choose == 'Summary'",
        verbatimTextOutput("summary") ),
      conditionalPanel("input.choose == 'ggplot'",
        plotOutput("plot") )
    )
  )
))