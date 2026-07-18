# Load the tree package
library(tree)

# Import the datasets
real_estate <- read.csv("~/Desktop/Fin -365/Week 6 - Breakout Exercise DataSet RealEstate.csv")
to_sell <- read.csv("~/Desktop/Fin -365/Week 6 - Breakout Exercise DataSet ToSell.csv")

# Set seed for reproducibility
set.seed(123)

# Partition data
sample_index <- sample(1:nrow(real_estate), 0.70 * nrow(to_sell))
train <- real_estate[sample_index, ]
test <- to_sell[-sample_index, ]

# Fit the regression tree model
tree_model <- tree(Price ~ ., data = train)

# Plot the tree
plot(tree_model)
text(tree_model, pretty = 0)

# Predict and calculate RMSE
tree_pred <- predict(tree_model, newdata = test)
rmse_tree <- sqrt(mean((test$Price - tree_pred)^2))

# Predict on ToSell data
to_sell_pred_tree <- predict(tree_model, newdata = to_sell)
to_sell_pred_tree

