select *
From PortfolioProject..CovidDeaths 
where continent is not null 
Order by 3,4

--select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

select continent, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject..CovidDeaths
where continent is not null 
Order by 1,2

--Looking at total cases vs total deaths

select continent, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_perc
From PortfolioProject..CovidDeaths
where continent is not null 
Order by 1,2

--Looking at total cases vs population in the US

select continent, date, total_cases, (total_cases/population)*100 as US_cases_per_capita
From PortfolioProject..CovidDeaths
where continent is not null 
where location = 'United States'
Order by 1,2

--Looking at total cases vs population in the UK

select continent, date, total_cases, population, (total_cases/population)*100 as UK_cases_per_capita
From PortfolioProject..CovidDeaths
where continent is not null 
where location = 'United Kingdom'
Order by 1,2

--Looking at which country has the highest infection rate per capita

select continent, MAX(total_cases) as highest_no_cases, population, Max((total_cases/population))*100 as max_cases_per_capita
From PortfolioProject..CovidDeaths
where continent is not null 
Group by continent, population
Order by max_cases_per_capita desc

--Looking at countries with the highest number of deaths per capita

select continent, max(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths
where continent is not null 
Group by continent
Order by total_death_count desc

select continent, max(cast(total_deaths as int)) as total_death_count
From PortfolioProject..CovidDeaths
where continent is not null 
Group by continent
Order by total_death_count desc

-- GLOBAL NUMBERS

select date, SUM(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/Sum(New_cases)*100 as death_perc
From PortfolioProject..CovidDeaths
where continent is not null 
group by date
Order by 1,2


-- Looking at total population vs vaccination
-- Use CTE

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 ***NOTE- you can't use a newly created column for this calculation (must either use a CTE or a temp table)
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (Continent, Locations, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 ***NOTE- you can't use a newly created column for this calculation (must either use a CTE or a temp table)
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Creating view to store date for later visualistions

Create View PopvsVac as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 ***NOTE- you can't use a newly created column for this calculation (must either use a CTE or a temp table)
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

Select *
From PopvsVac
