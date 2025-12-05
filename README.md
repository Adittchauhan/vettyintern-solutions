# Vetty SQL Assignment – Internship Assessment

This repository contains my completed SQL solutions for the Vetty internship technical evaluation.  
All queries were written based on the dataset snapshots provided in the assignment and follow the required format, clarity, and SQL best practices.

---

## Overview

The task involved solving 8 SQL questions using two provided tables:

- **transactions**
- **items**

The goal was to analyze purchase behavior, refunds, store performance, and buyer activity using SQL queries.  
No external datasets were required or used.

I have included:
- A single `.sql` file (`solutions.sql`) containing all answers.
- Clear comments explaining the logic behind each query.
- Assumptions wherever data interpretation was required.

---

## Assumptions

To maintain consistency with the dataset structure, the following assumptions were made:

1. **Refunded purchases** are transactions where `refund_time IS NOT NULL`.  
2. All timestamps (`purchase_time`, `refund_time`) are in standard SQL timestamp format.  
3. A store's **first order** is determined by the earliest `purchase_time` in that store.  
4. Refund eligibility is based on the condition that the refund occurs **within 72 hours** of purchase.  
5. For ranking questions, only non-refunded transactions were treated as "purchases".  
6. `item_id` is the correct join key between the `transactions` and `items` table.

---

## Files Included

| File Name | Description |
|----------|-------------|
| **solutions.sql** | Contains all 8 SQL answers with comments and clean formatting |
| **README.md** | Contains problem overview, approach, assumptions, and submission explanation |

---

## Questions Solved

This assignment provides SQL solutions for the following tasks:

1. Counting monthly purchases (excluding refunds)  
2. Finding stores with at least 5 orders in October 2020  
3. Computing shortest purchase-to-refund interval per store  
4. Finding the gross transaction value of each store’s first transaction  
5. Identifying the most popular first-purchase item across buyers  
6. Creating a refund eligibility flag based on 72-hour criteria  
7. Ranking purchases per buyer and selecting only their second purchase  
8. Finding the second transaction timestamp per buyer (without using MIN or MAX)

All solutions are included in `solutions.sql` with clear explanations.

---

## Approach Summary

- Used **CTEs (WITH clauses)** for cleaner logic and readability.  
- Applied **window functions** such as `ROW_NUMBER()` where ordering per buyer or store was needed.  
- Used **time interval calculations** to determine refund eligibility and intervals.  
- Ensured proper filtering of refunded vs. non-refunded transactions based on the problem statement.  
- Followed SQL formatting best practices for clarity.

---

## How to Run

1. Clone this repository:
   https://github.com/Adittchauhan/vetty-sql-assignment
3. Open the SQL file in your preferred SQL editor.
4. Run queries one-by-one (or entire file if supported).

---

## Submission

This repository serves as my final submission for the Vetty internship SQL assignment.  

For any clarifications, feel free to reach out.

---

## Thank You!

Thank you for reviewing my submission.  
I enjoyed working on this SQL assessment and look forward to the next steps in the interview process.

