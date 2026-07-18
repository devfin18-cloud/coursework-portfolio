# Load libraries
library(FNN)
library(class)


movies <- read.csv("~/Desktop/Fin -365/Week 7 - Breakout Exercise DataSet Movies.csv")
new_movies <- read.csv("~/Desktop/Fin -365/Week 7 - Breakout Exercise DataSet NewMovies.csv")

movies <- movies[, !(names(movies) %in% c("Year", "Title"))]
new_movies <- new_movies[, !(names(new_movies) %in% c("Year", "Title"))]

set.seed(123)

sample_index <- sample(1:nrow(movies), 0.8 * nrow(movies))
train <- movies[sample_index, ]
test <- movies[-sample_index, ]

train_X <- train[, -which(names(train) == "Winner")]
train_Y <- train$Winner
test_X <- test[, -which(names(test) == "Winner")]
test_Y <- test$Winner

knn_pred <- knn(train = train_X, test = test_X, cl = train_Y, k = 3)

print(table(Predicted = knn_pred, Actual = test_Y))

new_pred <- knn(train = train_X, test = new_movies, cl = train_Y, k = 3)
new_pred  # 0 = No Award, 1 = Wins Award

