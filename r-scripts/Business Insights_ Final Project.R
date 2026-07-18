# Load necessary packages
if (!require(tidyverse)) install.packages("tidyverse")
if (!require(janitor)) install.packages("janitor")

library(tidyverse)
library(janitor)

# STEP 1: Load dataset
data <- read_csv("~/Desktop/Fin -365/Dubai Airbnb-Apartment with Occupancy Rate.csv")

# STEP 2: Clean column names
data <- data %>% clean_names()

# STEP 3: Filter for valid price, size, and occupancy values
data_clean <- data %>%
  filter(price > 0, size_in_sqft > 0, occupancy_rate > 0) %>%
  mutate(neighborhood = tolower(neighborhood))

# STEP 4: Winsorize extreme outliers
data_clean <- data_clean %>%
  mutate(
    price = pmin(pmax(price, quantile(price, 0.01, na.rm = TRUE)), quantile(price, 0.99, na.rm = TRUE)),
    size_in_sqft = pmin(pmax(size_in_sqft, quantile(size_in_sqft, 0.01, na.rm = TRUE)), quantile(size_in_sqft, 0.99, na.rm = TRUE)),
    no_of_bedrooms = ifelse(no_of_bedrooms > 8, 8, no_of_bedrooms)
  )

# STEP 5: Calculate annual revenue, ROI, price per sqft
data_clean <- data_clean %>%
  mutate(
    annual_revenue = price * occupancy_rate * 365,
    roi_percent = (annual_revenue - price) / price * 100,
    price_per_sqft = price / size_in_sqft
  )

# STEP 6: Group-wise ROI by neighborhood
neighborhood_analysis <- data_clean %>%
  group_by(neighborhood) %>%
  summarise(
    avg_roi = mean(roi_percent, na.rm = TRUE),
    avg_price = mean(price, na.rm = TRUE),
    avg_occupancy = mean(occupancy_rate, na.rm = TRUE),
    count = n()
  ) %>%
  arrange(desc(avg_roi))

# STEP 7: Plot ROI by neighborhood
ggplot(neighborhood_analysis, aes(x = reorder(neighborhood, avg_roi), y = avg_roi, fill = avg_price)) +
  geom_col() +
  coord_flip() +
  scale_fill_gradient(low = "lightgreen", high = "darkgreen") +
  labs(
    title = "Average ROI by Neighborhood",
    x = "Neighborhood",
    y = "Average ROI (%)",
    fill = "Avg. Price"
  )

# STEP 8: Plot ROI distribution
ggplot(data_clean, aes(x = roi_percent)) +
  geom_histogram(bins = 30, fill = "darkgreen", color = "white") +
  labs(
    title = "ROI Distribution Across Listings",
    x = "ROI (%)",
    y = "Count"
  )

# STEP 9: Scatter plot of ROI vs. Price per Square Foot
ggplot(data_clean, aes(x = price_per_sqft, y = roi_percent)) +
  geom_point(alpha = 0.4, color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  labs(
    title = "ROI vs Price per Square Foot",
    x = "Price per Sqft",
    y = "ROI (%)"
  )

