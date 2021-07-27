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

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    titlePanel(title=h4("Olympic Twitter Data", align="center")),
    mainPanel(plotOutput("plot")))
)
