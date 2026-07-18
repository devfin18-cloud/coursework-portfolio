  
# Load necessary packages
library(readr)
library(officer)

# Read the dataset 
data <- read.csv("~/Desktop/Desktop - Dev’s MacBook Air - 1/Fin -365/Homework #1 - DataSet Heating Oil.csv")

# View the first few rows
head(data)

# Calculate the mean number of occupants
mean_occupants <- mean(data$Num_Occupants, na.rm = TRUE)
print(paste("Mean number of occupants:", mean_occupants))

# Show the 385th row of data
row_385 <- data[385, ]
print(row_385)

# Compute correlation matrix
cor_matrix <- cor(data, use = "complete.obs")

# Print the entire correlation matrix
print(cor_matrix)

# Extract the correlation between Outdoor_Temp and Heating_Oil_Used
correlation_value <- cor_matrix["Outdoor_Temp", "Heating_Oil_Used"]
print(paste("Correlation between Outdoor Temperature and Heating Oil Used:", correlation_value))

