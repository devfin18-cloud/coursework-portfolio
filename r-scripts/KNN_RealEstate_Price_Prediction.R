# Load necessary libraries
install.packages("FNN")  # Only run once
library(FNN)
library(class)

# Import datasets
real_estate <- read.csv("~/Desktop/Fin -365/Week 6 - Breakout Exercise DataSet RealEstate.csv")
to_sell <- read.csv("~/Desktop/Fin -365/Week 6 - Breakout Exercise DataSet ToSell.csv")

# Convert to data frames
real_estate <- as.data.frame(real_estate)
to_sell <- as.data.frame(to_sell)

# Inspect column names
print(names(real_estate))

# Confirm Price column exists
if (!"Price" %in% names(real_estate)) {
  stop("Column 'Price' not found. Please check the dataset.")
}

# Set seed
set.seed(123)

# Split data
sample_index <- sample(1:nrow(real_estate), 0.8 * nrow(real_estate))
train <- real_estate[sample_index, ]
test <- real_estate[-sample_index, ]

# Normalize numeric columns
normalize <- function(x) { (x - min(x)) / (max(x) - min(x)) }
numeric_cols <- sapply(train, is.numeric)
train_norm <- as.data.frame(lapply(train[, numeric_cols], normalize))
test_norm <- as.data.frame(lapply(test[, numeric_cols], normalize))
to_sell_norm <- as.data.frame(lapply(to_sell[, numeric_cols], normalize))

# Extract target variable
train_price <- train$Price
test_price <- test$Price

# Run KNN regression
knn_pred <- knn.reg(train = train_norm, test = test_norm, y = train_price, k = 5)

# RMSE
rmse_knn <- sqrt(mean((test_price - knn_pred$pred)^2))
print(paste("KNN RMSE:", round(rmse_knn, 2)))

# Predict on to_sell data
to_sell_pred <- knn.reg(train = train_norm, test = to_sell_norm, y = train_price, k = 5)
print("Predicted price for new properties:")
print(to_sell_pred$pred)

