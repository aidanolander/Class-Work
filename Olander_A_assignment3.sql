USE flights;
/*1.Find the names of aircraft such that all pilots certified to operate them have salaries more than $80,000. */

SELECT aircraft.aname, AVG(employees.salary) FROM aircraft
JOIN certified ON aircraft.aid = certified.aid
JOIN employees ON certified.eid = employees.eid
GROUP BY aircraft.aname
;


/*2.Find the names of employees whose salary is less than the price of the cheapest route from Bangalore to Frankfurt. */

SELECT ename FROM employees
WHERE salary < (
	SELECT MIN(price) FROM flight 
	WHERE origin = 'Bangalore'
	AND destination = 'Frankfurt'
    );



/*3.For all aircraft with cruising range over 1,000 miles,
find the name of the aircraft and the average salary of all pilots certified for this aircraft.*/

SELECT aircraft.aname, AVG(employees.salary) AS avg_salary
FROM aircraft
JOIN certified ON aircraft.aid = certified.aid
JOIN employees ON certified.eid = employees.eid
WHERE aircraft.cruisingrange > 1000
GROUP BY aircraft.aname;



/*4.Identify the routes that can be piloted by every pilot who makes more than $70,000.
(In other words, find the routes with distance less than the least cruising range of aircrafts driven by pilots who make more than $70,000) */

SELECT flno, origin, destination, distance
FROM flight
WHERE distance < (
  SELECT MIN(cruisingrange)
  FROM aircraft
  JOIN certified ON aircraft.aid = certified.aid
  JOIN employees ON certified.eid = employees.eid
  WHERE employees.salary > 70000
);





/*5. Print the names of pilots who can operate planes with cruising range greater than 3,000 miles but are not certified on any Boeing aircraft. */

SELECT DISTINCT employees.ename FROM employees
JOIN certified ON employees.eid = certified.eid
JOIN aircraft ON certified.aid = aircraft.aid
WHERE aircraft.cruisingrange>3000
AND employees.ename NOT IN (
	SELECT employees.ename
	FROM employees
	JOIN certified ON employees.eid = certified.eid
	JOIN aircraft ON certified.aid = aircraft.aid
	WHERE aircraft.aname = 'Boeing'
)
;


/*6. Compute the difference between the average salary of a pilot and the average salary of all employees (including pilots).*/

SELECT (
SELECT AVG(salary) FROM employees
WHERE eid IN (SELECT eid FROM certified)
) - 
(SELECT AVG(salary) FROM employees);





/*7. Print the name and salary of every non-pilot whose salary is more than the average salary for pilots.*/

SELECT ename, salary FROM employees
WHERE eid NOT IN (SELECT eid FROM certified)
AND salary > (SELECT AVG(salary) FROM employees
	WHERE eid IN (SELECT eid FROM certified)
    );
    