# Annual CO2 emissions in Chile, 1990-2024
# Data source: Our World in Data Grapher
# Run this script from the repository root.

# 1. Install and load required packages
packages <- c("tidyverse", "scales")
missing_packages <- packages[!packages %in% rownames(installed.packages())]
if (length(missing_packages) > 0) {
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}
invisible(lapply(packages, library, character.only = TRUE))

# 2. Study parameters and output directory
country_code <- "CHL"
start_year <- 1990
end_year <- 2024
output_dir <- "outputs"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

# 3. Download the OWID dataset
data_url <- paste0(
  "https://ourworldindata.org/grapher/annual-co2-emissions-per-country.csv",
  "?v=1&csvType=full&useColumnShortNames=true"
)
owid_data <- readr::read_csv(data_url, show_col_types = FALSE)

# 4. Identify the annual CO2 emissions variable
column_names <- names(owid_data)
preferred <- c("co2", "annual_co2_emissions")
matches <- preferred[preferred %in% column_names]
if (length(matches) > 0) {
  emissions_column <- matches[1]
} else {
  candidates <- column_names[
    stringr::str_detect(
      stringr::str_to_lower(column_names),
      "co2|carbon_dioxide"
    )
  ]
  candidates <- setdiff(candidates, c("Entity", "Code", "Year"))
  if (length(candidates) == 0) {
    stop("CO2 emissions column not found. Columns: ",
         paste(column_names, collapse = ", "))
  }
  emissions_column <- candidates[1]
}

# 5. Filter Chile and the study period
chile_data <- owid_data %>%
  dplyr::filter(
    Code == country_code,
    Year >= start_year,
    Year <= end_year
  ) %>%
  dplyr::transmute(
    country = Entity,
    year = as.integer(Year),
    co2_tonnes = as.numeric(.data[[emissions_column]])
  ) %>%
  dplyr::filter(!is.na(co2_tonnes)) %>%
  dplyr::arrange(year)

if (nrow(chile_data) == 0) {
  stop("No Chile data found for the selected years.")
}

missing_years <- setdiff(start_year:end_year, chile_data$year)
if (length(missing_years) > 0) {
  warning("Missing year(s): ", paste(missing_years, collapse = ", "))
}

# 6. Calculate emissions in million tonnes and annual percentage change
chile_data <- chile_data %>%
  dplyr::mutate(
    co2_million_tonnes = co2_tonnes / 1e6,
    percent_change = (co2_tonnes / dplyr::lag(co2_tonnes) - 1) * 100
  )

# 7. Descriptive statistics and data export
summary_table <- chile_data %>%
  dplyr::summarise(
    country = "Chile",
    first_year = min(year),
    last_year = max(year),
    observations = dplyr::n(),
    mean_annual_emissions_tonnes = mean(co2_tonnes),
    median_annual_emissions_tonnes = median(co2_tonnes),
    minimum_emissions_tonnes = min(co2_tonnes),
    maximum_emissions_tonnes = max(co2_tonnes),
    first_year_emissions_tonnes = co2_tonnes[which.min(year)],
    last_year_emissions_tonnes = co2_tonnes[which.max(year)]
  )

readr::write_csv(chile_data, file.path(output_dir, "chile_co2_data_1990_2024.csv"))
readr::write_csv(summary_table, file.path(output_dir, "descriptive_statistics.csv"))

# 8. Plot annual CO2 emissions
emissions_plot <- ggplot2::ggplot(
  chile_data,
  ggplot2::aes(x = year, y = co2_million_tonnes)
) +
  ggplot2::geom_line(linewidth = 0.9) +
  ggplot2::geom_point(size = 1.8) +
  ggplot2::scale_x_continuous(breaks = seq(start_year, end_year, by = 5)) +
  ggplot2::labs(
    title = "Annual CO2 Emissions in Chile (1990-2024)",
    subtitle = "Fossil fuels and industry; land-use change is excluded",
    x = "Year",
    y = "CO2 emissions (million tonnes)",
    caption = "Source: Our World in Data"
  ) +
  ggplot2::theme_minimal(base_size = 12)

ggplot2::ggsave(
  file.path(output_dir, "chile_annual_co2_emissions.png"),
  emissions_plot, width = 9, height = 5.5, dpi = 300
)

# 9. Plot year-to-year percentage change
change_plot <- chile_data %>%
  dplyr::filter(!is.na(percent_change)) %>%
  ggplot2::ggplot(ggplot2::aes(x = year, y = percent_change)) +
  ggplot2::geom_hline(yintercept = 0, linewidth = 0.4) +
  ggplot2::geom_col() +
  ggplot2::scale_x_continuous(breaks = seq(start_year, end_year, by = 5)) +
  ggplot2::labs(
    title = "Year-to-Year Change in Chile's CO2 Emissions",
    x = "Year",
    y = "Change from previous year (%)",
    caption = "Calculated from annual CO2 emissions reported by OWID"
  ) +
  ggplot2::theme_minimal(base_size = 12)

ggplot2::ggsave(
  file.path(output_dir, "chile_co2_year_to_year_change.png"),
  change_plot, width = 9, height = 5.5, dpi = 300
)

# 10. Print results
print(summary_table)
print(emissions_plot)
print(change_plot)
message("Analysis complete. See the outputs/ folder for charts and CSV files.")
