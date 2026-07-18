# Install packages if not already installed
if (!require("arules")) install.packages("arules")
if (!require("arulesViz")) install.packages("arulesViz")

# Load libraries
library(arules)
library(arulesViz)

# Load the dataset
VideoGames <- read.csv("~/Desktop/Fin -365/Week 4 - Breakout Exercise DataSet VideoGames (1).csv")

# Convert to binary (assuming 1 = played/used, 0 = not played/used)
VideoGames.binary <- VideoGames > 0.5

# Convert to transactions format
VideoGames.trans <- as(VideoGames.binary, "transactions")

# Generate association rules
rules <- apriori(VideoGames.trans,
                 parameter = list(supp = 0.01, conf = 0.2))

# View top 10 rules by confidence
inspect(sort(rules, by = "confidence", decreasing = TRUE)[1:10])

# Rule with the highest confidence
inspect(sort(rules, by = "confidence", decreasing = TRUE)[1])

# Rule with the highest lift
inspect(sort(rules, by = "lift", decreasing = TRUE)[1])

# Check specific rules
inspect(subset(rules, lhs %pin% "Mafia Farm" & rhs %pin% "Word Pizza"))
inspect(subset(rules, lhs %pin% "Word Pizza" & rhs %pin% "Mafia Farm"))




