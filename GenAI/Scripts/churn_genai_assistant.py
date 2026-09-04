# =========================================================
# Customer Churn & Retention GenAI Assistant
# Step 1: Load libraries, API key, and cleaned dataset
# =========================================================

# Import os to read environment variables
import os

# Import pandas to load and analyze the churn dataset
import pandas as pd

# Import load_dotenv to read the .env file
from dotenv import load_dotenv

# Import Gemini client
from google import genai


# ---------------------------------------------------------
# Load Gemini API key from .env file
# ---------------------------------------------------------

env_path = r"D:\PROJECT\Customer_Churn_Retention_GenAI\GenAI\.env"

load_dotenv(env_path)

api_key = os.getenv("GEMINI_API_KEY")


# ---------------------------------------------------------
# Check whether API key was loaded
# ---------------------------------------------------------

if api_key:
    print("Gemini API key loaded successfully.")
else:
    print("Gemini API key not found.")


# ---------------------------------------------------------
# Load cleaned churn dataset
# ---------------------------------------------------------

data_path = r"D:\PROJECT\Customer_Churn_Retention_GenAI\Data\Cleaned\telco_churn_cleaned.csv"

df = pd.read_csv(data_path)

print("Churn dataset loaded successfully.")
print("Dataset shape:", df.shape)

# ---------------------------------------------------------
# Create Gemini client
# ---------------------------------------------------------

client = genai.Client(api_key=api_key)


# ---------------------------------------------------------
# Test Gemini connection
# ---------------------------------------------------------

# ---------------------------------------------------------
# Create Gemini chat session
# ---------------------------------------------------------

chat = client.chats.create(
    model="gemini-3.6-flash"
)

# ---------------------------------------------------------
# Test Gemini connection
# ---------------------------------------------------------

response = chat.send_message(
    "Reply only with: Churn GenAI connection successful."
)

print("Gemini Response:")
print(response.text)

# ---------------------------------------------------------
# Create business summary from churn dataset
# ---------------------------------------------------------

total_customers = df["customerID"].nunique()

churned_customers = df.loc[
    df["Churn_Flag"] == 1,
    "customerID"
].nunique()

churn_rate = (
    churned_customers / total_customers
) * 100

high_risk_customers = df.loc[
    df["High_Risk_Flag"] == 1,
    "customerID"
].nunique()

active_high_risk_customers = df.loc[
    (df["High_Risk_Flag"] == 1) &
    (df["Churn_Flag"] == 0),
    "customerID"
].nunique()

monthly_revenue_at_risk = df[
    "Monthly_Revenue_at_Risk"
].sum()

customer_value_lost = df[
    "Customer_Value_Lost"
].sum()


# ---------------------------------------------------------
# Store the summary in simple text
# ---------------------------------------------------------

business_summary = f"""
Customer Churn Business Summary:

Total Customers: {total_customers}
Churned Customers: {churned_customers}
Overall Churn Rate: {churn_rate:.2f}%
High-Risk Customers: {high_risk_customers}
Active High-Risk Customers: {active_high_risk_customers}
Monthly Revenue at Risk: {monthly_revenue_at_risk:.2f}
Customer Value Lost: {customer_value_lost:.2f}
"""

print(business_summary)

# ---------------------------------------------------------
# Ask Your Data function
# ---------------------------------------------------------

def ask_churn_assistant(user_question):

    prompt = f"""
You are a Customer Churn and Retention Business Analyst assistant.

Use ONLY the business summary below to answer the question.
Do not invent numbers.
Keep the answer simple, clear, and business-focused.

Business Summary:
{business_summary}

User Question:
{user_question}
"""

    response = chat.send_message(prompt)

    return response.text


# ---------------------------------------------------------
# Test question
# ---------------------------------------------------------

test_question = "What is the overall churn situation?"

answer = ask_churn_assistant(test_question)

print("\nQuestion:")
print(test_question)

print("\nGenAI Answer:")
print(answer)


# ---------------------------------------------------------
# Interactive Ask Your Data mode
# ---------------------------------------------------------

print("\n" + "=" * 55)
print("CUSTOMER CHURN & RETENTION - GENAI ASSISTANT")
print("=" * 55)

print("\nType your churn-related business question.")
print("Type 'exit' to close the assistant.")


while True:

    # Ask user for a question
    user_question = input("\nAsk Your Data: ")

    # Stop the assistant when user types exit
    if user_question.lower().strip() == "exit":
        print("\nGenAI Assistant closed.")
        break

    # Get answer from Gemini
    answer = ask_churn_assistant(user_question)

    # Display answer
    print("\nGenAI Answer:")
    print(answer)

# ---------------------------------------------------------
# Create detailed churn driver summaries
# ---------------------------------------------------------

contract_summary = (
    df.groupby("Contract")["Churn_Flag"]
      .mean()
      .mul(100)
      .round(2)
      .sort_values(ascending=False)
)

tenure_summary = (
    df.groupby("Tenure_Group")["Churn_Flag"]
      .mean()
      .mul(100)
      .round(2)
)

payment_summary = (
    df.groupby("PaymentMethod")["Churn_Flag"]
      .mean()
      .mul(100)
      .round(2)
      .sort_values(ascending=False)
)

internet_summary = (
    df.groupby("InternetService")["Churn_Flag"]
      .mean()
      .mul(100)
      .round(2)
      .sort_values(ascending=False)
)

engagement_summary = (
    df.groupby("Engagement_Segment")["Churn_Flag"]
      .mean()
      .mul(100)
      .round(2)
      .sort_values(ascending=False)
)


# ---------------------------------------------------------
# Add detailed churn drivers to business summary
# ---------------------------------------------------------

business_summary += f"""

Churn Rate by Contract:
{contract_summary.to_string()}

Churn Rate by Tenure Group:
{tenure_summary.to_string()}

Churn Rate by Payment Method:
{payment_summary.to_string()}

Churn Rate by Internet Service:
{internet_summary.to_string()}

Churn Rate by Engagement Segment:
{engagement_summary.to_string()}
"""

def ask_churn_assistant(user_question):

    prompt = f"""
You are a Customer Churn and Retention Business Analyst assistant.

Use ONLY the business summary below.
Do not invent numbers.
Do not claim causation unless the data proves it.
Keep the answer simple, clear, and business-focused.

When relevant, structure the answer like this:
1. Key Insight
2. Business Impact
3. Recommended Retention Action

Business Summary:
{business_summary}

User Question:
{user_question}
"""

    response = chat.send_message(prompt)

    return response.text
