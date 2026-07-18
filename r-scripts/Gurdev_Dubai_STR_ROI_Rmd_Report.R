---
  title: "Dubai Short-Term Rental ROI Analysis"
output: word_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)
library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
```

## 📌 Load & Prepare the Data

```{r load-data}
df <- read_csv("~/Desktop/Fin -365/DubaiSTR.csv")  # Ensure this file is in the working directory

# Optional: Clean price column if needed later
df <- df %>%
  mutate(price_cleaned = as.numeric(gsub("[$,]", "", price)))
```

---
  
  ## 📊 ROI by Number of Bedrooms
  
  ```{r roi-bedrooms}
roi_by_bedrooms <- df %>%
  group_by(bedrooms) %>%
  summarise(avg_roi = mean(ROI, na.rm = TRUE)) %>%
  arrange(desc(avg_roi))

ggplot(roi_by_bedrooms, aes(x = reorder(factor(bedrooms), avg_roi), y = avg_roi)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Average ROI by Number of Bedrooms", x = "Bedrooms", y = "ROI") +
  theme_minimal()
```

**Insights:** Studio apartments (0 bedrooms) yield the highest ROI, while larger apartments generally provide lower ROI.

---
  
  ## 🏡 ROI by Amenities (Pool, Gym, Water View, etc.)
  
  ```{r roi-amenities}
# Select amenity columns
amenity_cols <- c("pool", "gym", "water_view", "spa", "landmark_view", "security", "balcony", "study")

# Melt the data for each amenity
roi_amenities <- df %>%
  select(ROI, all_of(amenity_cols)) %>%
  pivot_longer(cols = all_of(amenity_cols), names_to = "amenity", values_to = "has_amenity") %>%
  filter(!is.na(ROI)) %>%
  group_by(amenity, has_amenity) %>%
  summarise(avg_roi = mean(ROI, na.rm = TRUE), .groups = "drop")

# Plot
ggplot(roi_amenities, aes(x = amenity, y = avg_roi, fill = factor(has_amenity))) +
  geom_col(position = "dodge") +
  labs(title = "ROI by Amenity Presence", x = "Amenity", y = "Average ROI", fill = "Has Amenity") +
  theme_minimal() +
  coord_flip()
```

**Insights:** This chart shows which amenities boost or reduce ROI (e.g., pools, gym, views).

---
  
  ## 📍 ROI by Location (if available)
  
  ```{r roi-location}
if("location" %in% names(df)) {
  roi_by_location <- df %>%
    group_by(location) %>%
    summarise(avg_roi = mean(ROI, na.rm = TRUE)) %>%
    arrange(desc(avg_roi)) %>%
    slice_head(n = 10)  # Show top 10
  
  ggplot(roi_by_location, aes(x = reorder(location, avg_roi), y = avg_roi)) +
    geom_col(fill = "orange") +
    coord_flip() +
    labs(title = "Top 10 Locations by ROI", x = "Location", y = "ROI") +
    theme_minimal()
}
```

---
  
  ## 📈 Bayes' Theorem - Impact of Tariffs (Hypothetical Example)
  
  ```{r bayes-tariff}
# Let's say:
# P(High_ROI | New_Tariff) = P(New_Tariff | High_ROI) * P(High_ROI) / P(New_Tariff)

# Assume these based on available data or policy updates:
P_High_ROI <- mean(df$ROI > 0.07, na.rm = TRUE)
P_New_Tariff <- 0.4  # Assume 40% of listings face new tariffs
P_Tariff_given_High_ROI <- 0.25  # Among high ROI properties, 25% are impacted

P_High_ROI_given_Tariff <- (P_Tariff_given_High_ROI * P_High_ROI) / P_New_Tariff
P_High_ROI_given_Tariff
```

**Interpretation:** Use this value to assess how much new regulations may influence profitable listings.

---
  
  ## 💡 Final Recommendations
  
  - **Studio and 1-bedroom units** yield higher ROI — ideal for short-term investments.
- **Amenities like pools and views** add substantial value.
- Use **Bayesian thinking** to evaluate impact of regulations (e.g., tariffs).
- Monitor **top-performing locations** and shift investment accordingly.

