import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
import psycopg2

# Connect via proxy (same as before)
conn = psycopg2.connect(
    dbname="hw5logs",
    user="hw5user",
    password="Hw5StrongPass123!",
    host="127.0.0.1",
    port="5432"
)

# Load data
query = """
SELECT r.client_ip, i.country, r.gender, r.age, r.income
FROM request_logs_new r
JOIN ip_country i ON r.client_ip = i.client_ip;
"""
df = pd.read_sql(query, conn)

# Encode categorical columns
le_ip = LabelEncoder()
le_country = LabelEncoder()
le_gender = LabelEncoder()
le_income = LabelEncoder()

df['client_ip'] = le_ip.fit_transform(df['client_ip'])
df['country'] = le_country.fit_transform(df['country'])
df['gender'] = le_gender.fit_transform(df['gender'])
df['income'] = le_income.fit_transform(df['income'])

# Features + target
X = df[['client_ip', 'country', 'gender', 'age']]
y = df['income']

# Split
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Model
model = RandomForestClassifier()
model.fit(X_train, y_train)

# Predict
y_pred = model.predict(X_test)

# Accuracy
accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)

# Save predictions
output = pd.DataFrame({
    "actual": y_test,
    "predicted": y_pred
})

output.to_csv("income_predictions.csv", index=False)
