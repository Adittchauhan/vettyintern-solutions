# Vetty SQL Assignment – Internship Evaluation

This repository contains my SQL solutions for the Vetty internship assessment.  
The goal of this assignment is to demonstrate SQL querying skills, problem-solving ability,  
and understanding of analytical functions.

All answers are based strictly on the dataset snapshot provided in the assignment PDF.  
No external data sources were used.

---

## 📂 Dataset Information

Two tables were provided:

### **1. transactions**
Columns include:
- transaction_id  
- buyer_id  
- item_id  
- store_id  
- purchase_time  
- refund_time  
- gross_transaction_value  

### **2. items**
Columns include:
- item_id  
- item_name  

---

## 📝 Assumptions

To ensure consistency with the provided dataset, the following assumptions were made:

1. A purchase is treated as valid only when **refund_time IS NULL**.  
2. Timestamps are stored in standard SQL UTC format.  
3. A store’s “first order” refers to the earliest purchase_time.  
4. Refund eligibility requires the refund to occur **within 72 hours** (4320 minutes).  
5. Ranking queries ignore refunded transactions unless specified.  
6. Items table is joined using `transactions.item_id = items.item_id`.

---

## 📘 SQL Solutions (Questions 1–8)

Below are my final SQL queries, each fully commented and ready to execute.

---

### **1️⃣ Count of purchases per month (excluding refunds)**

```sql
SELECT 
    DATE_TRUNC('month', purchase_time) AS purchase_month,
    COUNT(*) AS total_purchases
FROM transactions
WHERE refund_time IS NULL
GROUP BY 1
ORDER BY 1;
