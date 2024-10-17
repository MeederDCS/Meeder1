# %%
import pandas as pd
import numpy as np
from sklearn.tree import DecisionTreeRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error
import matplotlib.pyplot as plt
from sklearn.tree import plot_tree

# Load the third tab of the Excel file
df = pd.read_excel('F:/DerekS/Manager Research/Copy of Index Price Data.xlsx', sheet_name=2)

# Remove the Date column
df = df.drop('Date', axis=1)

# Set the target variable
target = 'COWZ Total Return'

# Separate features and target
X = df.drop(target, axis=1)
X = X.iloc[:,3:]
X = X.drop('SPX', axis=1)
y = df[target]

# %%
# Split the data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=248)

# Create and train the model
regressor = DecisionTreeRegressor(random_state=248,min_samples_leaf = 3)
regressor.fit(X_train, y_train)

# %%
# Make predictions
y_pred = regressor.predict(X_test)

# Calculate MSE
mse = mean_squared_error(y_test, y_pred)
print(f"Mean Squared Error: {mse}")

# %%
# Plot the regression tree
plt.figure(figsize=(20,10))
plot_tree(regressor, feature_names=X.columns, filled=True, rounded=True)
plt.title("Regression Tree")
plt.show()

# Plot predicted vs actual values
plt.figure(figsize=(10,6))
plt.scatter(y_test, y_pred)
plt.plot([y_test.min(), y_test.max()], [y_test.min(), y_test.max()], 'r--', lw=2)
plt.xlabel("Actual")
plt.ylabel("Predicted")
plt.title("Actual vs Predicted COWZ Total Return")
plt.show()

# %%
# Get feature importance
importance = regressor.feature_importances_
feature_importance = pd.DataFrame({'feature': X.columns, 'importance': importance})
feature_importance = feature_importance.sort_values('importance', ascending=False)

# Plot feature importance
plt.figure(figsize=(10,6))
plt.bar(feature_importance['feature'], feature_importance['importance'])
plt.xticks(rotation=90)
plt.xlabel("Features")
plt.ylabel("Importance")
plt.title("Feature Importance")
plt.tight_layout()
plt.show()


