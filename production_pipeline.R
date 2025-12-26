suppressPackageStartupMessages({
  library(tidyverse)
  library(gganimate)
  library(scales)
  library(broom)
  library(gifski)
})

CONFIG <- list(
  # Added the closing quote below
  INPUT_FILE = "./data/m1.csv", 
  OUTPUT_GIF = "./output/covid_deaths.gif",
  OUTPUT_CSV = "./output/regressionResults.csv",
  COUNTRIES  = c("USA", "Israel", "France", "Italy", "Spain", 
                 "Mainland China", "Germany", "Japan", "UK")
)


Load_Data <- function(file_path){
  if (!file.exists(file_path)){stop(" error: the file does not exist!")}
  file_data <- read.csv(file_path, stringsAsFactors = False)
  return (file_data)
}

clean_data <- function(raw_data, target_countries){
  clean_df <- raw_data%>%
    filter(country %in% target_countries)%>%
    mutate(
      date = as.Date(date)
      cases = cases + 1
      deaths = deaths + 1
    )
  return(clean_df)
}

generate_plot <- function(covid_data){ 
  p <- ggplot(covid_data, aes(x= cases, y= deaths, colour = country, size = per100k)) + geompoint(alpha = 0.7) + scale_size(range = c(2, 12)) +
    scale_x_log10(name = "Cases (Log Scale)") + 
    scale_y_log10(name = "Deaths (Log Scale)") + 
    theme_minimal() + 
    labs(title = "Date: {frame_time}", subtitle = "Global COVID-19 Progression") +
    transition_time(date) +
    ease_aes("linear")
  
  return(p)
  
}

