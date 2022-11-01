#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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

# Server
server <- function(input, output) {

    # output$distPlot <- renderPlot({
    # 
    #     # generate bins based on input$bins from ui.R
    #     x    <- heloc$Cost
    #     bins <- seq(min(x), max(x), length.out = input$bins + 1)
    # 
    #     # draw the histogram with the specified number of bins
    #     hist(x, breaks = bins, col = 'darkgray', border = 'white')
    # 
    # })
    output$plot1 <- renderPlot({
        # # Choose if want the color displayed by states
        # if (input$color_by_state == TRUE) {
        #     plot1 <- ggplot(midwest, aes(color = state))
        # } else {
        #     plot1 <- ggplot(midwest)
        # }
        # Add the points to the plot and labels of axis
        heloc2 <- heloc %>%
            group_by(!!as.name(input$group_by)) %>%
            summarize(Frequency = n()) %>%
            arrange(-Frequency)
        
        graph_data <- heloc2 %>%
            filter(Frequency >= input$p1_range[1], Frequency <= input$p1_range[2])
        
        plot1 <- ggplot(
            graph_data,
            aes(
                x = reorder(!!as.name(input$group_by), -Frequency),
                y = Frequency
                )
            ) + 
            geom_bar(
                stat = "identity",
                show.legend = FALSE,
                fill = "#56B4E9" # sky blue
            ) +
            geom_text(aes(label = Frequency), 
                      vjust = -0.5, colour = "blue") +
            labs(
                x = input$group_by,
                y = "Frequency",
                title = "Regions of HELOC"
            ) + # adjust the angle of the x-axis labels and to center the title.
            theme(axis.text.x = element_text(angle = 90)) +
            theme(plot.title = element_text(hjust = 0.5))
        plot1
    })
    
    output$plot2 <- renderPlotly({
      # # Function for dataframe cleaning
      # string_extractor <- function(x, n) {
      #   substr(x, nchar(x) - n + 1, nchar(x))
      # }
      # # Dataframe cleaning
      # usable_ages <- demo_data %>%
      #   mutate(
      #     bday_year = sapply(demo_data$date_of_birth, string_extractor, n = 4)
      #   ) %>%
      #   mutate(
      #     bday_year = gsub(".*-", "19", bday_year)
      #   ) %>%
      #   mutate(
      #     age_at_award = suppressWarnings(
      #       as.numeric(year_of_award) - as.numeric(bday_year)
      #     )
      #   )
      # Removal of NA values
      heloc3 <- heloc[!is.na(heloc$creditlimit), ]
      # Filter data if checkbox is false
      if (input$all == FALSE) {
        heloc3 <- heloc3 %>%
          filter(
            State == input$state
          )
      }
      # Plotting
      ggplot(heloc3) +
        geom_boxplot(
          mapping = aes(
            x = State,
            y = creditlimit,
            fill = State
          ),
          outlier.colour = "black",
          show.legend = FALSE
        ) +
        labs(
          title = "Credit Limit by State",
          x = "State",
          y = "Credit Limit"
        ) +
        scale_fill_brewer(palette = "Pastel1") +
        theme(plot.title = element_text(hjust = 0.5))
    })
    
    output$plot3 <- renderPlot({
      
      # # Choose if want the color displayed by states
      # if (input$color_by_state == TRUE) {
      #     plot1 <- ggplot(midwest, aes(color = state))
      # } else {
      #     plot1 <- ggplot(midwest)
      # }
      
      heloc4 <- heloc %>%
        group_by(State) %>%
        summarize(sum_cost = sum(Cost))
      
      # Compute percentages
      heloc4$fraction = heloc4$sum_cost / sum(heloc4$sum_cost)
      
      # Compute the cumulative percentages (top of each rectangle)
      heloc4$ymax = cumsum(heloc4$fraction)
      
      # Compute the bottom of each rectangle
      heloc4$ymin = c(0, head(heloc4$ymax, n=-1))
      
      # Make the plot
      plot3 <- ggplot(heloc4, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=State)) +
        geom_rect() +
        coord_polar(theta="y") + # Try to remove that to understand how the chart is built initially
        xlim(c(2, 4))
      plot3
    })
    
}




