#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(plotly)


# Define UI for application that draws a histogram
# shinyUI(fluidPage(
# 
#  # br(),
#   #column(8,leafletOutput("map", height="600px")),
#   #plotOutput("plot", height="300px")),
#   #br()
#   titlePanel("Find a spot for Winter vacation"),
#   sidebarLayout(
#     sidebarPanel(
#       h1("Click on the marker to find Snow accumulations"),
#       leafletOutput("map", height="600px")
#       ),
#     mainPanel(
#       h3("Snow accumucations statistics"),
#       textOutput("text"),
#             plotOutput("plot")
#     )
#   )
# 
# ))


ui <- fluidPage(
  h1("Decide your snowy spot"),
  p("The map below shows locations where annual snow accumulation is over 50 inches. Click on the location to find monthly totals, so you can make your winter vacation plans!!!!"),
  br(),
  column(12,leafletOutput("map", height="600px")),
  column(12,br(),br(),br(),br(),plotlyOutput("plot", height="300px")),
  br()
)


# ui <- bootstrapPage(
#   tags$style(type="text/css", "html, body {width:100%;height:100%}"),
#   leafletOutput("map", width="100%", height="100%"),
#   absolutePanel(top=10, right=10,
#                 selectInput("location", "Community", c("", locs$loc), selected=""),
#                 conditionalPanel("input.location !== null && input.location !== ''",
#                                  actionButton("button_plot_and_table", "View Plot/Table", class="btn-block"))
#   )
# )
