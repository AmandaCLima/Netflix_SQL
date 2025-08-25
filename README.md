# Netflix Data Analysis with PostgreSQL

This repository contains a comprehensive Exploratory Data Analysisof the Netflix Movies and TV Shows dataset using PostgreSQL. The project is structured around 15 common business questions, showcasing a wide range of SQL techniques from basic filtering and aggregation to advanced analytics like window functions and full-text search.

## 📊 Project Overview

The main goal of this project is to analyze the Netflix content library to extract meaningful insights. The entire analysis is performed using a single SQL script that defines the schema, loads the data (instructions below), and answers 15 specific analytical questions.

## ✨ Key SQL Concepts Demonstrated

This project serves as a practical demonstration of the following SQL skills:

-   **Schema Definition:** Creating tables with appropriate data types (`CREATE TABLE`).
-   **Data Ingestion:** Using the `COPY` command for efficient bulk data loading.
-   **Data Transformation & Cleaning:** Using `UNNEST`, `string_to_array`, `split_part`, and type casting (`::INT`, `to_date`).
-   **Advanced Aggregation:** Using `GROUP BY GROUPING SETS` to generate total and subtotal rows.
-   **Window Functions:** Employing `RANK()` to find the top N items within categories.
-   **Common Table Expressions (CTEs):** Structuring complex queries with the `WITH` clause for better readability.
-   **Date/Time Functions:** Filtering data based on time intervals using `CURRENT_DATE` and `INTERVAL`.
-   **Full-Text Search:** Implementing efficient text searches with `to_tsvector` and `plainto_tsquery`.
-   **Pattern Matching:** Using `LIKE` and `ILIKE` for flexible string searches.

## 💾 Dataset

The dataset used is the "Netflix Movies and TV Shows" collection, publicly available on [Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows).

## 🚀 How to Use

Follow these steps to replicate the analysis on your own PostgreSQL instance.

### Prerequisites

-   Ensure you have PostgreSQL installed and running.
-   Download the `netflix_titles.csv` file from the Kaggle link above.

### 1. Table Creation

First, run the `CREATE TABLE` statement from the top of the provided SQL script to create the `netflix` table structure in your database.

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);