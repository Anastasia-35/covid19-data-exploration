/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

 -- Checking Population Data -- 
SELECT * 
FROM PortfolioProject..[CovidDeaths (1)];

-- Exploring Covid Cases by Location and Population --
SELECT Location, Date, Total_Cases, New_Cases, Total_Deaths, Population
FROM PortfolioProject..[CovidDeaths (1)]
WHERE continent IS NOT NULL
ORDER BY 1, 2;

-- Total Cases vs Total Deaths -- 
SELECT Location, Date, Total_Cases, Total_Deaths, 
       (CAST(Total_Deaths AS FLOAT) / NULLIF(Total_Cases, 0)) * 100 AS DeathPercentage
FROM PortfolioProject..[CovidDeaths (1)]
WHERE Location LIKE '%South Africa%' AND Continent IS NOT NULL
ORDER BY 1, 2;

 -- Total Cases vs Population -- 
SELECT Location, Date, Total_Cases, Population, 
       (CAST(Total_Cases AS FLOAT) / NULLIF(Population, 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..[CovidDeaths (1)]
WHERE Location LIKE '%South Africa%' AND Continent IS NOT NULL
ORDER BY 1, 2;

 -- Country with the Highest Infection Rate vs Population -- 
SELECT Location, 
       CAST(Population AS BIGINT) AS PopulationNumeric,
       MAX(Total_Cases) AS HighestInfectionCount, 
       MAX(CAST(Total_Cases AS FLOAT) / NULLIF(CAST(Population AS BIGINT), 0)) * 100 AS PercentPopulationInfected
FROM PortfolioProject..[CovidDeaths (1)]
WHERE Continent IS NOT NULL
GROUP BY Location, CAST(Population AS BIGINT)
ORDER BY PercentPopulationInfected DESC;

-- Countries with Highest Death Count per Population -- 
SELECT Location, 
       MAX(CAST(Total_Deaths AS BIGINT)) AS TotalDeathCount, 
       MAX(CAST(Total_Deaths AS FLOAT) / NULLIF(CAST(Population AS BIGINT), 0)) * 100 AS DeathsPerPopulation
FROM PortfolioProject..[CovidDeaths (1)]
WHERE Continent IS NOT NULL
GROUP BY Location
ORDER BY DeathsPerPopulation DESC;

-- Continent Analysis: Highest Death Count per Population -- 
SELECT continent, 
       MAX(CAST(Total_Deaths AS BIGINT)) AS TotalDeathCount
FROM PortfolioProject..[CovidDeaths (1)]
WHERE Continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global Numbers: Total Cases and Deaths -- 
SELECT 
    SUM(CAST(New_Cases AS INT)) AS Total_Cases, 
    SUM(CAST(New_Deaths AS INT)) AS Total_Deaths
FROM PortfolioProject..[CovidDeaths (1)]
WHERE Continent IS NOT NULL;

-- Total Population vs Vaccination Data -- 
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations,
       SUM(CONVERT(INT, vac.new_vaccinations)) 
           OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..[CovidDeaths (1)] dea
JOIN PortfolioProject..[CovidVaccinations (1)] vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY dea.location, dea.date;

 -- Using CTE for Rolling Vaccination Calculation --
WITH PopvsVac AS
(
    SELECT dea.continent, 
           dea.location, 
           dea.date, 
           CAST(dea.population AS BIGINT) AS Population, 
           vac.new_vaccinations,
           SUM(CAST(vac.new_vaccinations AS BIGINT)) 
               OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.Date) AS RollingPeopleVaccinated
    FROM PortfolioProject..[CovidDeaths (1)] dea
    JOIN PortfolioProject..[CovidVaccinations (1)] vac
        ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
)
SELECT *, 
       (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(CAST(Population AS FLOAT), 0)) * 100 AS VaccinationPercentage
FROM PopvsVac
ORDER BY Location, Date;

 -- Using Temp Table for Vaccination Data -- 
DROP TABLE IF EXISTS #PercentPopulationVaccinated;

CREATE TABLE #PercentPopulationVaccinated
(
    Continent NVARCHAR(255),
    Location NVARCHAR(255),
    Date DATETIME,
    Population NUMERIC(18, 2),
    New_Vaccinations NUMERIC(18, 2),
    RollingPeopleVaccinated NUMERIC(18, 2)
);

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       CAST(dea.population AS NUMERIC(18, 2)) AS Population, 
       CAST(vac.new_vaccinations AS NUMERIC(18, 2)) AS New_Vaccinations,
       SUM(CAST(vac.new_vaccinations AS BIGINT)) 
           OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..[CovidDeaths (1)] dea
JOIN PortfolioProject..[CovidVaccinations (1)] vac
    ON dea.location = vac.location
    AND dea.date = vac.date;

SELECT *, 
       (CAST(RollingPeopleVaccinated AS FLOAT) / NULLIF(CAST(Population AS FLOAT), 0)) * 100 AS VaccinationPercentage
FROM #PercentPopulationVaccinated;

-- Creating a View for Percent Population Vaccinated -- 
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       CAST(dea.population AS NUMERIC(18, 2)) AS Population, 
       CAST(vac.new_vaccinations AS NUMERIC(18, 2)) AS New_Vaccinations,
       SUM(CAST(vac.new_vaccinations AS BIGINT)) 
           OVER (PARTITION BY dea.Location ORDER BY dea.Location, dea.Date) AS RollingPeopleVaccinated
FROM PortfolioProject..[CovidDeaths (1)] dea
JOIN PortfolioProject..[CovidVaccinations (1)] vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT TOP 10 *
FROM PercentPopulationVaccinated;
