import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score
import psycopg2

# Connect to DB
conn = psycopg2.connect(
    dbname="hw5logs",
    user="hw5user",
    password="Hw5StrongPass123!",
    host="127.0.0.1",
    port="5432"
)

# Load data
query = "SELECT client_ip, country FROM ip_country;"
df = pd.read_sql(query, conn)

# Encode IP and country
le_ip = LabelEncoder()
le_country = LabelEncoder()

df['client_ip'] = le_ip.fit_transform(df['client_ip'])
df['country'] = le_country.fit_transform(df['country'])

X = df[['client_ip']]
y = df['country']

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Train model
mapping = dict(zip(df['client_ip'], df['country']))

# Predict
y_pred = X_test['client_ip'].map(mapping)

# Accuracy
accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)

# Save predictions
output = pd.DataFrame({
    "actual": y_test,
    "predicted": y_pred
})

output.to_csv("ip_country_predictions.csv", index=False)
