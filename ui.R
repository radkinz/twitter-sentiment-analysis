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

#tweet_df <- search_tweets("#olympics", n = 1600, include_rts = FALSE)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel(title=h4("Races", align="center")),
    mainPanel(plotOutput("plot")))
)
