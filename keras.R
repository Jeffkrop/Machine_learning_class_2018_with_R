
#https://www.datacamp.com/community/tutorials/keras-r-deep-learning

#install_tensorflow()
#install_keras()
library(keras)
library(tensorflow)



#Read in iris data
iris <- read.csv(url("http://archive.ics.uci.edu/ml/machine-learning-databases/iris/iris.data"), header = FALSE) 



names(iris) <- c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "Species")

plot(iris$Petal.Length, 
     iris$Petal.Width, 
     pch=21, bg=c("red","green3","blue")[unclass(iris$Species)], 
     xlab="Petal Length", 
     ylab="Petal Width")

#correlation between petal length and petal width
cor(iris$Petal.Length, iris$Petal.Width)


# Build your own `normalize()` function
normalize <- function(x) {
  num <- x - min(x)
  denom <- max(x) - min(x)
  return (num/denom)
}

# Normalize the `iris` data
iris_norm <- as.data.frame(lapply(iris[1:4], normalize))




#normalizing with keras must be a matrix
iris[,5] <- as.numeric(iris[,5]) -1

# Turn `iris` into a matrix
iris_norm <- as.matrix(iris)

# Set iris `dimnames` to `NULL` Removes calumn names
dimnames(iris_norm) <- NULL

# Normalize the `iris` data
iris <- normalize(iris[,1:4])


# Determine sample size
ind <- sample(2, nrow(iris), replace=TRUE, prob=c(0.67, 0.33))

# Split the `iris` data
iris.training <- iris_norm[ind==1, 1:4]
iris.test <- iris_norm[ind==2, 1:4]

# Split the class attribute
iris.trainingtarget <- iris[ind==1, 5]
iris.testtarget <- iris[ind==2, 5]


# One hot encode training target values
iris.trainLabels <- to_categorical(iris.trainingtarget)

# One hot encode test target values
iris.testLabels <- to_categorical(iris.testtarget)

# Print out the iris.testLabels to double check the result
#print(iris.testLabels)

# Initialize a sequential model
model <- keras_model_sequential() 

# Add layers to the model
model %>% 
  layer_dense(units = 8, activation = 'relu', input_shape = c(4)) %>% 
  layer_dense(units = 3, activation = 'softmax')

#Note how the output layer creates 3 output values, one for each Iris class (versicolor, virginica or setosa). The first layer, which contains 8 hidden notes, on the other hand, has an input_shape of 4. This is because your training data iris.training has 4 columns.


# Print a summary of a model
summary(model)

# Get model configuration
get_config(model)

# Get layer configuration
get_layer(model, index = 1)

# List the model's layers
model$layers

# List the input tensors
model$inputs

# List the output tensors
model$outputs


#categorical_crossentropy loss function for the multi-class classification problem of determining whether an iris is of type versicolor, virginica or setosa
#if you would have had a binary-class classification problem, you should have made use of the binary_crossentropy loss function.
# Compile the model
model %>% compile(loss = 'categorical_crossentropy',
                  optimizer = 'adam',
                  metrics = 'accuracy'
                  )


#What you do with the code above is training the model for a specified number of epochs or exposures to the training dataset. An epoch is a single pass through the entire training set, followed by testing of the verification set. The batch size that you specify in the code above defines the number of samples that going to be propagated through the network. Also, by doing this, you optimize the efficiency because you make sure that you don’t load too many input patterns into memory at the same time.


# Store the fitting history in `history` 
history <- model %>% fit(
  iris.training, 
  iris.trainLabels, 
  epochs = 200,
  batch_size = 5, 
  validation_split = 0.2
)

# Plot the history
plot(history)

#the loss and acc indicate the loss and accuracy of the model for the training data, while the val_loss and val_acc are the same metrics, loss and accuracy, for the test or validation data.


# Plot the model loss of the training data
plot(history$metrics$loss, main="Model Loss", xlab = "epoch", ylab="loss", col="blue", type="l")

# Plot the model loss of the test data
lines(history$metrics$val_loss, col="green")

# Add legend
legend("topright", c("train","test"), col=c("blue", "green"), lty=c(1,1))




# Plot the accuracy of the training data 
plot(history$metrics$acc, main="Model Accuracy", xlab = "epoch", ylab="accuracy", col="blue", type="l")

# Plot the accuracy of the validation data
lines(history$metrics$val_acc, col="green")

# Add Legend
legend("bottomright", c("train","test"), col=c("blue", "green"), lty=c(1,1))

#If your training data accuracy keeps improving while your validation data accuracy gets worse, you are probably overfitting: your model starts to just memorize the data instead of learning from it.

#If the trend for accuracy on both datasets is still rising for the last few epochs, you can clearly see that the model has not yet over-learned the training dataset.


# Predict the classes for the test data
classes <- model %>% predict_classes(iris.test, batch_size = 128)

# Confusion matrix
table(iris.testtarget, classes)

# Evaluate on test data and labels
score <- model %>% evaluate(iris.test, iris.testLabels, batch_size = 128)

# Print the score
print(score)



#Adding Layers
# Initialize the sequential model
model <- keras_model_sequential() 

# Add layers to model
model %>% 
  layer_dense(units = 8, activation = 'relu', input_shape = c(4)) %>% 
  layer_dense(units = 5, activation = 'relu') %>% 
  layer_dense(units = 3, activation = 'softmax')

# Compile the model
model %>% compile(loss = 'categorical_crossentropy',
                  optimizer = 'adam',
                  metrics = 'accuracy'
                  )

# Fit the model to the data
model %>% fit(iris.training, iris.trainLabels, 
              epochs = 200, batch_size = 5, 
              validation_split = 0.2
              )


# Predict the classes for the test data
classes <- model %>% predict_classes(iris.test, batch_size = 128)

# Confusion matrix
table(iris.testtarget, classes)

# Evaluate the model
score <- model %>% evaluate(iris.test, iris.testLabels, batch_size = 128)

# Print the score
print(score)



#Hidden Units
# Initialize a sequential model
model <- keras_model_sequential() 

# Add layers to the model
model %>% 
  layer_dense(units = 28, activation = 'relu', input_shape = c(4)) %>% 
  layer_dense(units = 3, activation = 'softmax')

# Compile the model
model %>% compile(
  loss = 'categorical_crossentropy',
  optimizer = 'adam',
  metrics = 'accuracy'
)

# Fit the model to the data
model %>% fit(
  iris.training, iris.trainLabels, 
  epochs = 200, batch_size = 5, 
  validation_split = 0.2
)

# Predict the classes for the test data
classes <- model %>% predict_classes(iris.test, batch_size = 128)

# Confusion matrix
table(iris.testtarget, classes)

# Evaluate the model
score <- model %>% evaluate(iris.test, iris.testLabels, batch_size = 128)

# Print the score
print(score)




#Optimization Parameters
# Initialize a sequential model
model <- keras_model_sequential() 

# Build up your model by adding layers to it
model %>% 
  layer_dense(units = 8, activation = 'relu', input_shape = c(4)) %>% 
  layer_dense(units = 3, activation = 'softmax')

# Define an optimizer
sgd <- optimizer_sgd(lr = 0.01)

# Use the optimizer to compile the model
model %>% compile(optimizer=sgd, 
                  loss='categorical_crossentropy', 
                  metrics='accuracy')

# Fit the model to the training data
model %>% fit(
  iris.training, iris.trainLabels, 
  epochs = 200, batch_size = 5, 
  validation_split = 0.2
)

# Predict the classes for the test data
classes <- model %>% predict_classes(iris.test, batch_size = 128)

# Confusion matrix
table(iris.testtarget, classes)

# Evaluate the model
score <- model %>% evaluate(iris.test, iris.testLabels, batch_size = 128)

# Print the loss and accuracy metrics
print(score)

















