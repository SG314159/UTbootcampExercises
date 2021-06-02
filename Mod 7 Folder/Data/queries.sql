-- Retirement eligibility list
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees who are eligible for Retirement
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create new table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info;

-- Drop retirement_info to be recreated for Section 7.3.2
DROP TABLE retirement_info

-- Create new table with emp_no this time
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

SELECT * FROM retirement_info

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
	dept_manager.emp_no,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement list with dept employee to get last employed date
SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_employees.to_date
FROM retirement_info
LEFT JOIN dept_employees
ON retirement_info.emp_no = dept_employees.emp_no;

-- Same query but with alias practice
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
FROM retirement_info AS ri
LEFT JOIN dept_employees AS de
ON ri.emp_no = de.emp_no;

-- Getting the current employees eligible for retirement; into new table 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	de.to_date
INTO current_emp
FROM retirement_info AS ri
LEFT JOIN dept_employees AS de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

SELECT * FROM current_emp

-- Section 7.3.4 Group By, Order By, and Count
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp AS ce
LEFT JOIN dept_employees as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- Section 7.3.5 table; join, where, alias combined
-- List of current employees retiring along with their info
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON (e.emp_no=s.emp_no)
INNER JOIN dept_employees AS de
ON (e.emp_no=de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- list of managers and what dept they manage and when started
SELECT dm.dept_no, 
	d.dept_name,
	dm.emp_no,
	ce.last_name,
	ce.first_name,
	dm.from_date,
	dm.to_date
INTO manager_info
FROM dept_manager as dm
INNER JOIN departments AS d
	ON (dm.dept_no=d.dept_no)
INNER JOIN current_emp AS ce
	ON (dm.emp_no=ce.emp_no);

-- Current emp list but include dept name
-- Use a third table as common link that doesn't end up
--   having a column in the final list
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
INNER JOIN dept_employees AS de
	ON (ce.emp_no=de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no=d.dept_no);
	
SELECT * FROM retirement_info

-- Section 7.3.6
-- Employee no, name, and dept name but only for sales dept
SELECT ri.emp_no, 
	ri.first_name, 
	ri.last_name, 
	--de.dept_no, 
	d.dept_name
FROM retirement_info AS ri
LEFT JOIN dept_employees AS de
	ON (ri.emp_no=de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no=d.dept_no)
WHERE d.dept_name = 'Sales';

-- Employee no, name, and dept name but only for sales & developmt dept
-- Use of "IN" condition to avoid using an 'or' statement.
SELECT ri.emp_no, 
	ri.first_name, 
	ri.last_name, 
	--de.dept_no, 
	d.dept_name
FROM retirement_info AS ri
LEFT JOIN dept_employees AS de
	ON (ri.emp_no=de.emp_no)
INNER JOIN departments AS d
	ON (de.dept_no=d.dept_no)
WHERE d.dept_name IN ('Sales','Development');