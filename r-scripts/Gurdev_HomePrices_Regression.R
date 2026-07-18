
# Load dataset
data <- read.csv("~/Desktop/Fin -365/Homework #3 - DataSet HomePrices.csv")  # Make sure the CSV is in your working directory

# ----------------------
# a) Full Regression Model
# ----------------------
model_full <- lm(Price ~ Size + Age + Foreclosure + Crime, data = data)
summary(model_full)

# ----------------------
# b) Why does Foreclosure have the largest coefficient?
# (Explanation in comments)
# Foreclosure is a binary variable (0 or 1), so its coefficient reflects a level shift.
# A large value indicates that foreclosed homes are valued significantly less (or more)
# than non-foreclosed homes, on average.

# ----------------------
# c) Standard error to understand prediction variability
residual_std_error <- summary(model_full)$sigma
cat("Residual Standard Error (c):", residual_std_error, "\n")

# ----------------------
# d) Predict price of a specific house
new_house <- data.frame(
  Size = 2000,
  Age = 50,
  Foreclosure = 0,
  Crime = 300
)

predicted_price_d <- predict(model_full, newdata = new_house)
cat("Predicted Price (d):", predicted_price_d, "\n")

# ----------------------
# e) Identify statistically significant variables
cat("P-values for each variable (e):\n")
print(coef(summary(model_full)))

# ----------------------
# f) Regression model with only statistically significant variables
# (Assuming from output: Size and Crime are significant)
model_reduced <- lm(Price ~ Size + Crime, data = data)
summary(model_reduced)

# Predict price again using reduced model
new_house_reduced <- data.frame(
  Size = 2000,
  Crime = 300
)
predicted_price_f <- predict(model_reduced, newdata = new_house_reduced)
cat("Predicted Price with reduced model (f):", predicted_price_f, "\n")

# ----------------------
# g) Add non-linear term for Age to explore U-shaped relationship
data$Age2 <- data$Age^2

model_nonlinear <- lm(Price ~ Size + Age + Age2 + Foreclosure + Crime, data = data)
summary(model_nonlinear)

# Interpretation:
# A significant Age² term indicates a non-linear (e.g., U-shaped) relationship,
# where both very new and very old homes may be valued higher.

