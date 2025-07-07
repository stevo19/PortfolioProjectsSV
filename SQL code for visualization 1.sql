--Covid 19 Data Queries use for tableau Project

--1

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int)) / SUM(new_cases)*100 as DeathPercentage
from PortfolioProjectSQL..CovidDeaths$
--Where location like '%States%'
Where continent is not null
--Group by date
order by 1,2

--2 Death by continent 
select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProjectSQL..CovidDeaths$
--where location like %'States%'
Where continent is null
and location not in ('world','European Union', 'International')
Group by location
Order by TotalDeathCount desc

--3
Select location, population, date, MAX(total_cases)as HighestInfectiousCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjectSQL..CovidDeaths$
--Where Location like '%states%'
Group by location, population,date
order by PercentPopulationInfected desc

--4
Select Location, population, date, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProjectSQL..CovidDeaths$
---where location like '%states%'
Group by location, population, date
Order by PercentPopulationInfected desc

--5 