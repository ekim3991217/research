# IMPORT PACKAGES
import pandas as pd

import numpy as np

import seaborn as sns

from sklearn.model_selection import train_test_split
from sklearn.model_selection import cross_val_score
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score
from sklearn.metrics import confusion_matrix

import matplotlib.pyplot as plt

# Load the data from a CSV file
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/FinalProject_EugeneKIM/code/8813_dataset.csv')

# Split the data into features (X) and target (y)
X = data.iloc[:, 1:-1].values
y = data.iloc[:, -1].values

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Define possible values for n_neighbors
k_values = list(range(1, 31))

# Cross-validation loop to find best n_neighbors value
cv_scores = []
for k in k_values:
    knn = KNeighborsClassifier(n_neighbors=k)
    scores = cross_val_score(knn, X_train, y_train, cv=5, scoring='accuracy')
    cv_scores.append(scores.mean())

# Find best k value
best_k = k_values[np.argmax(cv_scores)]
print('BEST K VALUE:', best_k)

# Define the KNN classifier based on selected k value
knn = KNeighborsClassifier(n_neighbors=best_k)

# Train the KNN classifier on the training data
knn.fit(X_train, y_train)

# Predict the motion labels on the test data
y_pred = knn.predict(X_test)

# Calculate the accuracy of the predictions
accuracy = accuracy_score(y_test, y_pred)
print(f'Accuracy: {accuracy:.2f}')

# Generate a heatmap of the data
sns.heatmap(data.iloc[:, :-1].corr(), annot=True, cmap='coolwarm')
plt.title('KNN Classification Feature Correlation Heatmap (k=3)')
plt.show()

# # Create a confusion matrix and plot it as a heatmap
# cm = confusion_matrix(y_test, y_pred, labels=['Lunge', 'Walk', 'Squat'])
# ax = plt.subplot()
# sns.heatmap(cm, annot=True, ax=ax, cmap='Blues', fmt='g')

# # Add labels, title and ticks
# ax.set_xlabel('Predicted')
# ax.set_ylabel('Actual')
# ax.set_title('KNN Classification Confusion Matrix (k=3)')
# ax.xaxis.set_ticklabels(['Lunge', 'Walk', 'Squat'])
# ax.yaxis.set_ticklabels(['Lunge', 'Walk', 'Squat'])

# plt.show()

