library(tidyverse)
library(dplyr)
library(tidyr)
library(tidytext)
library(rtweet)

#get tweets about country
twitterdata <- search_tweets(
  "#Olympics", n = 200, include_rts = FALSE
)

#simplify datasets
tweets.twitterdata = twitterdata %>% select(screen_name, text)
tweets.twitterdata

#clean tweets before analysis
#remove html elements
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

#Find top 10 words in each dataset and plot in ggplot
cleaned_tweets.twitterdata %>%
  count(word, sort=TRUE) %>%
  top_n(10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col(fill ="red") +
  xlab(NULL) +
  coord_flip() +
  theme_bw() +
  labs(x = "Frequency",
       y = "Common Words",
       title = "Top 10 Used Words in #Olympics tweets")

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

#apply function to dataset
twitterdata_sent = lapply(twitterdata$text, function(x){sentiment_bing(x)})
twitterdata_sent

#use tidytext to get sentiment data
twitter_sentiment = bind_rows(
  tibble(
    name = "#Olympics",
    score = unlist(map(twitterdata_sent, 'score')),
    type = unlist(map(twitterdata_sent, 'type'))
  )
)
twitter_sentiment
#use ggplot to graph sentiments
ggplot(twitter_sentiment, aes(x=score, fill=name)) +
  geom_histogram(bins = 15, alpha = 0.6) +
  theme_bw()
  

