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
library(dplyr)
library(tidyr)
library(tidytext)
library(rtweet)

plot_top_10 <- function(search) {
    #get tweets
    twitterdata <- search_tweets(
        search, n = 600, include_rts = FALSE
    )
    twitterdata
    
    #simplify dataset
    tweets.twitterdata = twitterdata %>% select(screen_name, text)
    tweets.twitterdata
    
    #clean up dataset
    head(tweets.twitterdata$text)
    #replace html with empty space
    tweets.twitterdata$stripped_text1 <- gsub("http\\S+","", tweets.twitterdata$text)
    
    #remove punctuation
    tweets.twitterdata_stem <- tweets.twitterdata %>%
        select(stripped_text1) %>%
        #convert to a tidy dataset by representing each row with one token so we can use the tidytext library for sentiment analysis
        #this function also converts text to lowercase and removes punctuation
        unnest_tokens(word, stripped_text1)
    
    #remove stop words because they are not helpful for sentiment analysis
    cleaned_tweets.twitterdata <- tweets.twitterdata_stem %>%
        anti_join(stop_words)
    
    #begin constructing top 10 most frequent word plots
    cleaned_tweets.twitterdata %>%
        count(word, sort=TRUE) %>%
        top_n(10) %>%
        mutate(word = reorder(word, n)) %>%
        ggplot(aes(x = word, y = n)) +
        geom_col(fill ="green") +
        xlab(NULL) +
        coord_flip() +
        theme_bw() +
        labs(x = "Frequency",
             y = "Common Words",
             title = "Top 10 Used Words in #Olympics tweets")
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    output$plot<-renderPlot({
        plot_top_10("Olympics")
    })

})
