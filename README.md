# Twitter Sentiment Analysis

A [Shiny](https://shiny.rstudio.com/) web application that utilizes the [rtweet library](https://docs.ropensci.org/rtweet/) to get a sample size of recent tweets for data analysis. The application then uses `ggplot2` within the [tidyverse library](https://www.tidyverse.org/) to generate two plots for sentiment and frequency analysis.

## Rtweet
Rtweet generates a certain amount of most recent tweets that contain a keyword, which is inputted by the user.
By taking the most recent tweets, this may generate undercoverage bias in the app's analytics. However, this method of sampling can also be useful when sampling during an event such as the Olympics!

## Sentiment Analysis
![Sentiment Graph](/images/sentimentscreenshot.png)
Using the Bing lexicon and `get_sentiments` function from the [tidytext package](https://juliasilge.github.io/tidytext/), we can identify the positive and negative keywords within a tweet. We then create our own function that assigns every positive word a score of +1 and negative word a -1, in order to add up the values to get a tweet's total sentiment score. We then plot those sentiment scores per each tweet to get a similar graph as seen in the above image.

## Frequency Analysis
![Frequency Graph](/images/freqsecreenshot.png)
Usig the `count` and `slice` functions from the [dplyr package](https://dplyr.tidyverse.org/), we can filter and sort the top 10 most common words that are found in our sample size of tweets. We then display our results using `ggplot2` once again to get an easy-to-read bar graph that lists the top 10 words and their frequencies. Ultimately, this data helps us find out what types of words are often associated with the words that the user inputs. 

## Overall UI Layout
![Page UI](/images/uiscreenshot.png)
The overall UI of the web app is simply composed of a header, sidebar, and tabset panel. The sidebar takes in 3 inputs for the tweet search query, the sentiment analysis tweet sample size, and the frequency analysis tweet sample size. Meanwhile, the tabset panel lets the user alternate between the sentiment and frequency plot. The color scheme is also based on that of twitter's dark mode, which is fun. 

## Final Thoughts
Working with R was very eye-opening because I started to see the line between computer and data science. As simple as data science might seem as just "handling data," I learned that a lot goes into the process of getting the data, cleaning/organizing the data, and displaying the data in the most effective way for the user. The R language is designed for data science, so I was not surprised when I found countless resources and libraries to help manage and plot data. This abundance and partial *reliance* on libraries to help me achieve certain functions at first made me feel useless and sort of like I was cheating. However, I started to realize the epicness of taking multiple open-source R packages and combining them to create one awesome project of its own (like Neapolitan ice cream). In the end, I still see myself on the computer science side of the fence, but it felt really good to branch out:)
