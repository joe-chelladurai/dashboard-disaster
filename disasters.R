# Load required libraries
library(sf)
library(geojsonsf)
library(tidyverse)
library(disastr.api)
library(countrycode)

# Read GeoJSON data
geojson_data <- st_read("https://raw.githubusercontent.com/joe-chelladurai/home-page/main/layer.geojson")

# Convert GeoJSON data to tibble
geojson_tibble <- as_tibble(geojson_data)
data_geo <- geojson_tibble

# Fetch disaster data from API
data <- disastr.api(limit = 1000) |> 
  unnest(cols = c(id, date, country, name, event, status, url))

# Convert country names to ISO3 codes
data$country_code <- countrycode(data$country, "country.name", "iso3c")
data_geo$country_code <- countrycode(data_geo$SOVEREIGNT, "country.name", "iso3c")

# Filter and select relevant columns from disaster data
data2 <- data |> 
  filter(status == "ongoing") |> 
  select(country_code, name, event, url, status) |> 
  group_by(country_code) |> 
  slice(1)

# Join disaster data with GeoJSON data
data_geo2 <- data_geo |> 
  left_join(data2, by = "country_code")

# Add new columns for disaster name and ongoing status
data_geo2 <- data_geo2 |> 
  mutate(
    name2 = case_when(is.na(name) ~ "-", TRUE ~ name),
    ongoing = case_when(status == "ongoing" ~ 1, TRUE ~ 0),
    card_country = str_trim(str_extract(name2, "^[^:]+")),
    card_event = str_trim(str_extract(name2, "(?<=: ).+?(?= -)")),
    card_monthyear = str_trim(str_extract(name2, "(?<= - ).+$"))
  )

# Check if the file exists and delete if it does
output_file <- "disasters.geojson"
if (file.exists(output_file)) {
    file.remove(output_file)
}

write.csv(data_geo2, "disasters.csv")
# Write the modified data to a new GeoJSON file
data_geo2 |> 
  select(-name) |> 
  st_write(output_file)

# Print out some rows to verify
print(data_geo2 |> select(SOVEREIGNT, card_country, card_event, card_monthyear, ongoing))
