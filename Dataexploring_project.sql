select * from covidDeaths
where continent is not null
order by 3,4

--select * from covidVaccinations
--order by 3,4

select location,date,total_cases,total_deaths,population,(try_convert(float,[total_deaths]) /try_convert(float,[total_cases]) * 100) as Death percentage 
from Project1..covidDeaths

order by 1,2


select location,date,total_cases,total_deaths,population,(try_convert(float,[total_deaths]) /try_convert(float,[total_cases]) * 100) as Deathpercentage 
from covidDeaths
where location like '%india%'
order by 2,6

--total case and population



select location,date,total_cases,total_deaths,population,(total_cases/population) * 1000 as Deathpercentage 
from covidDeaths
where location like '%india%'
order by 1,2

--Countries with hoghest infection rate

select location,max(total_cases) as highestinfectioncount,population,max ((total_cases/population)) * 100 as percentageInfected 
from covidDeaths
--where location like '%india%'
group by population,location
order by percentageInfected desc

--countries with highest death count

select location,max(cast(total_deaths as int )) as highestdeathcount
from covidDeaths
--where location like '%india%'

where continent is not null
group by population,location
order by highestdeathcount desc

 -- By continent

 select SUM(new_cases ) as totalcases,SUM(cast(new_deaths as int )) as totaldeaths, SUM(cast(new_deaths as int ))/ SUM(new_cases )  *100 as deathpercentage
from covidDeaths
order by 1

-- Looking at total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(convert(bigint,vacc.new_vaccinations )) Over (partition by dea.location order by dea.location,dea.date) as rollingpeopleVaccinated
from covidDeaths dea
join covidVaccinations as vacc
on dea.location = vacc.location and dea.date = vacc.date
where dea.continent is not null
--order by 1,2

--creating a cte

with popvsvac (continent,location,date,population,new_vaccination,rollingpeoplevaccination)
as
(
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(convert(bigint,vacc.new_vaccinations )) Over (partition by dea.location order by dea.location,dea.date) as rollingpeopleVaccinated
from covidDeaths dea
join covidVaccinations as vacc
on dea.location = vacc.location and dea.date = vacc.date
where dea.continent is not null
--order by 1,2
)

select *,(rollingpeoplevaccination/population)*100 from popvsvac

--TempTable

Drop table if exists percentpopulationvaccinated
create table percentpopulationvaccinated (continent nvarchar(55),location nvarchar(55),date datetime,population numeric,
new_vaccination numeric,rollingpeoplevaccination numeric)


insert into percentpopulationvaccinated
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(convert(bigint,vacc.new_vaccinations )) Over (partition by dea.location order by dea.location,dea.date) as rollingpeopleVaccinated
from covidDeaths dea
join covidVaccinations as vacc
on dea.location = vacc.location and dea.date = vacc.date
where dea.continent is not null
--order by 1,2)

select *,(rollingpeoplevaccination/population)*100 from percentpopulationvaccinated

-- creating view 

Create view percentpopulationvaccinat as
select dea.continent,dea.location,dea.date,dea.population,vacc.new_vaccinations,
SUM(convert(bigint,vacc.new_vaccinations )) Over (partition by dea.location order by dea.location,dea.date) as rollingpeopleVaccinated
from covidDeaths dea
join covidVaccinations as vacc
on dea.location = vacc.location and dea.date = vacc.date
where dea.continent is not null
--order by 2,3

select * from percentpopulationvaccinated