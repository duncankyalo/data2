library(ncdf4) # For reading NetCDF files
library(writexl) # For writing Excel files

# Replace with your NetCDF file path
nc_file <- "E:/R/QC_sonde_training_data.nc"

# Open the NetCDF file
nc_data <- nc_open(nc_file)

# Get variable names
variable_names <- names(nc_data$var)

# Extract data for each variable and store as a list of data frames
data_list <- lapply(variable_names, function(var_name) {
  data <- ncvar_get(nc_data, var_name)
  # Add dimension information as columns (if needed)
  # ... (Logic to extract and add dimension values as columns) ...
  as.data.frame(data)
})

# Close the NetCDF file
nc_close(nc_data)

# Name the list elements (data frames) using variable names
names(data_list) <- variable_names
# Replace with your desired Excel file path
excel_file <- "E:/R/nc.xlsx"

# Write each data frame as a separate sheet in the Excel file
writexl::write_xlsx(data_list, path = excel_file)
