-- 1. Looking at the Total Cases, Deaths & Death Percentage for COVID-19 in Canada

SELECT SUM(New_Cases) AS Total_Cases, SUM(CAST(New_Deaths AS INT)) AS Total_Deaths, SUM(CAST(New_Deaths AS INT))/SUM(New_Cases)*100 AS Death_Percentage
FROM CovidPortfolio..Covid_Deaths
WHERE Continent IS NOT NULL
ORDER BY 1,2


-- 2. Looking into the COVID-19 Total Death Count Across Continents

SELECT Location, SUM(CAST(New_Deaths AS INT)) AS Total_Death_Count
FROM CovidPortfolio..Covid_Deaths
WHERE Continent IS NULL 
AND Location NOT IN ('World', 'European Union', 'International', 'High Income', 'Upper Middle Income', 'Lower Middle Income', 'Low Income')
GROUP BY Location
ORDER BY Total_Death_Count DESC


-- 3. List Countries by Highest Infection Rate to Lowest Infection Rate

SELECT Location, Population, MAX(Total_Cases) AS Highest_Infection_Count,  MAX((Total_Cases/Population))*100 AS Percent_Population_Infected
FROM CovidPortfolio..Covid_Deaths
GROUP BY Location, Population
ORDER BY Percent_Population_Infected DESC


-- 4. List Countries by Highest Infection Rate to Lowest, Grouping by Date

SELECT Location, Population, Date, MAX(Total_Cases) as Highest_Infection_Count,  Max((Total_Cases/Population))*100 AS Percent_Population_Infected
FROM CovidPortfolio..Covid_Deaths
GROUP BY Location, Population, Date
ORDER BY Percent_Population_Infected DESC


