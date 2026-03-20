# VERSION 1
import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

# Load the data
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# # Determine the optimal number of clusters
# sse = []
# K = range(1, 11)
# for k in K:
#     kmeans = KMeans(n_clusters=k, init='random', n_init=10, max_iter=300, tol=1e-4, random_state=42)
#     kmeans.fit(data)
#     sse.append(kmeans.inertia_)

# # Plot the SSE for each k
# fig, ax = plt.subplots()
# ax.plot(K, sse, 'bx-')
# ax.set_xlabel('Number of clusters')
# ax.set_ylabel('SSE')
# ax.set_title('Elbow Method')
# plt.show()

# Apply K-Means clustering with the optimal number of clusters
kmeans = KMeans(n_clusters=4, init='random', n_init=10, max_iter=300, tol=1e-4, random_state=42)
kmeans.fit(data)
labels = kmeans.labels_

# Generate scatter plot with color-coded data points
fig, ax = plt.subplots()
scatter = ax.scatter(data.iloc[:, 0], data.iloc[:, 1], c=labels)
legend1 = ax.legend(*scatter.legend_elements(), loc="upper right", title="Clusters")
ax.add_artist(legend1)
ax.set_xlabel('PC1')
ax.set_ylabel('PC2')
ax.set_title('K-Means Clustering')
plt.show()

################################################################################
# VERSION 2
import numpy as np
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt

# Load the data
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# Determine the optimal number of clusters
sse = []
silhouette_scores = []
K = range(2, 11)
for k in K:
    kmeans = KMeans(n_clusters=k, init='random', n_init=10, max_iter=300, tol=1e-4, random_state=42)
    kmeans.fit(data)
    sse.append(kmeans.inertia_)
    silhouette_scores.append(silhouette_score(data, kmeans.labels_))

# Plot the SSE for each k
fig, ax = plt.subplots()
ax.plot(K, sse, 'bx-')
ax.set_xlabel('Number of clusters')
ax.set_ylabel('SSE')
ax.set_title('Elbow Method')
plt.show()

# Plot the silhouette score for each k
fig, ax = plt.subplots()
ax.plot(K, silhouette_scores, 'bx-')
ax.set_xlabel('Number of clusters')
ax.set_ylabel('Silhouette Score')
ax.set_title('Silhouette Method')
plt.show()

# Apply K-Means clustering with the optimal number of clusters
kmeans = KMeans(n_clusters=4, init='random', n_init=10, max_iter=300, tol=1e-4, random_state=42)
kmeans.fit(data)
labels = kmeans.labels_

# Generate a scatter plot
fig, ax = plt.subplots()
scatter = ax.scatter(data.iloc[:, 0], data.iloc[:, 1], c=labels, cmap='viridis')
legend = ax.legend(*scatter.legend_elements(), loc="best", title="Clusters")
ax.add_artist(legend)
ax.set_xlabel('Principal Component 1')
ax.set_ylabel('Principal Component 2')
plt.show()

# Print the clustering performance score
score = silhouette_score(data, labels)
print(f"The clustering performance score is {score}")

