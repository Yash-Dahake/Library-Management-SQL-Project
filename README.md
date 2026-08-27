# 📚 Library Management SQL Project

## 1. 📌 Project Overview

**Project Title:** Library Management SQL Project
**Database:** `library_p2`
**Tools:** PostgreSQL, SQL, PL/pgSQL

This project focuses on creating, managing, and analyzing a **Library Management System using PostgreSQL**. It covers database setup, CRUD operations, table relationships, SQL analysis, CTAS, joins, subqueries, date calculations, and PL/pgSQL procedures.

The project analyzes **branches, employees, members, books, issued books, returned books, overdue books, active members, and library performance**.

---

# 2. 🎯 Objectives

* Create and populate a structured Library Management database.
* Perform **CRUD (Create, Read, Update, Delete)** operations.
* Use **CTAS (CREATE TABLE AS)** to create tables from query results.
* Perform SQL queries for practical library-related analysis.
* Apply **joins, subqueries, aggregation, and date operations**.
* Create **PL/pgSQL procedures** to automate library operations.
* Generate reports for member, book, employee, and branch performance.

---

# 3. 🗂️ Project Structure

The project is organized into the following major areas:

```text
Library Management SQL Project
│
├── Database Setup
├── CRUD Operations
├── SQL Analysis
├── Advanced SQL Operations
└── README.md
```

The SQL work covers database creation, data manipulation, analysis, reporting, and advanced PostgreSQL operations.

---

# 4. 🗄️ Database Setup

Created the PostgreSQL database:

```sql
library_p2
```

### Main Tables

* **Branch** – Stores branch details, manager information, address, and contact number.
* **Employees** – Stores employee details, position, salary, and branch assignment.
* **Members** – Stores registered library member information.
* **Books** – Stores book details including ISBN, title, category, rental price, author, publisher, and status.
* **Issued Status** – Records books issued to members and the employees who processed the issue.
* **Return Status** – Records returned books and return information.

Primary Keys and Foreign Keys are used to maintain relationships between the tables.

---

# 5. 🔄 CRUD Operations

Implemented the four basic database operations:

* **Create** – Inserted records into the `books` table.
* **Read** – Retrieved data from different library tables.
* **Update** – Updated records in the `employees` table.
* **Delete** – Removed records from the `members` table when required.

---

# 6. 📊 SQL Analysis

## Task 1: Retrieve Records for a Specific Date

Retrieved library issue/transaction records for a specified date using `SELECT` and `WHERE`.

## Task 2: Identify Books by Category

Filtered and analyzed books based on their category and specified conditions.

## Task 3: Category-Wise Book Analysis

Calculated category-wise book information using aggregation and `GROUP BY`.

## Task 4: Create Active Members Table Using CTAS

Used **CREATE TABLE AS (CTAS)** to create an `active_members` table containing members who issued at least one book within the last **2 years and 5 months** based on the defined historical dataset period.

## Task 5: Member Activity Analysis

Analyzed member borrowing activity to understand member engagement.

## Task 6: Issue and Return Analysis

Analyzed issued and returned books using relationships between members, books, issue records, and return records.

## Task 7: Branch-Wise Analysis

Compared branches based on:

* Books issued
* Books returned
* Rental revenue

## Task 8: Employee Performance

Analyzed employees based on the number of books they processed.

## Task 9: Members Registered in the Last 1000 Days

Identified members who registered within the last **1000 days**, based on the dataset's historical reference period.

## Task 10: Book Availability

Analyzed book status to identify available, issued, and returned books.

---

# 7. 🚀 Advanced SQL Operations

## Task 1: Identify Members with Overdue Books

Identified members who have **unreturned books that have been issued for more than 30 days**.

The query joins:

```text
issued_status → members → books → return_status
```

The report displays:

* Member ID
* Member Name
* Book Title
* Issue Date
* Overdue Days

A fixed reference date of **2024-05-06** was used instead of `CURRENT_DATE` because the dataset contains historical data from around 2024.

The query checks:

* `return_date IS NULL` to identify books that have not been returned.
* Issue duration greater than **30 days**.
* Days calculated using:

```sql
DATE '2024-05-06' - issued_date
```

---

## Task 2: Update Book Status on Return

Created a process to update the book status when a book is returned.

The process includes:

1. Checking the issued book.
2. Checking the current book status.
3. Inserting the return record.
4. Updating the book status.
5. Verifying the updated status.

A **PL/pgSQL stored procedure** was created to automate the return process.

---

## Task 3: Branch Performance Report

Created a branch performance report containing:

* Branch ID
* Manager ID
* Number of Books Issued
* Number of Books Returned
* Total Rental Revenue

This report helps compare the operational performance of different branches.

---

## Task 4: Create Active Members Table

Created the `active_members` table using **CTAS**.

A member is considered active if they issued at least one book within the defined **2 years and 5 months** period.

This helps identify members who actively used the library during the selected historical period.

---

## Task 5: Top 3 Employees by Book Issues

Identified the **top 3 employees** who processed the highest number of book issues.

The report includes:

* Employee Name
* Number of Books Issued
* Branch Address

This helps analyze employee workload and book-issue activity.

---

# 8. 📅 Historical Dataset Date Logic

The dataset contains historical records from approximately **2024**, while the project is being analyzed in **2026**.

For date-based analysis, defined reference dates and periods are used instead of directly relying on the current system date.

| Analysis            | Period / Reference         |
| ------------------- | -------------------------- |
| Overdue Books       | Fixed date: **2024-05-06** |
| Active Members      | Last **2 years 5 months**  |
| Member Registration | Last **1000 days**         |
| Book Return Period  | **30 days**                |

This keeps date-based calculations consistent with the historical dataset.

---

# 9. 🧠 Key SQL Concepts Used

* `SELECT`
* `INSERT`
* `UPDATE`
* `DELETE`
* `WHERE`
* `GROUP BY`
* `HAVING`
* `ORDER BY`
* `LIMIT`
* `DISTINCT`
* Aggregate Functions
* `COUNT()`
* `SUM()`
* `AVG()`
* `INNER JOIN`
* `LEFT JOIN`
* Subqueries
* Date & Interval Operations
* `CREATE TABLE AS (CTAS)`
* Stored Procedures
* PL/pgSQL
* Primary Keys
* Foreign Keys
* Table Relationships

---

# 10. 📊 Reports & Insights

The project generates reports related to:

### Member Analysis

* Active members
* Recently registered members
* Borrowing activity
* Overdue books

### Book Analysis

* Book categories
* Issued books
* Returned books
* Book availability
* Rental activity

### Branch Performance

* Books issued by branch
* Books returned by branch
* Rental revenue by branch

### Employee Performance

* Employees with the highest number of processed book issues
* Employee workload by branch

### Operational Analysis

* Borrowing and returning activities
* Overdue book monitoring
* Book availability
* Member activity
* Branch performance

---

# 11. 🔗 Database Relationships

The main relationships can be represented as:

```text
Branch
  │
  └── Employees
          │
          └── Issued Status
                  │
                  ├── Members
                  │
                  └── Books
                         │
                         └── Return Status
```

These relationships allow data from multiple tables to be combined using SQL joins.

---

# 12. 🛠️ Technology Stack

| Technology     | Purpose                        |
| -------------- | ------------------------------ |
| **PostgreSQL** | Database Management            |
| **SQL**        | Data Querying & Analysis       |
| **PL/pgSQL**   | Stored Procedures & Automation |

---

# 13. ▶️ How to Run the Project

### Step 1: Install PostgreSQL

Install PostgreSQL and open **pgAdmin** or the PostgreSQL command-line tool.

### Step 2: Create the Database

Create the project database:

```sql
CREATE DATABASE library_p2;
```

### Step 3: Connect to the Database

Connect to:

```text
library_p2
```

### Step 4: Run the SQL Files

Execute the project SQL scripts in the appropriate order:

1. Database/Table Setup
2. CRUD Operations
3. SQL Analysis
4. Advanced SQL Operations

### Step 5: Verify the Results

Run the queries and verify the generated results, reports, table updates, and stored procedure operations.

> Make sure the required tables and data are created before running the analysis and advanced SQL queries.

---

# 14. 📦 Dataset Information

The project uses a **historical Library Management dataset based around 2024**.

The dataset contains information related to:

* Library branches
* Employees
* Members
* Books
* Book issues
* Book returns
* Rental information

Because the dataset is historical, date-based analyses use defined reference periods where required.

---

# 15. ⭐ Project Highlights

* Designed a relational **Library Management database** using PostgreSQL.
* Implemented **CRUD operations**.
* Performed **10 SQL analysis tasks**.
* Used multiple-table **JOINs** for library analysis.
* Applied **aggregation and subqueries**.
* Created an `active_members` table using **CTAS**.
* Identified overdue books using a **30-day return period**.
* Used a fixed **2024-05-06 reference date** for historical overdue analysis.
* Used a **2 years 5 months** period for active-member analysis.
* Used a **1000-day** period for member-registration analysis.
* Created a **PL/pgSQL stored procedure** for the book-return process.
* Generated **branch performance** and **employee performance** reports.

---

# 16. 🏁 Conclusion

The **Library Management SQL Project** demonstrates the practical use of **PostgreSQL, SQL, and PL/pgSQL** for managing and analyzing library operations.

The project covers **database design, CRUD operations, joins, aggregation, subqueries, CTAS, date calculations, updates, stored procedures, and performance reporting**.

The analysis provides useful insights into **members, books, branches, employees, issued books, returned books, and overdue activities**.

The use of a **fixed historical reference date and defined time periods** ensures that date-based analysis remains appropriate for the 2024 dataset, even though the project is being analyzed in 2026.

Overall, this project demonstrates practical SQL skills applicable to **data analysis, database management, and business intelligence projects**.

---

# 17. 👤 Author

**Yash Dahake**

**Project:** Library Management SQL Project
**Database:** PostgreSQL
**Focus:** SQL | PostgreSQL | Data Analysis | PL/pgSQL
