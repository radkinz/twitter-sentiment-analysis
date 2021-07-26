#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(rtweet)

#load data
#tweet_df <- search_tweets("#olympics", n = 1600, include_rts = FALSE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$plot<-renderPlot({
        #import data
        tweet_df %>%
            #pipe operator allows you to filter and pipe new data
            filter(favorite_count > 25) %>%
            ggplot(aes(x=source, y = favorite_count)) + 
            #add points to plot
            geom_col(size = 3, fill = "blue") 
    })
        

})
