
# Step 1: Load the dataset
handshakes <- read.csv("~/Desktop/Desktop - Dev’s MacBook Air - 1/Fin -365/Week 3 - Breakout Exercise DataSet Handshakes.csv")

# Step 2: Normalize the dataset using the scale function
handshakes_scaled <- scale(handshakes)

# Step 3: Set the random seed for reproducibility
set.seed(12345)

# Step 4: Perform k-Means Clustering with 5 clusters
kmeans_result <- kmeans(handshakes_scaled, centers = 5, nstart = 25)

# Step 5a: Display the centroids of the 5 clusters (in normalized form)
print("Centroids of the 5 clusters (scaled data):")
print(kmeans_result$centers)

# Step 5b: Unscale function to convert centroids back to original units
unscale <- function(scaled_data, original_data) {
  scaled_data * attr(original_data, "scaled:scale") + attr(original_data, "scaled:center")
}

# Convert centroids back to original units
centroids_unscaled <- unscale(kmeans_result$centers, handshakes_scaled)

print("Centroids in original units:")
print(centroids_unscaled)

# Step 5c: Display the number of records in each cluster
print("Number of records in each cluster:")
print(table(kmeans_result$cluster))


