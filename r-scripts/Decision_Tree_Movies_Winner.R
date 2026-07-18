# Load the required library
library(tree)

movies <- read.csv("~/Desktop/Fin -365/Week 7 - Breakout Exercise DataSet Movies.csv")
new_movies <- read.csv("~/Desktop/Fin -365/Week 7 - Breakout Exercise DataSet NewMovies.csv")

movies <- movies[, !(names(movies) %in% c("Year", "Title"))]
new_movies <- new_movies[, !(names(new_movies) %in% c("Year", "Title"))]

set.seed(123)

sample_index <- sample(1:nrow(movies), 0.8 * nrow(movies))
train <- movies[sample_index, ]
test <- movies[-sample_index, ]

tree_model <- tree(as.factor(Winner) ~ ., data = train)

plot(tree_model)
text(tree_model, pretty = 0)

tree_preds <- predict(tree_model, new_movies, type = "class")
tree_preds

