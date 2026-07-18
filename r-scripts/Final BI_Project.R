---
  title: "Dubai Short-Term Rental ROI Analysis"
output: word_document

library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(broom)
df <- read_csv("~/Desktop/Fin -365/DubaiSTR.csv")
df <- df %>%
  mutate(price_cleaned = as.numeric(gsub("[$,]", "", price)))
summary(df$ROI)
summary(df$occupancy_rate)
roi_by_bedrooms <- df %>%
  group_by(bedrooms) %>%
  summarise(avg_roi = mean(ROI, na.rm = TRUE))

ggplot(roi_by_bedrooms, aes(x = factor(bedrooms), y = avg_roi)) +
  geom_col(fill = "steelblue") +
  labs(title = "Average ROI by Number of Bedrooms", x = "Bedrooms", y = "Average ROI") +
  theme_minimal()
model <- lm(ROI ~ daily_rate + occupancy_rate + sqft + ppsqft + bedrooms + bathrooms + pool + gym + water_view + landmark_view, data = df)
summary(model)
tidy(model)
annual_rent <- df$daily_rate * df$occupancy_rate * 365
pv_rent <- annual_rent * ((1 - (1 + 0.06)^-5) / 0.06)
pv_buy <- df$price_cleaned

df <- df %>%
  mutate(pv_rent = pv_rent,
         pv_buy = pv_buy,
         better_option = ifelse(pv_rent < pv_buy, "Rent", "Buy"))

table(df$better_option)
demand_supply <- df %>%
  group_by(neighborhood) %>%
  summarise(listings = n(),
            avg_roi = mean(ROI, na.rm = TRUE)) %>%
  arrange(desc(listings))

ggplot(demand_supply, aes(x = reorder(neighborhood, -listings), y = listings)) +
  geom_col(fill = "darkgreen") +
  coord_flip() +
  labs(title = "Listings by Neighborhood (Supply)", x = "Neighborhood", y = "Number of Listings")

