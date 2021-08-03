#
# This is the server logic of a Shiny web application
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

rate_limit_exceed <- FALSE

prepare_data <- function(search, size) {
    #get tweets
    print(search)
    print(size)
    twitterdata <- search_tweets(
        search, n = size, include_rts = FALSE
    )
    #if no data then rate exceeded
    if (nrow(twitterdata) == 0) {
        showNotification("Rtweet Rate limit exceeded. 
                         Come back in 15 minutes:/",
                         type = "warning"
        )
    }
    
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
    
    result <- list(cleaned_tweets.twitterdata, twitterdata)
    return(result)
}

plot_top_10 <- function(search, n) {
    list_data <- prepare_data(search, n)
    Totallength <- n
    data <- list_data[[1]]
    
    #begin constructing top 10 most frequent word plots
    data %>%
        count(word, sort=TRUE) %>%
        #exclude #1 most common word because that will be the key word
        slice(2:11) %>%
        mutate(word = reorder(word, n)) %>%
        ggplot(aes(x = word, y = n, fill=n)) +
        scale_fill_gradient(low="blue", high="red") +
        geom_col() +
        xlab(NULL) +
        coord_flip() +
        theme_bw() +
        labs(x = "Common Words",
             y = "Frequency",
             subtitle = sprintf('Not Including "%s" itself...', search),
             title = sprintf("Top 10 Words in %s Tweets", search)) +
        theme(plot.title = element_text(size = 20, face = "bold"),
              plot.subtitle = element_text(size = 15, face = "italic"),
              axis.title.x = element_text(size = 13),
              axis.title.y = element_text(size = 13)) 
}

#set up sentiment function
sentiment_bing = function(twt){
    #clean tweet
    twt_tbl = tibble(text = twt) %>%
        mutate(
            #remove html
            stripped_text = gsub("http\\S+","",text)
        ) %>%
        unnest_tokens(word, stripped_text) %>%
        anti_join(stop_words) %>%
        inner_join(get_sentiments("bing")) %>%
        count(word, sentiment, sort = TRUE) %>%
        ungroup() %>%
        #assign score based on sentiment
        mutate(
            score = case_when(
                sentiment == 'negative'~n*(-1),
                sentiment == 'positive'~n*1)
        )
    
    validate_tibble(twt_tbl)
    #calculate total score
    sent.score = case_when(
        nrow(twt_tbl)==0~0, #if no words then score is 0
        nrow(twt_tbl)>0~sum(twt_tbl$score) #sum the pos and neg
    )
    #keep track of tweets with no words
    zero.type = case_when(
        nrow(twt_tbl)==0~"Type 1", #no words at all
        nrow(twt_tbl)>0~"Type 2" #sum of words is 0
    )
    list(score = sent.score, type = zero.type, twt_tbl = twt_tbl)
}


sentiment_function <- function(search, n) {
    list_data <- prepare_data(search, n)
    data <- list_data[[1]]
    original_data <- list_data[[2]]
    
    #apply function to dataset
    data_sent = lapply(original_data$text, function(x){sentiment_bing(x)})
    data_sent
    
    #use tidytext to get sentiment data
    twitter_sentiment = bind_rows(
        tibble(
            name = search,
            score = unlist(map(data_sent, 'score')),
            type = unlist(map(data_sent, 'type'))
        )
    )
    
    #use ggplot to graph sentiments
    ggplot(twitter_sentiment, aes(x=score, fill=..density..)) +
        geom_histogram(binwidth=1) +
        scale_fill_gradient(low="blue", high="purple") +
        theme_bw() +
        labs(x = "Sentiment Score",
           y = "Frequency",
           title = sprintf("Sentiment Score among %s Tweets", search),
           subtitle= "The higher the sentiment, the more positive the tweet") +
        theme(plot.title = element_text(size = 20, face = "bold"),
            plot.subtitle = element_text(size = 15, face = "italic"),
            axis.title.x = element_text(size = 13),
            axis.title.y = element_text(size = 13)) 
    
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    query <- eventReactive(input$submit,
                           {
                             #query validation
                             validate(
                               need(input$searchquery != "", "Please fill out the search query")
                             )
                               input$searchquery
                           })
    
    sentimentN <- eventReactive(input$submit,
                                {
                                    input$sentimentN
                                })
    
    freqN <- eventReactive(input$submit,
                                {
                                    input$freqN
                                })
    
    observeEvent(input$submit, {
        output$plotFreq<-renderPlot({
            print(plot_top_10(query()[[1]], freqN()[[1]]))
        })
        
        output$plotSent<-renderPlot({
            print(sentimentN()[[1]])
            print(query()[[1]])
            sentiment_function(query()[[1]], sentimentN()[[1]])
        })
    })
    
    output$plotFreq<-renderPlot({
        plot_top_10("#olympics", 1200)
    })
    
    output$plotSent<-renderPlot({
        sentiment_function("#olympics", 70)
    })
})
