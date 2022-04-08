# YA-Rent-Prediction
## The final product:  https://jappia.shinyapps.io/YARentPredictionApp/
In this project, I scraped YA website for students apartment data to predict rental cost. I preprocess the data to handle missing values and data inconsistency.
To start my modeling, I first create a train and test set as well as a validation set using k-folds cross-validation. 
I then create two models: an XGBoost model and a Random Forest model. I train the models and evaluate the models performance based on the rmse and r squared metrics. 
After modeling, I create an R Shiny App using shinydashboard and deploy the final model for real-time predictions.
