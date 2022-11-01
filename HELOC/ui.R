#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(plotly)

# Datasets
heloc <- read.csv(
    "HELOC_10042022.csv",
    stringsAsFactors = FALSE
)

panel_1_range <- sliderInput(
    inputId = "p1_range",
    label = "Select the range of HELOC frequency",
    min = 1,
    max = 52000,
    value = c(14, 51023)
)

panel_1_radio_button <- radioButtons(
    inputId = "group_by",
    label = "Display frequency by",
    choiceNames = list(
        "State",
        "County"
    ),
    choiceValues = list(
        "State",
        "CountyName"
    ),
    selected = "State"
)

panel_1_widgets <- sidebarPanel(
    #p("hhh"),
    #br(),
    panel_1_range,
    br(),
    p("Pick a feature you want HELOC frequency to be grouped"),
    panel_1_radio_button
)

panel_1_plot <- mainPanel(
    plotOutput("plot1")
)

panel_1 <- tabPanel(
    "Distribution",
    titlePanel(tags$h1("Distribution")),
    br(),
    sidebarLayout(
        panel_1_widgets,
        panel_1_plot
    )
)


# Panel 1 Widget Creation
panel_2_state_select <- selectInput(
  inputId = "state",
  label = "Choose a state",
  choices = list(
    "AZ" = "AZ",
    "CA" = "CA",
    "ID" = "ID",
    "IL" = "IL",
    "KS" = "KS",
    "MO" = "MO",
    "OR" = "OR",
    "PA" = "PA",
    "SC" = "SC",
    "WA" = "WA"
  ),
  selected = "WA"
)

panel_2_checkbox <- checkboxInput(
  inputId = "all",
  label = strong("Show all states"),
  value = FALSE
)

# palette_picker <- selectInput(
#   inputId = "palette",
#   label = "Pick the Plot's Color Scheme",
#   choices = list(
#     "Pastels" = "Pastel1",
#     "Darks" = "Dark2",
#     "Accents" = "Accent",
#     "Solids" = "Set1"
#   ),
#   selected = "Pastel1"
# )

# Panel 1 Widgets Sidebar Structure
panel_2_widgets <- sidebarPanel(
  # p("hhh"),
  # br(),
  p("Check box to see comparative boxplots"),
  panel_2_checkbox,
  p("Uncheck box to see individual boxplots"),
  br(),
  panel_2_state_select
)


# Panel 222222222 Visual Structure
panel_2_plot <- mainPanel(
  plotlyOutput("plot2")
)

# Panel 1 Final Structure
panel_2 <- tabPanel(
  "Credit Limit",
  titlePanel(tags$h1("Credit Limit by State")),
  br(),
  sidebarLayout(
    panel_2_widgets,
    panel_2_plot
  )
)


panel_3_state_select <- selectInput(
  inputId = "state",
  label = "Choose a state",
  choices = list(
    "AZ" = "AZ",
    "CA" = "CA",
    "ID" = "ID",
    "IL" = "IL",
    "KS" = "KS",
    "MO" = "MO",
    "OR" = "OR",
    "PA" = "PA",
    "SC" = "SC",
    "WA" = "WA"
  ),
  selected = "WA"
)

panel_3_checkbox <- checkboxInput(
  inputId = "all",
  label = strong("Show all states"),
  value = FALSE
)

# Panel 1 Widgets Sidebar Structure
panel_3_widgets <- sidebarPanel(
  p("The portion of the sum of costs"),
  br()
  # p("Check box to see comparative boxplots"),
  # panel_2_checkbox,
  # p("Uncheck box to see individual boxplots"),
  # br(),
  # panel_2_state_select
)


# Panel 1 Visual Structure
panel_3_plot <- mainPanel(
  plotOutput("plot3")
)

# Panel 1 Final Structure
panel_3 <- tabPanel(
  "Costs",
  titlePanel(tags$h1("Costs by State")),
  br(),
  sidebarLayout(
    panel_3_widgets,
    panel_3_plot
  )
)


# Define UI
ui <- fluidPage(
    
    #includeCSS("style.css"),
    navbarPage(
        "HELOC",
        panel_1,
        panel_2,
        panel_3
    )

)
