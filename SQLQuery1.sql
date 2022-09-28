Select *
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
order by 1,2

select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Group by Location, Population
order by PercentPopulationInfected desc

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc

select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc

select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(New_Cases as float)) *100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 
order by 1,2

select dea.continent ,dea.location ,  dea.date , dea.population , isnull(vac.new_vaccinations,0) as new_vaccinations , SUM(isnull(convert(float, vac.new_vaccinations),0)) OVER ( partition by dea.location order by dea.location , dea.date) as [RolligPeopleVaccinated] 
from PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccination vac
     on dea.location = vac.location
     and dea.date = dea.date
where dea.continent is not null and dea.location not like '%income%'
order by 2,3 
with PopvsVac ( continent, location , date , population ,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent ,dea.location ,  dea.date , dea.population , vac.new_vaccinations , SUM(Convert(float, vac.new_vaccinations)) OVER ( partition by dea.location order by dea.location , dea.date) as RolligPeopleVaccinated , (RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccination vac
     on dea.location = vac.location
     and dea.date = dea.date
where dea.continent is not null
)
select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac


DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric 
)
insert into #PercentPopulationVaccinated
Select dea.continent ,dea.location ,  dea.date , dea.population , vac.new_vaccinations , SUM(Convert(float, vac.new_vaccinations)) OVER ( partition by dea.location order by dea.location , dea.date) as RolligPeopleVaccinated , (RollingPeopleVaccinated/population)*100
from PortfolioProject..coviddeaths dea
join PortfolioProject..covidvaccination vac
     on dea.location = vac.location
     and dea.date = dea.date
select *,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated


Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..covidvaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

 

