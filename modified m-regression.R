# ---- 1. Setup and Data Import ----
# Install and load required packages
install.packages(c("dplyr", "ggplot2", "lubridate", "plotly"))
library(dplyr)
library(ggplot2)
library(lubridate)
library(plotly)

# Read data from CSV file (replace with your file path)
data <- read.csv("E:/R/MR2022.csv")

# Convert Dates to date format and create Month variable
data$Dates <- as.Date(data$Dates, format = "%d/%m/%Y")
data$Month <- month(data$Dates)

# ---- 2. Descriptive Analysis ----
# Summary statistics
summary(data)

# Price trends over time (example for Bull)
ggplot(data, aes(x = Dates, y = Bull)) +
  geom_line() +
  labs(x = "Date", y = "Bull Price")

# Seasonality (example for Bull)
ggplot(data, aes(x = Month, y = Bull)) +
  geom_boxplot() +
  labs(x = "Month", y = "Bull Price")

# Drought impact (example for Bull)
ggplot(data, aes(x = Seasons, y = Bull, fill = Seasons)) +
  geom_boxplot() +
  labs(x = "Season", y = "Bull Price")

# ---- 3. Multiple Regression Model ----
# Fit the model
model <- lm(Bull ~ Seasons + Cow + Heifer + Steer + Month, data = data)
summary(model)

# ---- 4. Prediction and Visualization ----
# Get predicted values and confidence intervals
predictions <- predict(model, data, interval = "confidence")

# Create data frame with predictions
pred_df <- data.frame(actual = data$Bull,
                      predicted = predictions[,1],
                      lower = predictions[,2],
                      upper = predictions[,3])

# Create interactive plot with plotly
plot_ly(pred_df, x = ~actual, y = ~predicted, 
        error_y = ~list(array = lower, arrayminus = upper),
        type = "scatter", mode = "markers",
        marker = list(size = 8)) %>%
  add_trace(x = ~actual, y = ~actual, type = "scatter", mode = "lines",
            line = list(color = "red")) %>%
  layout(title = "Predicted vs. Actual Bull Price",
         xaxis = list(title = "Actual Price"),
         yaxis = list(title = "Predicted Price"))