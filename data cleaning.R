# ---- 1. Load Libraries and Data ----
# Install necessary packages (if not already installed)
install.packages(c("dplyr", "tidyr", "stringr"))

# Load libraries
library(dplyr)
library(tidyr)
library(stringr)

# Read data (replace with your file path and appropriate function)
data <- read.csv("E:/R/MR2022.csv")

# ---- 2. Initial Data Inspection ----
# View data structure
str(data)

# Summary statistics
summary(data)

# Check for missing values
sum(is.na(data))

# View first few rows
head(data)

# ---- 3. Cleaning Quantitative Variables ----
# Handle missing values (choose appropriate method for your data)
# - Imputation (mean, median, mode, KNN, etc.)
data <- data %>%
  mutate(variable_name = ifelse(is.na(variable_name), mean(variable_name, na.rm = TRUE), variable_name))

# - Removal
data <- data %>%
  filter(!is.na(variable_name))

# Outlier detection and handling (e.g., boxplot, z-score)
# - Winsorizing
data <- data %>%
  mutate(variable_name = winsorize(variable_name, probs = c(0.05, 0.95)))

# - Removal
data <- data %>%
  filter(variable_name > lower_bound & variable_name < upper_bound)

# Variable transformations (if needed, e.g., log, square root)
data <- data %>%
  mutate(variable_name = log(variable_name))

# ---- 4. Cleaning Qualitative Variables ----
# Standardize capitalization
data <- data %>%
  mutate(variable_name = str_to_lower(variable_name))

# Remove leading/trailing whitespace
data <- data %>%
  mutate(variable_name = str_trim(variable_name))

# Correct typos and inconsistencies
# - Manual correction (if few instances)
data <- data %>%
  mutate(variable_name = recode(variable_name,
                                "mispelled_value" = "correct_value"))

# - Fuzzy matching
install.packages("fuzzyjoin")
library(fuzzyjoin)
data <- data %>%
  stringdist_left_join(reference_data, 
                       by = c("variable_name" = "reference_variable"),
                       max_dist = 0.2) %>%
  mutate(variable_name = ifelse(!is.na(reference_variable), reference_variable, variable_name))

# Handle inconsistencies in categories (e.g., "N/A", "Unknown")
data <- data %>%
  mutate(variable_name = na_if(variable_name, "N/A")) 

# ---- 5. Final Data Inspection and Export ----
# Check structure and summary again
str(data)
summary(data)

# Write cleaned data to a new file
write.csv(data, "cleaned_data.csv", row.names = FALSE)