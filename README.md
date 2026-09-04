# Customer Churn & Retention Analytics + GenAI

An end-to-end telecom customer churn analytics project using Python, PostgreSQL, Power BI, and Gemini GenAI.


# Project Architecture PNG 

<img width="1536" height="1024" alt="ChatGPT Image Sep 4, 2026, 11_02_10 AM" src="https://github.com/user-attachments/assets/2cfdd53d-95b6-476e-8add-f12e8c8c9e35" />

# Dashbord PNG

NO : 1(CHURN) <img width="1195" height="675" alt="Churn" src="https://github.com/user-attachments/assets/aa592073-29f7-43c9-a461-a2c4abf3808f" />

NO : 2(CHURN DRIVES) <img width="1202" height="676" alt="Churn_Drives" src="https://github.com/user-attachments/assets/268cd82c-8274-4183-ae9b-b910059ff98f" />

NO : 3(CUSTOMER RISK) <img width="1201" height="675" alt="Customers_risk" src="https://github.com/user-attachments/assets/fe095a08-bd78-4a43-b54b-ffb90c805ce5" />

NO : 4(RELATIONSHIP) <img width="1256" height="572" alt="Relationship" src="https://github.com/user-attachments/assets/7f8058d1-180f-416c-8e3b-e61df809f7ff" />


## Project Objective

The objective of this project is to analyze customer churn, identify high-risk customer segments, measure revenue impact, and provide actionable retention recommendations.

This project combines data analysis, business intelligence, SQL, and GenAI to support customer retention decisions.

## Business Problem

A telecom company is losing customers and wants to understand:

- Why customers are leaving
- Which customer groups have the highest churn
- Which active customers are at high risk
- How much revenue is associated with churn
- Which customer segments should be prioritized for retention

## Stakeholders

The main stakeholders for this project are:

- Customer Retention Manager
- Marketing Manager
- Customer Service Manager
- Finance / Revenue Manager
- Senior Management

## Tools & Technologies

- Python
- Jupyter Notebook
- Pandas
- NumPy
- Matplotlib
- PostgreSQL
- pgAdmin
- Power BI Desktop
- DAX
- Power Query
- Gemini GenAI
- GitHub

## Project Architecture

```text
Raw Telecom Dataset
        |
        v
Python / Jupyter Notebook
Data Cleaning + EDA + Feature Engineering
        |
        v
Cleaned Dataset
        |
        v
PostgreSQL / pgAdmin
20 Business SQL Queries
        |
        v
Power BI
Star Schema + DAX + 3 Dashboard Pages
        |
        v
Gemini GenAI Assistant
Natural Language Insights
        |
        v
Retention Recommendations└── README.md
