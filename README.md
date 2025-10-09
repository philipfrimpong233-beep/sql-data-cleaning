# Layoffs Data Cleaning and Exploratory Data Analysis (SQL)

This project is part of my **data portfolio** and highlights how I use **SQL** to clean and explore real-world data. The dataset focuses on **global company layoffs**, showing the process from messy data to meaningful insights.

---

## Project Overview

The project is divided into two main parts:

### 1. Data Cleaning

I worked on improving data quality using SQL techniques such as:

* Identifying and removing duplicates with **CTEs** and the `ROW_NUMBER()` function
* Checking for **null and inconsistent values**
* Standardizing company names and country entries
* Creating a clean version of the dataset called `layoffs_staging`

### 2. Exploratory Data Analysis (EDA)

After cleaning, I explored the dataset to answer key questions:

* Which companies had the **highest total layoffs**?
* Which **industries** and **countries** were most affected?
* What is the **trend of layoffs over time** (monthly and yearly)?
* How do **funds raised** relate to the **extent of layoffs**?

I used SQL functions like:

* `GROUP BY` and `SUM()` for aggregations
* `DENSE_RANK()` to rank companies by layoffs per year
* `WITH` clauses (CTEs) for organized and readable analysis
* Date functions to track layoffs **over months and years**

---

## Sample Insights

* **Top companies** like Google, Amazon and Meta had the largest layoff totals.
* **Consumer and Retail** industries were among the hardest hit.
* The **peak layoff period** occurred between 2022–2023.
* Companies that raised more funds didn’t always have fewer layoffs.

---

## Tools and Skills

* **SQL (MySQL)**
* Data cleaning and transformation
* Exploratory data analysis (EDA)
* Use of window functions and CTEs
* Analytical storytelling with SQL

---

## How to Use

1. Import the layoffs dataset into your SQL environment.
2. Run `Layoffs_Data_Cleaning.sql` to clean and prepare the data.
3. Run `Layoffs_EDA.sql` to explore patterns and trends.

---

## About This Project

This project demonstrates my ability to:

* Work with messy real-world data
* Apply structured SQL logic to clean and explore it
* Present insights that tell a clear story about workforce trends

This project is part of my ongoing portfolio to demonstrate my ability to **work with real data**, **ask the right questions**, and **find insights using SQL**
