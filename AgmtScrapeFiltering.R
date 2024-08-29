# ---- SCRIPT INFORMATION ----
# Author: Elisa D'Amico
# Date Created: August 29, 2024
# Contribution to: PeaceRep
# Description: This script processes data from the "2024-JAN-AUG_AgmtScrape.xlsx" file,
#              which was initially scraped from Google BigQuery. For access to the scraping
#              code on that platform, please contact ed248@st-andrews.ac.uk.
#              If you require data for additional years or specific countries, please also 
#              reach out to me for further assistance.


# ---- SETUP ----
# Set the working directory (uncomment and update the path if needed)
# setwd("path/to/your/working/directory")


# ---- LOADING PACKAGES ----
# Install packages if not already installed

# install.packages("readxl")
# install.packages("dplyr")
# install.packages("writexl")

# Load necessary packages
library(readxl)
library(dplyr)
library(writexl)



# ---- LOAD DATA ----
# Define URL of the raw file on GitHub
url <- "https://raw.githubusercontent.com/elisadamico/Peace-Agreement-Scrape-and-Filter/main/2024-JAN-AUG_AgmtScrape.xlsx"

# Download the file and read it into R
temp_file <- tempfile(fileext = ".xlsx")
download.file(url, destfile = temp_file, mode = "wb")
agmt_data <- read_excel(temp_file, sheet = 1)

# Display the loaded data
View(agmt_data)


# ---- LOCATION FILTERING ----
# Print unique values from the "Location" column
unique_locations <- unique(agmt_data$Location)
print(unique_locations)

# Filter data to include only rows where Location is "Israel"
israel_data <- subset(agmt_data, Location == "Israel")
View(israel_data)


# ---- LOCATION & TIME FILTERING ----
# Print unique values from the "Month" column
unique_months <- unique(agmt_data$Month)
print(unique_months)

# Filter data to include only rows where Month is "06"
june_data <- agmt_data %>%
  filter(Month == "06")
View(june_data)


# ---- TEXT FILTERING ----
# Note: There may be some data noise present from the original scrape.
#       If you identify any systematic issues or patterns that should be excluded from the "Source" headlines,
#       consider filtering out those terms as demonstrated below. Adjust the words in the 'exclude_words' vector
#       to better suit your data cleaning needs.

# Define words to exclude
exclude_words <- c("treatment", "takeover", "suggestions", "trust", "significant")
pattern <- paste(exclude_words, collapse = "|")

# Filter out rows where the "Source" column contains any of the specified words
filtered_data_text <- agmt_data %>%
  filter(!grepl(pattern, Source, ignore.case = TRUE))
View(filtered_data_text)


# ---- FILTERING ALL ----
# Define the filters
location_filter <- "Israel"
month_filter <- "06"
exclude_words <- c("treatment", "takeover", "suggestions", "trust", "significant")
pattern <- paste(exclude_words, collapse = "|")

# Apply filters to the data
filtered_data_all <- agmt_data %>%
  filter(Location == location_filter, 
         Month == month_filter, 
         !grepl(pattern, Source, ignore.case = TRUE))
View(filtered_data_all)


# ---- EXPORT DATA ----
# Be sure to export the correct data frame. Here, filtered_data_all is used:
write_xlsx(filtered_data_all, path = "Filtered_AgmtData.xlsx")

# Note: Check the working directory for the exported file.
# The file "Filtered_AgmtData.xlsx" has been saved. Ensure the working directory is set correctly.