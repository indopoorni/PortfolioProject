select * 
from PortfolioProject..CovidDeaths
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4


--death by location and date

select location,date,total_cases,new_cases,total_deaths, population
from PortfolioProject..CovidDeaths
order by 1,2

--Looking at total cases vs total deaths(death rate of USA)

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--Total cases  vs Population(percentage of population)

select location,date,population,total_cases,(total_cases/population)*100 as percentpopulationinfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2
--death rate countrywise (highest infection rate)

select location,population,max(total_cases)as HighestInfectioncount,max((total_cases/population))*100 as percentpopulationinfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
group by location,population
order by percentpopulationinfected desc

--Showing countries with highest death count per population

select location,max(cast(Total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null--some of continent column have location values
group by location
order by TotalDeathcount desc

--Lets break things down by continent
--Showing continents with the highest death count per population

select continent,max(cast(Total_deaths as int)) as TotalDeathcount
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null--some of continent column have location values
group by continent
order by TotalDeathcount desc

--Global Numbers


select sum(new_cases)as total_cases,sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

----------------------------------------------------------------------
--Looking at Total poplulation vs Vaccinations
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert (int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3


--use CTE

with PopvsVac(Continent, Location, Date,Population,New_vaccinations,RollingPeopleVaccinated)
as
(Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert (int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select * ,(RollingPeopleVaccinated/Population)*100 as vaccinate_rate
from PopvsVac


--Temp Table
--drop table if exists #PercetPopulation Vaccinated
Create Table #PercentPolationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPolationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert (int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3
select * ,(RollingPeopleVaccinated/Population)*100 as vaccinate_rate
from #PercentPolationVaccinated

--Creating view to store data  for later visualization

create view Percentpopulationvaccinated as 

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(convert (int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select * 
from Percentpopulationvaccinated