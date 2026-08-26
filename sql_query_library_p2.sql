--creating database for library management system
--CREATE DATABASE library_p2;

--Create the tables

CREATE TABLE branch
(
		branch_id VARCHAR(10) PRIMARY KEY,
	    manager_id VARCHAR(10),
        branch_address VARCHAR(30),
        contact_no VARCHAR(15)
);


CREATE TABLE employees
(
		emp_id VARCHAR(10) PRIMARY KEY,
		emp_name VARCHAR(30),
        position VARCHAR(30),
        salary INT,
        branch_id VARCHAR(10),
        FOREIGN KEY (branch_id) REFERENCES  branch(branch_id)
);


ALTER TABLE employees
ALTER COLUMN  salary TYPE NUMERIC(10,2);

CREATE TABLE members
(
            member_id VARCHAR(10) PRIMARY KEY,
            member_name VARCHAR(30),
            member_address VARCHAR(30),
            reg_date DATE
);

CREATE TABLE books
(
            isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price INT,
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);

ALTER TABLE books
ALTER COLUMN rental_price TYPE NUMERIC(10,2);


DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
            issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);


DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
            return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50)
           
);


ALTER TABLE return_status 
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);



--importing data 

-- Change member_id so it matches issued_status.issued_member_id
ALTER TABLE members
ALTER COLUMN member_id TYPE VARCHAR(30);


SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM members;
SELECT * FROM books;
SELECT * FROM issued_status;
SELECT * FROM return_status;


-- CRUD Operations
--Create: Inserted sample records into the books table.
--Read: Retrieved and displayed data from various tables.
--Update: Updated records in the employees table.
--Delete: Removed records from the members table as needed.


--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn , book_title ,category ,rental_price , status , author ,publisher )
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'	);

--Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '124 Main St'
WHERE
	MEMBER_ID = 'C101';

SELECT
	*
FROM
	members;

--Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
DELETE FROM issued_status
WHERE issued_id='IS121';

SELECT * FROM issued_status;

-- ALTERNATIVE TO CHECK IT 
SELECT *
FROM issued_status
WHERE issued_id = 'IS121';


--Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT *
FROM issued_status
WHERE issued_emp_id = 'E101';-- there are 2 books is130 and is131 by who issued book e

--Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
		issued_emp_id,
		COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id)>1;


--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
-- creating CTAs
CREATE TABLE book_count
as
SELECT 
		b.isbn,
		b.book_title,
		COUNT(ist.issued_id) as number_issuedI
		FROM books as b 
		JOIN issued_status as ist
		on ist.issued_book_isbn=b.isbn
		GROUP BY 1,2;


SELECT * FROM book_count;   -- it create the in the database

--Task 7. Retrieve All Books in a Specific Category:


SELECT * FROM books
where category ='Classic'


-- unique category
SELECT DISTINCT category
FROM books; 

-- total books by each category
SELECT 
    category,
    COUNT(*) AS total_books
FROM books
GROUP BY category;



--Task 8: Find Total Rental Income by Category
SELECT
		b.category,
		sum(b.rental_price),
		COUNT(*)
		FROM books as b 
		JOIN issued_status as ist
		on ist.issued_book_isbn=b.isbn
		GROUP BY 1;


--Task 9: List Members Who Registered in the Last 1000 Days:

SELECT * FROM members
where reg_date>= CURRENT_DATE - INTERVAL '1000 days';


-- Task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT  e1.emp_id,
	    e1.emp_name,
	    e1.position,
	    e1.salary,
	    b.*,
		e2.emp_name as manager
FROM employees as e1
join  branch as b
on b.branch_id=e1.branch_id
join employees as e2 
on b.manager_id=e2.emp_id


--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books
as
SELECT  * FROM books
WHERE rental_price > 7;

SELECT * FROM expensive_books;

--Task 12: Retrieve the List of Books Not Yet Returned
SELECT 
 		DISTINCT ist.issued_book_name
		 FROM issued_status as ist
		left JOIN return_status as r1
		on ist.issued_id=r1.issued_id
		where  r1.return_id is NULL;