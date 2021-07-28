#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(rtweet)
library(shinycustomloader)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel(title=h4("Olympic Twitter Data", align="center")),

    mainPanel(
      tabsetPanel(
        tabPanel("Sentiment", withLoader(plotOutput("plotSent"), type="image", loader="https://cdn.dribbble.com/users/908372/screenshots/4812323/loading2.gif")),
        tabPanel("Frequency", withLoader(plotOutput("plotFreq"), type="image", loader="https://thumbs.gfycat.com/YellowishElementaryHind-max-1mb.gif"))
      )
    ))
)
