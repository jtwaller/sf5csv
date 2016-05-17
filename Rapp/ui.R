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
      helpText("Also if anyone knows how to disable the virtual keyboard
      	on mobile devices please let me know."),
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
          matchcontrols # how the hell do I get these columns to align?
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
          choices = c("Player Efficiency", "Character Efficiency"), 
            selected = "Player Efficiency")
      ),

    # Text Reports (no panel needed I think, just fill up main panel)
    
    helpText("As of May 16, only 3 players main Guile, one of which 
    	is Infiltration.  Expect unusual results."),
    helpText(
      a("Source Code", href="https://github.com/jtwaller/sf5csv", target="_blank"),
      br(),
      "Email:", a("ucdwaller@gmail.com", href="mailto:ucdwaller@gmail.com")
    )
    ),

    mainPanel(
      conditionalPanel("input.choose == 'Summary Plots' & 
      	input.summarychoice == 'Character Played Rates'",
        plotOutput("summary1") ),

      conditionalPanel("input.choose == 'Summary Plots' & 
      	input.summarychoice == 'Average LP per Character'",
        plotOutput("summary2") ),
      
      conditionalPanel("input.choose == 'Matchup Plots'",
        titlePanel("Please use the checkboxes to filter characters."),
        plotOutput("matchup") ),
      
      conditionalPanel("input.choose == 'Efficiency' &
      	input.effchoice == 'Player Efficiency'",
      	fluidRow( 
      	  selectInput("charfilter", "Character Filter:", c("All", characters))
      	),
      	fluidRow(DT::dataTableOutput("efficiency1") )
      ),

      conditionalPanel("input.choose == 'Efficiency' &
      	input.effchoice == 'Character Efficiency'",
        plotOutput("efficiency2") ),
      
      conditionalPanel("input.choose == 'Text Reports'",
        verbatimTextOutput("text") )
    )
  )
))