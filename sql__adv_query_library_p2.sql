
-- Advanced SQL Operations

-- Task 1 : Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period).
--Display the member's_id, member's name, book title, issue date, and days overdue


--issued_status == members  == boks ==return_status-

--I used a fixed date (2024-05-06) instead of CURRENT_DATE because this dataset is about 2 years old. This keeps the overdue days calculation consistent with the dataset period.


SELECT 
	ist.issued_member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	
	--rs.return_date,

DATE '2024-05-06' - ist.issued_date AS over_dues_days
FROM issued_status as ist
join 
	members as m 
on m.member_id= ist.issued_member_id
join 
books as bk
on bk.isbn =ist.issued_book_isbn
left join 
return_status as rs 
ON rs.issued_id = ist.issued_id 
where 
	rs.return_date is NULL
	AND
(DATE '2024-05-06' - ist.issued_date) > 30
order by 1 ;



---Task 2: Update Book Status on Return
--Write a query to update the status of books in the books table to "Yes" when they are returned (based on entries in the return_status table).
---
SELECT * FROM issued_status
where issued_book_isbn='978-0-451-52994-2';

select * from books
where isbn='978-0-451-52994-2';

UPDATE books 
SET status='NO'
where isbn='978-0-451-52994-2';

SELECT * FROM return_status
where issued_id ='IS130';

INSERT INTO return_status(  return_id, issued_id,  return_date)
VALUES ('RS125', 'IS130','2024-05-06' );

SELECT* from return_status
where issued_id='IS130';

UPDATE books 
SET status='yes'
where isbn='978-0-451-52994-2';

select * from books
where isbn='978-0-451-52994-2';



CREATE OR REPLACE PROCEDURE add_return_records(
    p_return_id VARCHAR(10),
    p_issued_id VARCHAR(10)
)
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);

BEGIN

    INSERT INTO return_status(
        return_id,
        issued_id,
        return_date
    )
    VALUES (
        p_return_id,
        p_issued_id,
        CURRENT_DATE
    );

    SELECT
        issued_book_isbn,
        issued_book_name
    INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;

END;

$$;

$$;
CALL add_return_records('RS135', 'IS131');

SELECT * FROM return_status --- added successful

where issued_id='IS131'

SELECT * FROM books
where isbn='978-0-06-112008-4' -- it updated to yes



-- TESTING 
SELECT * FROM issued_status
where issued_id='IS131'

SELECT * FROM issued_status
where issued_book_isbn='978-0-307-58837-1'

SELECT * FROM return_status
where issued_id='IS131'
 
--Task 3: Branch Performance Report
--Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.


SELECT * FROM branch

SELECT * FROM issued_status

SELECT * FROM employees

SELECT * FROM books

SELECT * FROM return_status
----------------------------------------------------------------

CREATE TABLE  branch_reports
as
SELECT 
	b.branch_id,
	b.manager_id,
		COUNT(ist.issued_id) as number_book_issued,
		COUNT(rs.return_id) as number_book_return,
	sum(bk.rental_price)as total_revenue

FROM issued_status as ist
JOIN employees as e
on 
e.emp_id= ist.issued_emp_id
JOIN
branch AS b
on b.branch_id=e.branch_id 
left JOIN                --- use LEFT JOIN so we can get all records
return_status AS rs

on rs.issued_id=ist.issued_id

JOIN
books AS bk

on bk.isbn=ist.issued_book_isbn
GROUP BY 1,2;


---------------------------------------------------------------

SELECT * FROM branch_reports;


--Task 4: CTAS: Create a Table of Active Members
--Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 2 year 5 MONTH.
-- Delete the table if it already exists
DROP TABLE IF EXISTS active_members;

-- Create a table containing members who were active
-- within the last 2 years and 1 month from the dataset reference date
CREATE TABLE active_members AS
SELECT *
FROM members
WHERE member_id IN (
    SELECT DISTINCT issued_member_id
    FROM issued_status
    WHERE issued_date >= CURRENT_DATE - INTERVAL '2 YEARS 5 MONTH  '
);
----------------------------------------------------------------------------------
SELECT * FROM active_members;

--Task 5: Find Employees with the Most Book Issues Processed
--Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

SELECT 
	e.emp_name,
    b.branch_address,
	
	COUNT(ist.issued_id) as number_book_issued
FROM issued_status as ist
JOIN employees as e
on 
e.emp_id= ist.issued_emp_id
JOIN
branch AS b
on b.branch_id=e.branch_id 

GROUP BY 1,2
ORDER BY number_book_issued DESC
LIMIT 3;


SELECT 
    e.emp_name,
    COUNT(ist.issued_id) AS number_book_issued,
    b.branch_address
FROM issued_status AS ist
JOIN employees AS e
    ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
    ON b.branch_id = e.branch_id
GROUP BY 
    e.emp_name,
    b.branch_address

------------------------------------------------------------------------------