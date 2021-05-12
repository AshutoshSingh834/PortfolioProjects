Select 
  * 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  Continent is not null 
  and location not like '%World%' 
order by 
  3, 
  4 --Select *
  --from Portfolio_project_covid..CovidVaccinations$
  --where Continent is not null and location not like '%World%'
  --order by 3,4
select 
  location, 
  date, 
  total_cases, 
  new_cases, 
  total_deaths, 
  population 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  Continent is not null 
  and location not in (
    'World', 'Europe', 'North America', 
    'European Union', 'South America', 
    'Asia', 'Africa', 'Oceania'
  ) 
order by 
  1, 
  2 --looking at total_cases v/s total_deaths
  -- shows likelihood of dying by covid-19
select 
  location, 
  date, 
  total_cases, 
  total_deaths, 
  (total_deaths / total_cases)* 100 as DeathPercentage 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  location like '%India%' 
order by 
  1, 
  2 --looking at total_cases v/s population
  -- shows percentage of population infected by Covid-19
select 
  location, 
  date, 
  total_cases, 
  Population, 
  (total_cases / Population)* 100 as TotalCasePercentage 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  location like '%India%' 
order by 
  1, 
  2 --fingding country with highest infection rate
select 
  location, 
  MAX(total_cases) as Total_cases, 
  Population, 
  Max(total_cases / Population)* 100 as TotalCasePercentage 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  Continent is not null 
  and location not in (
    'World', 'Europe', 'North America', 
    'European Union', 'South America', 
    'Asia', 'Africa', 'Oceania'
  ) 
group by 
  location, 
  population 
order by 
  4 Desc --finding country with highest death count per population
select 
  location, 
  Max(total_deaths) as max_death, 
  population, 
  Max(total_deaths / population)* 100 as DeathcountPercentage 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  Continent is not null 
  and location not in (
    'World', 'Europe', 'North America', 
    'European Union', 'South America', 
    'Asia', 'Africa', 'Oceania'
  ) 
group by 
  location, 
  population 
order by 
  4 Desc --finding country with highest deaths
select 
  location, 
  Max(
    cast(total_deaths as int)
  ) as max_death 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  Continent is not null 
  and location not in (
    'World', 'Europe', 'North America', 
    'European Union', 'South America', 
    'Asia', 'Africa', 'Oceania'
  ) 
group by 
  location 
order by 
  2 Desc --finding total deaths in the continents
select 
  Continent, 
  Sum(
    cast(total_deaths as int)
  ) as max_death 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  Continent is not null 
group by 
  Continent -- Daily Global Data
select 
  date, 
  Sum(new_cases) as TotalNewCases, 
  Sum(
    Cast(new_deaths as int)
  ) as TotalNewDeaths, 
  Sum(
    Cast(new_deaths as int)
  )/ Nullif(
    Sum(new_cases), 
    0
  )* 100 as DeathPercentage 
from 
  Portfolio_project_covid..CovidDeaths$ 
where 
  continent is not null 
group by 
  date 
order by 
  1, 
  2 --finding higest vaccination rate
select 
  dea.location, 
  dea.population, 
  Max(
    Cast(vac.total_vaccinations as int)
  ) as total_vaccination, 
  Max(
    Cast(vac.total_vaccinations as int)
  )/ dea.population * 100 as vaccinationPercentage 
from 
  Portfolio_project_covid..CovidVaccinations$ vac 
  join Portfolio_project_covid..CovidDeaths$ dea on vac.location = dea.location 
where 
  dea.continent is not null 
group by 
  dea.location, 
  dea.population 
order by 
  4 desc --Creating view to store data for later visualizations
  Create view vaccinationPercentage as 
select 
  dea.location, 
  dea.population, 
  Max(
    Cast(vac.total_vaccinations as int)
  ) as total_vaccination, 
  Max(
    Cast(vac.total_vaccinations as int)
  )/ dea.population * 100 as vaccinationPercentage 
from 
  Portfolio_project_covid..CovidVaccinations$ vac 
  join Portfolio_project_covid..CovidDeaths$ dea on vac.location = dea.location 
where 
  dea.continent is not null 
group by 
  dea.location, 
  dea.population
