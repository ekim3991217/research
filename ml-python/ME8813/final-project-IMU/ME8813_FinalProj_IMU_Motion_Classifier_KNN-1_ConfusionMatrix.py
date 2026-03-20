import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import confusion_matrix
import seaborn as sns
import matplotlib.pyplot as plt

# Load dataset from CSV file
# df = pd.read_csv('8813_dataset.csv')
# df = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW2_Regression/HW2Dataset.csv')
df = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/FinalProject_EugeneKIM/code/8813_dataset.csv')


# Define features and labels
X = df[['ax_g', 'ay_g', 'az_g', 'wx_deg_s', 'wy_deg_s', 'wz_deg_s', 'AngleX_deg', 'AngleY_deg', 'AngleZ_deg']]
y = df['Label']

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

################################################################################
# Define the KNN model with appropriate k value
# TEST DIFFERENT K VALUES TO TEST FOR BETTER RESULTS
knn = KNeighborsClassifier(n_neighbors=3)
################################################################################

# Train the model
knn.fit(X_train, y_train)

# Predict on the test data
y_pred = knn.predict(X_test)

# Create a confusion matrix and plot it as a heatmap
cm = confusion_matrix(y_test, y_pred, labels=['lunge', 'walk', 'squat'])
ax = plt.subplot()
sns.heatmap(cm, annot=True, ax=ax, cmap='Blues', fmt='g')

# Add labels, title and ticks
ax.set_xlabel('Predicted')
ax.set_ylabel('Actual')
ax.set_title('KNN Classification Confusion Matrix (k=3)')
ax.xaxis.set_ticklabels(['Lunge', 'Walk', 'Squat'])
ax.yaxis.set_ticklabels(['Lunge', 'Walk', 'Squat'])

plt.show()
