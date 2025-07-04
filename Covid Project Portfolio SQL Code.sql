select *
From PortfolioProjectSQL..CovidDeaths$
where continent is not null
order by 3,4

--select *
--From PortfolioProjectSQL..CovidVaccinations$
--order by 3,4

-- Let's select the Data that we'll be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProjectSQL..CovidDeaths$
where continent is not null
order by 1,2

--Let's take a look at the Total Cases vs Total Deaths
-- the DeathPercentage column shows the likelyhood of dying if you caught covid
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectSQL..CovidDeaths$
Where location like '%states%'
AND continent is not null
order by 1,2

--Let's look at the total cases vs population
-- this column shows what percentage of the population got covid
Select Location, date, population, total_cases, (total_cases/ population) *100 as PercentageOfPopulationInfected
From PortfolioProjectSQL..CovidDeaths$
Where location like '%states%'
AND continent is not null
order by 1,2

--Let's look at the countries with the highest infection rate compared to their population
Select Location,population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/ population)) *100
as PercentageOfPopulationInfected
From PortfolioProjectSQL..CovidDeaths$
where continent is not null
Group by Location, population
order by PercentageOfPopulationInfected desc

--- This shows the countries with the highest death count per country
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProjectSQL..CovidDeaths$
where continent is not null
Group by Location
Order by TotalDeathCount desc

-- Let's Filter by Continent- Highest death count by continent
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProjectSQL..CovidDeaths$
where continent is not null
Group by continent
Order by TotalDeathCount desc

--Global Numbers - show total new cases and deaths per day from the 1st day cases were bieng reported
Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as Int))as total_deaths, SUM(cast(new_deaths as Int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectSQL..CovidDeaths$
--Where location like '%states%'
where continent is not null
Group by date
Order by 1,2

-- Global number- shows the DeathPercentage accross the world
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as Int))as total_deaths, SUM(cast(new_deaths as Int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProjectSQL..CovidDeaths$
--Where location like '%states%'
where continent is not null
--Group by date
Order by 1,2

-- Let's join the two tables together CovidDeath & CovidVaccinations

select *
From PortfolioProjectSQL..CovidDeaths$  dea
 Join PortfolioProjectSQL..CovidVaccinations$ vac
	On dea.location = vac.location
	And dea.date = vac.date

--Use CTE - common table expression
	With PopvsVac (Continent, Location, Date, Population, New_Vaccinnations, RollingPeopleVaccinated)
	as
	(
-- Let's look at Total Population vs Vaccinations using the new vaccination column to show Vaccination per day
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations  ---vac.continent, vac.location, vac.date
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
From PortfolioProjectSQL..CovidDeaths$  dea
 Join PortfolioProjectSQL..CovidVaccinations$ vac
	On dea.location = vac.location
	And dea.date = vac.date
	--And dea.location like '%Albania%'
	where dea.continent is not null
	--order by 2,3
)
select*, (RollingPeopleVaccinated/Population) * 100
From PopvsVac

-- Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations  ---vac.continent, vac.location, vac.date
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
From PortfolioProjectSQL..CovidDeaths$  dea
 Join PortfolioProjectSQL..CovidVaccinations$ vac
	On dea.location = vac.location
	And dea.date = vac.date
	--And dea.location like '%Albania%'
	where dea.continent is not null
	--order by 2,3
select*, (RollingPeopleVaccinated/Population) * 100
From #PercentPopulationVaccinated

--Creating View to store data for later visualizations
Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations  ---vac.continent, vac.location, vac.date
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date)
as RollingPeopleVaccinated
--,(RollingPeopleVaccinated/Population) * 100
From PortfolioProjectSQL..CovidDeaths$  dea
 Join PortfolioProjectSQL..CovidVaccinations$ vac
	On dea.location = vac.location
	And dea.date = vac.date
	--And dea.location like '%Albania%'
	where dea.continent is not null
	--order by 2,3

	select *
	From #PercentPopulationVaccinated