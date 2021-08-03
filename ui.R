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

shinyUI(fluidPage(
  tags$head(
    # Note the wrapping of the string in HTML()
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Yusei+Magic&display=swap');
      body {
        background-color: #141d26;
        color: white;
      }
      h2 {
        font-family: 'Yusei Magic', sans-serif;
      }
      .shiny-input-container {
        color: #474747;
      }
      .tab-content {
        background-color: white;
      }
      .tabbable > .nav > li > a {background-color: #243447}
      .tabbable > .nav > li > a:hover {background-color: white}
      .tabbable > .nav > .active > a {background-color: white}
      .shiny-notification {
        position:fixed;
        top: calc(25%);
        left: calc(50%);
        transform: translate(-50%, -50%);
        padding: 20px;
        font-size: 120%;
      }"))
  ),
    titlePanel(title=h2("Twitter Data Analysis", align="center")),
    
    sidebarPanel(
      textInput("searchquery", "Twitter Search Query: ", value="#olympics"),
      sliderInput("sentimentN", "Tweet Sample Size for Sentiment Analysis: ", value=70, min=1, max=1600),
      sliderInput("freqN", "Tweet Sample Size for Frequency Analysis: ", value=1200, min=1, max=1600),
      actionButton("submit", "Go!")
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Sentiment Analysis", withLoader(plotOutput("plotSent"), type="image", loader="https://cdn.dribbble.com/users/908372/screenshots/4812323/loading2.gif")),
        tabPanel("Frequency", withLoader(plotOutput("plotFreq"), type="image", loader="https://thumbs.gfycat.com/YellowishElementaryHind-max-1mb.gif"))
      )
    ))
)
