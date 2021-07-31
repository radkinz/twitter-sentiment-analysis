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
    titlePanel(title=h4("Analyze Twitter Data", align="center")),
    
    sidebarPanel(
      textInput("searchquery", "Twitter Search Query: ", value="#olympics"),
      numericInput("sentimentN", "Tweet Sample Size for Sentiment Analysis: ", value=70, min=0, max=1600),
      numericInput("freqN", "Tweet Sample Size for Frequency Analysis: ", value=1200, min=0, max=1600),
      actionButton("submit", "Go!")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Sentiment Analysis", withLoader(plotOutput("plotSent"), type="image", loader="https://cdn.dribbble.com/users/908372/screenshots/4812323/loading2.gif")),
        tabPanel("Frequency", withLoader(plotOutput("plotFreq"), type="image", loader="https://thumbs.gfycat.com/YellowishElementaryHind-max-1mb.gif"))
      )
    ))
)
