
Select *
From CoronaVirusProject..CovidDeaths
Where continent is not null
order by 3,4

--Select *
--From CoronaVirusProject..CovidVaccinations
--order by 3,4

-- Selecting Specific data that we need

Select Location, date, total_cases, new_cases, total_deaths, population
From CoronaVirusProject..CovidDeaths
Where continent is not null
order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CoronaVirusProject..CovidDeaths
Where location like 'India'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of Population got Covid

Select Location, date, Population, total_cases, (total_cases/Population)*100 as PercentPopulationInfected
From CoronaVirusProject..CovidDeaths
Where location like 'India'
order by 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount, (MAX(total_cases)/MAX(Population))*100 as PercentPopulationInfected
From CoronaVirusProject..CovidDeaths
--Where location like 'India'
Where continent is not null
Group by Location, Population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count Per Population

Select Location, MAX(total_deaths) as TotalDeathCount
From CoronaVirusProject..CovidDeaths
--Where location like 'India'
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- LET's BREAK THINGS DOWN BY CONTINENT
-- Showing continents with the highest death count per population

Select location, MAX(total_deaths) as TotalDeathCount
From CoronaVirusProject..CovidDeaths
--Where location like 'India'
Where continent is null
Group by location
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, (SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
From CoronaVirusProject..CovidDeaths
--Where location like 'India'
Where continent is not null
--Group By date
order by 1,2

-- Looking at Total Population vs Vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CoronaVirusProject..CovidDeaths dea
Join CoronaVirusProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE

With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CoronaVirusProject..CovidDeaths dea
Join CoronaVirusProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopVsVac

-- Creating View to store data for Later Visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From CoronaVirusProject..CovidDeaths dea
Join CoronaVirusProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3

