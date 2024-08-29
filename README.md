# Peace Agreement Scraping and Filtering

## Overview

Welcome to the Peace Agreement Scraping and Filtering repository. This repository contains tools and scripts for processing and filtering peace agreement data scraped from Google BigQuery. The primary script, `AgmtScrapeFiltering.R`, demonstrates how to load, filter, and export the data effectively.

### Script Information

- **Author**: Elisa D'Amico
- **Date Created**: August 29, 2024
- **Contribution to**: PeaceRep
- **Description**: This script processes data from the `"2024-JAN-AUG_AgmtScrape.xlsx"` file. If you need access to the scraping code or data for additional years or specific countries, please contact [ed248@st-andrews.ac.uk](mailto:ed248@st-andrews.ac.uk).

## Script Details

### Setup

To use the script, set your working directory to your desired path:

```r
# Set the working directory (uncomment and update the path if needed)
# setwd("path/to/your/working/directory")
```
## Loading Packages

Ensure you have the required packages installed. Uncomment and run the installation commands if necessary:

```r
# Install packages if not already installed
# install.packages("readxl")
# install.packages("dplyr")
# install.packages("writexl")

# Load necessary packages
library(readxl)
library(dplyr)
library(writexl)
```

## Loading Data

The script downloads and loads the raw data from the GitHub repository. Follow these steps to retrieve and read the data into R:

1. **Define the URL** of the raw file on GitHub:

    ```r
    url <- "https://raw.githubusercontent.com/elisadamico/Peace-Agreement-Scrape-and-Filter/main/2024-JAN-AUG_AgmtScrape.xlsx"
    ```

2. **Download the file** and read it into R:

    ```r
    # Create a temporary file with an .xlsx extension
    temp_file <- tempfile(fileext = ".xlsx")

    # Download the file from the URL
    download.file(url, destfile = temp_file, mode = "wb")

    # Read the data from the first sheet of the downloaded Excel file
    agmt_data <- read_excel(temp_file, sheet = 1)
    ```

3. **Display the loaded data** to verify its contents:

    ```r
    # View the data in RStudio
    View(agmt_data)
    ```
## Filtering Data

### Location Location & Time Filtering
To filter data by location, for example, "Israel":

   ```r
    # Print unique values from the "Location" column
    unique_locations <- unique(agmt_data$Location)
    print(unique_locations)

# Filter data to include only rows where Location is "Israel"
israel_data <- subset(agmt_data, Location == "Israel")
View(israel_data)

   ```
To filter data by month, for example, June ("06"):
   ```r
# Print unique values from the "Month" column
unique_months <- unique(agmt_data$Month)
print(unique_months)

# Filter data to include only rows where Month is "06"
june_data <- agmt_data %>%
  filter(Month == "06")
View(june_data)
```

### Text Filtering
Note: There may be some data noise from the original scrape. If you identify systematic issues or patterns that should be excluded from the "Source" headlines, adjust the words in the exclude_words vector as needed.
   ```r
# Define words to exclude
exclude_words <- c("treatment", "takeover", "suggestions", "trust", "significant")
pattern <- paste(exclude_words, collapse = "|")

# Filter out rows where the "Source" column contains any of the specified words
filtered_data_text <- agmt_data %>%
  filter(!grepl(pattern, Source, ignore.case = TRUE))
View(filtered_data_text)
```

### Combining Filters
To apply all filters at once:
   ```r
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
```


## Exporting Data
To export the filtered data to an Excel file:
   ```r
# Be sure to export the correct data frame. Here, filtered_data_all is used:
write_xlsx(filtered_data_all, path = "Filtered_AgmtData.xlsx")

# Note: Check the working directory for the exported file.
# The file "Filtered_AgmtData.xlsx" has been saved. Ensure the working directory is set correctly.
```


