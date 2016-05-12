# ui.R

# multi column input for the matchup checkboxes
# http://stackoverflow.com/questions/29738975/how-to-align-a-group-of-checkboxgroupinput-in-r-shiny

tweaks <- 
  list(tags$head(tags$style(HTML("
	.multicol { 
	  height: 230px;
	  -webkit-column-count: 2; /* Chrome, Safari, Opera */ 
	  -moz-column-count: 2;    /* Firefox */ 
	  column-count: 2; 
	  -moz-column-fill: auto;
	  -column-fill: auto;
	} 
	")) 
	))

# Temp hack... copying from server.R.  Maybe put in global.R?
characters <- c("Alex", "Birdie", "Cammy", "Chun Li", "Claw", "Dhalsim", "Dictator", "Fang", 
  "Guile", "Karin", "Ken", "Laura", "Nash", "Necalli", "R. Mika", "Rashid", "Ryu", "Zangief")

matchcontrols <-
  list(tags$div(
  	align = 'left', 
    class = 'multicol',
    checkboxGroupInput("charchoice", label = NULL,
      choices = characters[1:length(characters)], inline = FALSE)))

shinyUI(fluidPage(tweaks,
  titlePanel("SF5 Leaderboard Data"),
  
  sidebarLayout(
    sidebarPanel(
      strong("MOBILE USERS!  Please view in landscape mode"),
      helpText("Explore the top 500 players on 
        the ranked ladder from sfv.fightinggame.community"),

      selectInput("choose",
      	label = "Choose Your Destiny:",
      	choices = c("Summary Plots", "Matchup Plots", "Efficiency", "Text Reports")),
    
    # Summary Plots
      conditionalPanel("input.choose == 'Summary Plots'",
        selectInput("summarychoice", label = NULL,
          choices = c("Character Played Rates",
          "Average LP per Character") ), 

        # Radio Buttons Panel
        conditionalPanel("input.summarychoice == 'Character Played Rates'",
          radioButtons("regionrates", label = NULL,
            choices = c("Overall", "PSN vs. Steam", "JPN vs USA",
          	"JPN vs Other", "USA vs Other") )
        )
      ),

    # Matchup Plots
      conditionalPanel("input.choose == 'Matchup Plots'",
        selectInput("matchplot", label = NULL,
          choices = c("Matchup Winrates", 
          "Archetype Winrates"), selected = "Matchup Winrates"),
        conditionalPanel("input.matchplot == 'Matchup Winrates'",
          h3("Highlight Character:"),
          matchcontrols, # how the hell do I get these columns to align?
          helpText("The Guile outlier is Infiltration.  He's the only player with Guile as most played."),  
          helpText("As of May 11, he is 229-0 with Guile")
        ),
        conditionalPanel("input.matchplot == 'Archetype Winrates'",
          helpText("Command Grabbers: Alex, Birdie, Claw, Laura, Necalli, RMika, Zangief.",  
            tags$br(), tags$br(), "Fireballers: Chun, Dhalsim, Fang, Guile, Ken, Nash, Rashid, Ryu.",
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
      conditionalPanel("input.choose == 'Summary Plots' & 
      	input.summarychoice == 'Character Played Rates'",
        plotOutput("summary1") ),

      conditionalPanel("input.choose == 'Summary Plots' & 
      	input.summarychoice == 'Average LP per Character'",
        plotOutput("summary2") ),
      
      conditionalPanel("input.choose == 'Matchup Plots'",
        plotOutput("matchup") ),
      
      conditionalPanel("input.choose == 'Efficiency'",
        plotOutput("efficiency") ),
      
      conditionalPanel("input.choose == 'Text Reports'",
        verbatimTextOutput("text") )
    )
  )
))