# Load necessary libraries
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(knitr)

# 1. Load Data
df <- read_csv("~/Desktop/Fin -365/DubaiSTR.csv")

# Clean up any price columns if needed
df <- df %>% mutate(price_cleaned = as.numeric(gsub("[$,]", "", price)))

# 2. ROI by Number of Bedrooms
roi_by_bedrooms <- df %>%
  group_by(bedrooms) %>%
  summarise(avg_roi = mean(ROI, na.rm = TRUE))

ggplot(roi_by_bedrooms, aes(x = factor(bedrooms), y = avg_roi)) +
  geom_col(fill = "steelblue") +
  labs(title = "Average ROI by Number of Bedrooms", x = "Bedrooms", y = "Average ROI") +
  theme_minimal()

# 3. ROI by Number of Amenities
amenity_cols <- c("pool", "gym", "spa", "balcony", "water_view", "landmark_view", "security", "study")
df$amenity_count <- rowSums(df[ , amenity_cols], na.rm = TRUE)

roi_by_amenities <- df %>%
  group_by(amenity_count) %>%
  summarise(avg_roi = mean(ROI, na.rm = TRUE))

ggplot(roi_by_amenities, aes(x = factor(amenity_count), y = avg_roi)) +
  geom_col(fill = "darkgreen") +
  labs(title = "Average ROI by Number of Amenities", x = "Amenity Count", y = "Average ROI") +
  theme_minimal()

# 4. ROI by Neighborhood
roi_by_neighborhood <- df %>%
  group_by(neighborhood) %>%
  summarise(avg_roi = mean(ROI, na.rm = TRUE)) %>%
  arrange(desc(avg_roi)) %>%
  slice_max(order_by = avg_roi, n = 10)

ggplot(roi_by_neighborhood, aes(x = reorder(neighborhood, avg_roi), y = avg_roi)) +
  geom_col(fill = "orange") +
  coord_flip() +
  labs(title = "Top 10 Neighborhoods by ROI", x = "Neighborhood", y = "ROI") +
  theme_minimal()

# 5. Present Value Comparison - Renting vs Buying
# Assume yearly rent = daily_rate * 365, discount rate = 5%, investment horizon = 5 years

discount_rate <- 0.05
years <- 5
df <- df %>%
  mutate(annual_rent = daily_rate * 365,
         PV_rent = annual_rent * ((1 - (1 + discount_rate)^(-years)) / discount_rate),
         PV_buy = price_cleaned)

# Compare PV
ggplot(df, aes(x = PV_rent, y = PV_buy)) +
  geom_point(alpha = 0.5) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  labs(title = "Present Value of Renting vs Buying",
       x = "Present Value of Renting (5 yrs)",
       y = "Price (Buying)") +
  theme_minimal()

# 6. Investment Feasibility
df <- df %>% mutate(is_feasible = ifelse(PV_rent > PV_buy, "Rent", "Buy"))

table(df$is_feasible)

# 7. Bayes’ Theorem - Impact of Tariffs on High ROI
P_High_ROI <- mean(df$ROI > 0.07, na.rm = TRUE)
P_Tariff <- 0.4
P_Tariff_given_High_ROI <- 0.25

# Bayes' Theorem:
P_High_ROI_given_Tariff <- (P_Tariff_given_High_ROI * P_High_ROI) / P_Tariff
P_High_ROI_given_Tariff

