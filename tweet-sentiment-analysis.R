library(tidyverse)
library(dplyr)
library(tidyr)
library(tidytext)
library(rtweet)

#get tweets about country
country1 <- search_tweets(
  "#Canada", n = 200, include_rts = FALSE
)

country2 <- search_tweets(
  "#USA", n = 200, include_rts = FALSE
)

#simplify datasets
tweets.Country1 = country1 %>% select(screen_name, text)
tweets.Country1
tweets.Country2 = country2 %>% select(screen_name, text)
tweets.Country2

#clean tweets before analysis
#remove html elements
tweets.Country1$stripped_text1 <- gsub("http\\S+","", tweets.Country1$text)

#remove punctuation
tweets.Country1_stem <- tweets.Country1 %>%
  select(stripped_text1) %>%
  #convert to a tidy dataset by representing each row with one token so we can use the tidytext library for sentiment analysis
  #this function also converts text to lowercase and removes punctuation
  unnest_tokens(word, stripped_text1)

#remove stop words because they are not helpful for sentiment analysis
cleaned_tweets.Country1 <- tweets.Country1_stem %>%
  anti_join(stop_words)

head(cleaned_tweets.Country1)

#clean second dataset

#remove html elements
tweets.Country2$stripped_text2 <- gsub("http\\S+","", tweets.Country2$text)

#remove punctuation
tweets.Country2_stem <- tweets.Country2 %>%
  select(stripped_text2) %>%
  #convert to a tidy dataset by representing each row with one token so we can use the tidytext library for sentiment analysis
  #this function also converts text to lowercase and removes punctuation
  unnest_tokens(word, stripped_text2)

#remove stop words because they are not helpful for sentiment analysis
cleaned_tweets.Country2 <- tweets.Country2_stem %>%
  anti_join(stop_words)

head(cleaned_tweets.Country2)

#Find top 10 words in each dataset and plot in ggplot
cleaned_tweets.Country1 %>%
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
       title = "Top 10 Used Words in #Canada tweets")

cleaned_tweets.Country2 %>%
  count(word, sort=TRUE) %>%
  top_n(10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(x = word, y = n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip() +
  theme_bw() +
  labs(x = "Frequency",
       y = "Common Words",
       title = "Top 10 Used Words in #USA tweets")

  

