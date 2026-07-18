data <- read.csv("~/Desktop/Week 5 - Breakout Exercise DataSet CoffeeSales.csv")
model <- lm(Sales ~ Temperature + StandAlone, data = data)
summary(model)
predict(model, newdata = data.frame(Temperature = 85, StandAlone = 1))
predict(model, newdata = data.frame(Temperature = 85, StandAlone = 0))
predict(model, newdata = data.frame(Temperature = 35, StandAlone = 1))
summary(model)
# Example: Revenue difference by location at same temperature
rev_standalone <- predict(model, data.frame(Temperature = 85, StandAlone = 1))
rev_mall <- predict(model, data.frame(Temperature = 85, StandAlone = 0))

percent_change_location <- ((rev_standalone - rev_mall) / rev_mall) * 100

# Revenue difference by temperature at same location
rev_hot <- predict(model, data.frame(Temperature = 85, StandAlone = 1))
rev_cold <- predict(model, data.frame(Temperature = 35, StandAlone = 1))

percent_change_temp <- ((rev_hot - rev_cold) / rev_cold) * 100
