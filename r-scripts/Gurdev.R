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
rules <- apriori(VideoGames.trans, parameter = list(supp = 0.01, conf = 0.2))

# Rule with the highest confidence
inspect(sort(rules, by = "confidence", decreasing = TRUE)[1])

# Rule with the highest lift
inspect(sort(rules, by = "lift", decreasing = TRUE)[1])

# Check if "Mafia.Farm" and "Word.Pizza" appear in the item labels
item_labels <- itemLabels(VideoGames.trans)
print(item_labels)

# Subset the rule where the left-hand side is "Mafia.Farm" and the right-hand side is "Word.Pizza"
rule1 <- subset(rules, lhs %in% c("Mafia.Farm") & rhs %in% c("Word.Pizza"))

# Subset the rule where the left-hand side is "Word.Pizza" and the right-hand side is "Mafia.Farm"
rule2 <- subset(rules, lhs %in% c("Word.Pizza") & rhs %in% c("Mafia.Farm"))

# Inspect the first rule (Mafia.Farm => Word.Pizza)
inspect(rule1)

# Inspect the second rule (Word.Pizza => Mafia.Farm)
inspect(rule2)

# If no rules found, print the rules to see if they exist
if (length(rule1) > 0) {
  confidence_rule1 <- quality(rule1)$confidence
  print(confidence_rule1)
} else {
  print("No rule found for Mafia.Farm => Word.Pizza")
}

if (length(rule2) > 0) {
  confidence_rule2 <- quality(rule2)$confidence
  print(confidence_rule2)
} else {
  print("No rule found for Word.Pizza => Mafia.Farm")
}

