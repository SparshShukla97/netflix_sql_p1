# 📊 Netflix SQL Analysis Project

![Netflix Banner](https://github.com/SparshShukla97/netflix_sql_p1/blob/main/Netflix_LinkdinHeader_N_Texture_5.png)

**Author**: Sparsh Shukla  
**Program**: Master of Data Science, RMIT University  
**Tools Used**: PostgreSQL | SQL

---

## 📌 Overview

This project explores and analyzes a publicly available Netflix dataset using **advanced SQL techniques** to solve **30 real-world business questions**. The analysis extracts valuable insights related to genres, actors, release patterns, co-direction, and geographical trends. It demonstrates how SQL can power intelligent content decisions and user understanding.

---

## 🎯 Objectives

- Apply **SQL functions** to clean and manipulate string, date, and categorical fields  
- Use **aggregation and grouping** to uncover distribution patterns  
- Extract insights on **country contributions**, **popular actors**, and **genre trends**  
- Identify **co-directed content**, keyword-based classifications, and duration-based content ranking  
- Build logic-heavy queries using **CTEs**, **subqueries**, and **window functions** where required

---

## 📁 Dataset

The dataset was sourced from a cleaned version of Netflix’s public catalog data.  
📄 **Fields include:**
- Title  
- Type (Movie or TV Show)  
- Cast and Director  
- Country of Origin  
- Date Added  
- Release Year  
- Rating, Duration, Genres  
- Description  

🔗 **Dataset Source**: [Netflix Titles Dataset – Kaggle](https://www.kaggle.com/datasets/shivamb/netflix-shows)  

---

## ✅ Business Questions Answered (Sample)

1. Count of Movies vs TV Shows  
2. Top genres and most frequent directors  
3. Actors in both Movies and TV Shows  
4. Country-wise content contribution  
5. Most common words in descriptions  
6. Co-directed titles and genre distributions  
7. Day and month content is usually added

📌 **Total**: 30 business problems solved using SQL logic

---

## 🧠 SQL Skills Demonstrated

- `STRING_TO_ARRAY`, `UNNEST`, `SPLIT_PART`, `TRIM`, `ILIKE`  
- Aggregation: `COUNT`, `AVG`, `ROUND`  
- Conditional logic: `CASE WHEN`  
- Date parsing: `TO_DATE`, `TO_CHAR`, `EXTRACT`  
- Text tokenization using `REGEXP_REPLACE` and array functions  
- Nested subqueries and `WITH` clause (CTEs)

---

## 🗂️ Project Files

| File Name               | Description                                      |
|------------------------|--------------------------------------------------|
| `netflix_analysis.sql` | SQL script with all 30 analytical queries        |
| `README.md`            | Documentation and project summary                |
| *(Optional)* `netflix.csv` | Dataset used (if uploaded)                     |

---

## 💡 Sample Query (Actors in Both Movies and TV Shows)

```sql
SELECT actors 
FROM (
  SELECT TRIM(UNNEST(string_to_array(casts, ', '))) AS actors, type
  FROM netflix
  WHERE casts IS NOT NULL
) AS actor_data
GROUP BY actors
HAVING COUNT(DISTINCT type) = 2;
