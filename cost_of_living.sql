
SELECT * FROM cost;

-----------------------	related questions---------------------------
--how many countries are listed
SELECT COUNT(DISTINCT country) FROM cost;

--how is USA's index compared to New York with 100 index
SELECT * FROM cost WHERE country='United States';

--top 10 countries by cost of living
SELECT country, cost_of_living_index
FROM cost
ORDER BY cost_of_living_index DESC
LIMIT 10;

--top 10 countries by rent
SELECT country, rent_index
FROM cost
ORDER BY rent_index DESC
LIMIT 10;

--top 10 countries by living and rent cost index
SELECT country, living_rent_index
FROM cost
ORDER BY living_rent_index DESC
LIMIT 10;

--country with lowews local purchasing power
SELECT country, local_ppp_index
FROM cost
GROUP BY country,local_ppp_index
ORDER BY local_ppp_index ASC
LIMIT 1;

--correlation between cost of living and groceries
SELECT country, cost_of_living_index, groceries_index
FROM cost
GROUP BY country,cost_of_living_index,groceries_index
ORDER BY cost_of_living_index DESC;

--countries with highest restaurant price
SELECT country, restaurant_index
FROM cost
ORDER BY restaurant_index DESC;

--correlation between groceries and restaurant price
SELECT country, groceries_index, restaurant_index
FROM cost
GROUP BY country,groceries_index,restaurant_index
ORDER BY groceries_index DESC;

--country that has lower restaurant index than groceries index
SELECT country, groceries_index, restaurant_index
FROM cost
WHERE groceries_index > restaurant_index
GROUP BY country,groceries_index,restaurant_index;

--ratio of rent to cost of living (highest cost of living country)
SELECT country, rent_index/cost_of_living_index AS rent_ratio
FROM cost
ORDER BY cost_of_living_index DESC
LIMIT 10;

--country with higher cost of living than purchasing power
SELECT country, cost_of_living_index/local_ppp_index AS affordability
FROM cost
WHERE cost_of_living_index/local_ppp_index > 1
GROUP BY country,cost_of_living_index,local_ppp_index;

--import population dataset
DROP TABLE IF EXISTS population;
CREATE TABLE population(
	country VARCHAR(50) NOT NULL,
	capital VARCHAR(50),
	continent VARCHAR(50),
	population_2022 BIGINT,
	area BIGINT,
	world_population_percentage NUMERIC(5, 2)
);

COPY population
FROM '/Users/hinakimura/Downloads/world_pop.csv'
DELIMITER ',' 
CSV HEADER;

--weighetd cost of living index by population
WITH total_population AS (
    SELECT SUM(population_2022) AS world_population
    FROM population
),
weighted_cost AS (
    SELECT 
        cost.country, 
        (population.population_2022 / (SELECT world_population FROM total_population)) * cost.cost_of_living_index AS weighted_cost_of_living
    FROM 
        cost
    LEFT JOIN 
        population 
    ON 
        cost.country = population.country
)
SELECT country, weighted_cost_of_living
FROM weighted_cost
WHERE weighted_cost_of_living IS NOT NULL
ORDER BY weighted_cost_of_living DESC
LIMIT 10;







