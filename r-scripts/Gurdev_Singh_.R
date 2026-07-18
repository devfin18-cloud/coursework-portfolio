options(repos = c(CRAN = "https://cloud.r-project.org"))


install.packages("arules")  
library(arules)

data <- read.csv('~/Desktop/Fin -365/ Principal.csv')  # Read CSV file
head(data) 
data <- data.frame(lapply(data, as.logical))
trans_data <- as(data, "transactions")  
summary(trans_data)  
rules <- apriori(trans_data, 
                 parameter = list(supp = 0.025, conf = 0.08, target = "rules"))
rules_sorted <- sort(rules, by = "confidence", decreasing = TRUE)
inspect(rules_sorted)  # View the rules
midcap_bondindex <- subset(rules_sorted, lhs %in% "MidCap" & rhs %in% "BondIndex")
inspect(midcap_bondindex)
aggro_stockindex <- subset(rules_sorted, lhs %in% "AggroCap" & rhs %in% "StockIndex")
inspect(aggro_stockindex)
