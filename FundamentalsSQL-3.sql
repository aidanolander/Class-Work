/*Q1.Compute new cases for each day. */

SELECT date, tot_cases - LAG(tot_cases) OVER w AS lagCases FROM (
SELECT date, SUM(total_cases) AS 'tot_cases'
FROM statistics
GROUP BY date
ORDER BY date) AS lagTable
WINDOW w AS (ORDER BY date);



/*Q2.To account for "administrative weekends" with fewer reports or missing data, 
compute the smoothed rolling average between two preceding days and two following days. */

SELECT date, AVG(tot_cases) OVER w AS rollCases FROM (
SELECT date, SUM(total_cases) AS 'tot_cases'
FROM statistics
GROUP BY date
ORDER BY date) AS lagTable
WINDOW w AS (
ROWS between 2 preceding and 2 following);


/*Q3. Fetch latest available per state data from statistics. Note that states may have different latest submission dates. (hint: ROW_NUMBER())*/

SELECT tmp.state, tmp.date, tmp.total_cases 
FROM (
    SELECT state, date, total_cases,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY date DESC) AS row_num
    FROM statistics 
) tmp
where tmp.row_num = 1;

-- OR

SELECT statistics.state, statistics.date, statistics.total_cases
FROM statistics
INNER JOIN (
    SELECT state, max(date) AS MaxDate
    FROM statistics
    GROUP BY state
) AS tm ON statistics.state = tm.state AND statistics.date = tm.MaxDate;



/*Q4.Use the "latest data" derived from the above query and demographic information to compute the mortality per 100,000 population.*/

SELECT tmp.state, tmp.date, tmp.total_deaths, demographics.population, tmp.total_deaths/demographics.population AS mortalityPerHundK
FROM (
    SELECT state, date, total_deaths,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY date DESC) AS row_num
    FROM statistics 
) AS tmp INNER JOIN demographics 
ON tmp.state = demographics.state
WHERE tmp.row_num = 1;



/*Q5.Find the biggest spike in new deaths per country. Sort them by the most recent date, then by the count of new deaths. (hint: RANK())*/

SELECT state, date, deathSpike FROM(
	SELECT state, date,
	total_deaths-LAG(total_deaths) OVER(PARTITION BY state ORDER BY date) AS deathSpike,
	RANK() OVER(PARTITION BY state ORDER BY deathSpike DESC) AS deathRank
	FROM (
		SELECT state, date, total_deaths,
		total_deaths-LAG(total_deaths) OVER(PARTITION BY state ORDER BY date) AS deathSpike
		FROM statistics) AS deathTable
) AS finalTable
WHERE deathRank = 1
ORDER BY date DESC, deathSpike DESC;
