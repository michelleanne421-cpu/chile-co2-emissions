# Trends in Annual CO₂ Emissions in Chile (1990–2024)

## Research question
How did Chile's annual carbon dioxide (CO₂) emissions change from 1990 through 2024?

## Study details
- **Country:** Chile
- **ISO-3 code:** CHL
- **Study period:** 1990–2024
- **Main variable:** Annual CO₂ emissions
- **Data source:** Our World in Data (OWID)

## Dataset
The analysis downloads the OWID Grapher dataset directly:

- [Annual CO₂ emissions](https://ourworldindata.org/grapher/annual-co2-emissions-per-country)
- [CSV data](https://ourworldindata.org/grapher/annual-co2-emissions-per-country.csv?v=1&csvType=full&useColumnShortNames=true)

The measure covers CO₂ emissions from fossil fuels and industry. It does not represent all greenhouse gases and excludes land-use change and forestry. Check the dataset's metadata when interpreting the results.

## Repository structure
- `R/chile_co2_analysis.R` — reproducible R script for data retrieval, cleaning, summary statistics, and visualizations.
- `outputs/` — generated figures and CSV summary tables (created when the R script is run).

## How to reproduce the analysis
1. Install [R](https://cran.r-project.org/) and [RStudio](https://posit.co/download/rstudio-desktop/).
2. Clone or download this repository.
3. Open `R/chile_co2_analysis.R` in RStudio.
4. Run the script from top to bottom. It installs missing packages, downloads the dataset, filters Chile, and saves the outputs in `outputs/`.
5. Review the generated charts and summary CSV files.

## Analysis outputs
When the script finishes, it creates:
- Annual CO₂ emissions trend (1990–2024)
- Year-to-year percentage change
- Descriptive summary statistics
- The filtered Chile dataset

## Scope and limitations
This is a country-level time-series analysis of annual CO₂ emissions. It describes changes over time but does not, by itself, establish the causes of those changes. The selected period is 1990–2024; revise the year range if the course handout specifies a different period or variable.

## Author
Prepared as an individual course activity.
