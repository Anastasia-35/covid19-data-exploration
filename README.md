# 🦠 COVID-19 Data Exploration (SQL Project)

## 📌 Project Overview

This project explores global COVID-19 data using SQL Server to analyze infection rates, death rates, and vaccination progress across countries and continents.

The analysis focuses on understanding:

- Infection trends over time
- Death percentages by country
- Population infection rates
- Vaccination rollouts
- Global case and death totals

This project demonstrates practical data analysis skills using advanced SQL techniques.

---

## 🛠️ Skills & Concepts Used

- Joins  
- Common Table Expressions (CTEs)  
- Temporary Tables  
- Window Functions  
- Aggregate Functions  
- Creating Views  
- Data Type Conversion  
- NULL handling with `NULLIF`  
- Rolling calculations  

---

## 🗂️ Dataset Used

The project uses two main tables:

### CovidDeaths
Contains:
- Location
- Date
- Total cases
- New cases
- Total deaths
- Population
- Continent

###  CovidVaccinations
Contains:
- Location
- Date
- New vaccinations

These tables were stored in SQL Server under:

PortfolioProject..[CovidDeaths (1)]  
PortfolioProject..[CovidVaccinations (1)]

---

##  Key Analysis Performed

###  1. Total Cases vs Total Deaths
Calculated death percentage per country:

(Total_Deaths / Total_Cases) * 100

Used `NULLIF` to prevent division-by-zero errors.

---

###  2. Total Cases vs Population
Measured percentage of population infected:

(Total_Cases / Population) * 100

---

###  3. Countries with Highest Infection Rate
Used `GROUP BY` and `MAX()` to identify countries most affected relative to their population.

---

###  4. Countries with Highest Death Count
Calculated total deaths and deaths per population percentage.

---

###  5. Continent-Level Analysis
Aggregated total deaths by continent.

---

###  6. Global Totals
Used `SUM()` to compute total global cases and deaths.

---

###  7. Vaccination Rollout Analysis
Joined death and vaccination datasets to compute cumulative vaccinations over time.

Used a window function:

SUM(new_vaccinations)  
OVER (PARTITION BY Location ORDER BY Date)

This allowed tracking rolling vaccination progress per country.

---

###  8. CTE Implementation
Created a CTE (PopvsVac) to calculate vaccination percentages cleanly and efficiently.

---

###  9. Temporary Table Usage
Used #PercentPopulationVaccinated to store intermediate vaccination calculations.

---

###  10. View Creation
Created a reusable SQL view:

CREATE VIEW PercentPopulationVaccinated AS ...

This allows future analysis without rewriting complex joins.

---

##  What This Project Demonstrates

This project showcases:

- Strong understanding of SQL data exploration
- Ability to clean and convert data types
- Knowledge of analytical SQL patterns
- Experience working with real-world datasets
- Understanding of rolling metrics and cumulative analysis

---

##  How to Run This Project

1. Open SQL Server Management Studio (SSMS)
2. Import the COVID datasets into your database
3. Run the queries in order
4. Modify queries to explore additional insights

---

##  Future Improvements

- Create dashboards in Power BI or Tableau
- Add trend analysis visualizations
- Include mortality rate comparisons by region
- Add time-based growth rate calculations



## Author

Anastasia   
Aspiring Data Scientist
