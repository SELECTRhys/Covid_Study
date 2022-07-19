SELECT *
FROM Covid_Deaths

SELECT *
FROM Covid_Vaccinations

SELECT Location, Date, New_Cases, Total_Deaths, Population
FROM CovidPortfolio..Covid_Deaths
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows percentage of population that has contracted COVID19

SELECT Location, Date, total_cases, total_deaths, population, (total_cases/population)*100 as Death_Percent
FROM CovidPortfolio..Covid_Deaths
WHERE Location = 'Canada'
AND Continent IS NOT NULL
ORDER BY DATE DESC

-- Looking at countries with highest infection rate compared to population
-- Which countries in North America have the highest infection rate when compared to population, where population is over 10,000,000. List in order.

SELECT Continent, Location, MAX(total_cases) as Highest_Infection_Count, population, MAX((total_cases/population))*100 as Percentage_Pop_Infected
FROM CovidPortfolio..Covid_Deaths
GROUP BY Location, Population, Continent
HAVING Population > 10000000 AND continent = 'North America'
ORDER BY Percentage_Pop_Infected DESC

-- Reviewing which Countries have the Highest Number of Deaths

SELECT Location, MAX(cast(Total_deaths as int)) as Total_Death_Count
FROM CovidPortfolio..Covid_Deaths
WHERE Continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC

-- Which Countries have Completed Zero Reportings on COVID19 Cases & Deaths

SELECT Location, MAX(total_cases), MAX(total_deaths)
FROM CovidPortfolio..Covid_Deaths
GROUP BY location
HAVING MAX(total_cases) IS NULL AND MAX(total_deaths) IS NULL

-- Reviewing which Continents have the Highest Number of Deaths
SELECT Continent, MAX(cast(Total_deaths as int)) as Total_Death_Count
FROM CovidPortfolio..Covid_Deaths
WHERE Continent IS NOT NULL
GROUP BY Continent
ORDER BY 2 DESC

-- How Many Deaths Per Day Across the World Due to COVID19
SELECT Date, SUM(New_Cases), SUM(CAST(New_Deaths AS INT)), SUM(CAST(New_Deaths AS INT))/SUM(New_Cases)*100 AS World_Death_Percentage
FROM CovidPortfolio..Covid_Deaths
WHERE CONTINENT IS NOT NULL
GROUP BY Date
ORDER BY 1 DESC

-- Joining the Two Tables on Multiple Columns

SELECT *
FROM CovidPortfolio..Covid_Deaths AS Dea
JOIN CovidPortfolio..Covid_Vaccinations AS Vac
	ON dea.location = vac.location
	AND dea.date = vac.date

-- Rolling Count Over Time of Vaccinations in Canada

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition By dea.location ORDER BY dea.location, dea.date) AS Rolling_List_Vaccinations
FROM CovidPortfolio..Covid_Deaths AS Dea
JOIN CovidPortfolio..Covid_Vaccinations AS Vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.location = 'Canada'
ORDER BY 2,3 DESC

-- Using CTE to Work Out Number of Vaccinations That Have Been Processed Per Resident in Canada. Processed as a Rolling Average

WITH Pop_V_Vac (Continent, Location, Date, Population, New_Vaccinations, Rolling_List_Vaccinations)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS INT)) OVER (Partition By dea.location ORDER BY dea.location, dea.date) AS Rolling_List_Vaccinations
FROM CovidPortfolio..Covid_Deaths AS Dea
JOIN CovidPortfolio..Covid_Vaccinations AS Vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL AND dea.location = 'Canada'
)
SELECT *, (Rolling_List_Vaccinations/Population)*100
FROM Pop_V_Vac
ORDER BY 7 DESC

-- Creating View to Store Data for Later Visualizations
CREATE VIEW Percentage_Canadians_Vaccinated AS
SELECT Continent, Location, MAX(total_cases) as Highest_Infection_Count, population, MAX((total_cases/population))*100 as Percentage_Pop_Infected
FROM CovidPortfolio..Covid_Deaths
GROUP BY Location, Population, Continent
HAVING Population > 10000000 AND continent = 'North America'
--ORDER BY Percentage_Pop_Infected DESC
