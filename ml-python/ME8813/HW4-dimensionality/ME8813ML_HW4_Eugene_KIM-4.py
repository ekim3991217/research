import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import train_test_split

from tensorflow import keras
from keras import layers, models
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt

# Load data from CSV file
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# Standardize the data
scaler = StandardScaler()
X = scaler.fit_transform(data)

# Split data into training and testing sets
X_train, X_test = train_test_split(X, test_size=0.2, random_state=42)

# Define the Autoencoder model
input_dim = X.shape[1]
encoding_dim = 10
input_layer = layers.Input(shape=(input_dim,))
encoder = layers.Dense(encoding_dim, activation='relu')(input_layer)
decoder = layers.Dense(input_dim, activation='sigmoid')(encoder)
autoencoder = models.Model(inputs=input_layer, outputs=decoder)
autoencoder.compile(optimizer='adam', loss='mean_squared_error')

# Train the Autoencoder model
history = autoencoder.fit(X_train, X_train, epochs=50, batch_size=32, shuffle=True, validation_data=(X_test, X_test))

# Use the trained Autoencoder to reduce the dimensionality of the data
encoder = models.Model(inputs=input_layer, outputs=encoder)
X_encoded = encoder.predict(X)

# Determine the optimal number of clusters using the Elbow method
sse = []
for k in range(2, 11):
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_encoded)
    sse.append(kmeans.inertia_)
plt.plot(range(2, 11), sse)
plt.title('Elbow Method')
plt.xlabel('Number of Clusters')
plt.ylabel('SSE')
plt.show()

# Determine the optimal number of clusters using the Silhouette method
silhouette_scores = []
for k in range(2, 11):
    kmeans = KMeans(n_clusters=k, random_state=42)
    kmeans.fit(X_encoded)
    score = silhouette_score(X_encoded, kmeans.labels_)
    silhouette_scores.append(score)
plt.plot(range(2, 11), silhouette_scores)
plt.title('Silhouette Method')
plt.xlabel('Number of Clusters')
plt.ylabel('Silhouette Score')
plt.show()

# Cluster the data using K-means with the optimal number of clusters
n_clusters = 4 # chosen based on the Elbow and Silhouette methods
kmeans = KMeans(n_clusters=n_clusters, random_state=42)
kmeans.fit(X_encoded)

# Evaluate the clustering performance using Silhouette score
silhouette_avg = silhouette_score(X_encoded, kmeans.labels_)
print("Silhouette score:", silhouette_avg)

# Visualize the clustered data in a scatter plot
plt.scatter(X_encoded[:, 0], X_encoded[:, 1], c=kmeans.labels_)
plt.title('Clustered Data')
plt.xlabel('Encoded Feature 1')
plt.ylabel('Encoded Feature 2')
plt.show()

################################################################################
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from sklearn.preprocessing import MinMaxScaler
from tensorflow import keras
from keras.layers import Input, Dense
from keras.models import Model

# Load the data
data = pd.read_csv('HW4Dataset.csv')

# Scale the data
scaler = MinMaxScaler()
data_scaled = scaler.fit_transform(data)

# Define the autoencoder model
input_layer = Input(shape=(15,))
encoder = Dense(8, activation='relu')(input_layer)
encoder = Dense(4, activation='relu')(encoder)
encoder = Dense(2, activation='relu')(encoder)
decoder = Dense(4, activation='relu')(encoder)
decoder = Dense(8, activation='relu')(decoder)
decoder = Dense(15, activation='sigmoid')(decoder)
autoencoder = Model(inputs=input_layer, outputs=decoder)
autoencoder.compile(optimizer='adam', loss='mse')

# Train the autoencoder model
history = autoencoder.fit(data_scaled, data_scaled, epochs=100, batch_size=32, shuffle=True, validation_split=0.2)

# Use the trained model to get the reduced dimensionality data
encoder = Model(inputs=input_layer, outputs=autoencoder.layers[2].output)
encoded_data = encoder.predict(data_scaled)

# Determine the optimal number of clusters using SSE and random restarts
sse = []
for k in range(1, 11):
    kmeans = KMeans(n_clusters=k, init='k-means++', max_iter=300, n_init=10, random_state=0)
    kmeans.fit(encoded_data)
    sse.append(kmeans.inertia_)
plt.plot(range(1, 11), sse)
plt.title('Elbow Method')
plt.xlabel('Number of clusters')
plt.ylabel('SSE')
plt.show()

# Determine the optimal number of clusters using silhouette score
silhouette_scores = []
for k in range(2, 11):
    kmeans = KMeans(n_clusters=k, init='k-means++', max_iter=300, n_init=10, random_state=0)
    kmeans.fit(encoded_data)
    silhouette_scores.append(silhouette_score(encoded_data, kmeans.labels_))
optimal_num_clusters = silhouette_scores.index(max(silhouette_scores)) + 2

# Cluster the data using KMeans
kmeans = KMeans(n_clusters=optimal_num_clusters, init='k-means++', max_iter=300, n_init=10, random_state=0)
kmeans.fit(encoded_data)
cluster_labels = kmeans.labels_

# Calculate the performance evaluation matrix
performance_score = silhouette_score(encoded_data, cluster_labels)

# Plot the clustered data
plt.figure(figsize=(10, 8))
for i in range(optimal_num_clusters):
    plt.scatter(encoded_data[cluster_labels == i, 0], encoded_data[cluster_labels == i, 1], label='Cluster '+str(i+1))
plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], s=100, c='black', label='Centroids')
plt.title('Autoencoder Clustering')
plt.xlabel('PCA 1')
plt.ylabel('PCA 2')
plt.legend()
plt.show()

print('Performance score:', performance_score)
