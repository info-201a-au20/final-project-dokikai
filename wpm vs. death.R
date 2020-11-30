# In this function, our goal is to virtualize the 
#comparison of wards per minutes versus the number of death
#import package:
library("dplyr")
library("ggplot2")
#import the dataset
match_df <- read.csv("data/2019-summer-match-data-OraclesElixir-2019-11-10.csv",
                     stringsAsFactors = FALSE)
#write the function:
wpm_death <- function(df){
        result <- df%>%
          group_by(gameid)%>%
          filter(position == "Team")
        
        map <- ggplot(df) +
          ggtitle("Scatter Plot in Terms of wards per minutes versus the number of death") +
          geom_point(
            mapping = aes(x = teamdeaths, y = wcpm, color =team )
          )
          
      return(map)    
}

wpm_death(match_df)
