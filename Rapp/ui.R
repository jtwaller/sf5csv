# ui.R

shinyUI(fluidPage(
  titlePanel("SF5 Leaderboard Data"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Explore the top 500 players on 
        the ranked ladder from sfv.fightinggame.community"),
    
      selectInput("choose",
      	label = "Choose Your Destiny:",
      	choices = c("Summary Plots", "Matchup Plots", "Efficiency", "Text Reports")),
    
    # Summary Plots
      conditionalPanel("input.choose == 'Summary Plots'",
        selectInput("summarychoice", label = NULL,
          choices = c("Character Played Rates",
          "Average LP per Character"), selected = "One"), 

        # Radio Buttons Panel
        conditionalPanel("input.summarychoice == 'Character Played Rates'",
          radioButtons("charplayedrates", label = NULL,
            choices = c("Overall", "PSN vs. Steam", "JPN vs USA",
          	"JPN vs Overall", "USA vs Overall"))
        )
      ),

    # Matchup Plots
      conditionalPanel("input.choose == 'Matchup Plots'",
        selectInput("matchplot", label = NULL,
          choices = c("Matchup Winrates", "Matchup Totals",
          "Archetype Winrates", "Archetype Totals"), selected = "Matchup Winrates"),
        conditionalPanel("input.matchplot == 'Matchup Winrates' | input.matchplot == 'Matchup Totals'",
          selectInput("charchoice", label = NULL, choices = c("Alex", "Birdie",
          	"Cammy", "Chun Li", "Claw", "Dhalsim", "Dictator", "Fang", "Karin",
          	"Ken", "Laura", "Nash", "Necalli", "R. Mika", "Rashid", "Ryu", "Zangief"))
        ),
        conditionalPanel("input.matchplot == 'Archetype Winrates' | input.matchplot == 'Archetype Totals'",
          selectInput("archchoice", label = NULL, choices = c("Command Grabbers",
          	"Fireballers", "Grapplers")),
          helpText("Command Grabbers: Alex, Birdie, Claw, Laura, Necalli, RMika, Zangief.",  
            tags$br(), tags$br(), "Fireballers: Chun, Dhalsim, Fang, Ken, Nash, Rashid, Ryu.",
            tags$br(), tags$br(), "Grapplers: Alex, Birdie, Laura, RMika, Zangief")
        )
      ),

    # Efficiency
      conditionalPanel("input.choose == 'Efficiency'",
        selectInput("effchoice", label = NULL,
          choices = c("Most Efficient Players", "Least Efficient Players",
          "Character Efficiency"), selected = "Most Efficient Players")
      )

    # Text Reports (no panel needed I think, just fill up main panel)
    ),

    mainPanel(
      conditionalPanel("input.choose == 'Summary Plots'",
        plotOutput("summary") ),
      conditionalPanel("input.choose == 'Matchup Plots'",
        plotOutput("matchup") ),
      conditionalPanel("input.choose == 'Efficiency'",
        plotOutput("efficiency") ),
      conditionalPanel("input.choose == 'Text Reports'",
        verbatimTextOutput("text") )
    )
  )
))