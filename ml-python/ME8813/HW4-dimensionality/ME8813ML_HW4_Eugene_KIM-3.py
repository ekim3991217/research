import numpy as np
import pandas as pd
from sklearn.mixture import GaussianMixture
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt

# Load the data
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# Determine the optimal number of clusters
silhouette_scores = []
K = range(2, 14)
for k in K:
    gmm = GaussianMixture(n_components=k, n_init=10, random_state=0)
    gmm.fit(data)
    labels = gmm.predict(data)
    score = silhouette_score(data, labels)
    silhouette_scores.append(score)

# Plot the silhouette score for each k
fig, ax = plt.subplots()
ax.plot(K, silhouette_scores, 'bx-')
ax.set_xlabel('Number of clusters')
ax.set_ylabel('Silhouette Score')
ax.set_title('GMM Silhouette Score')
plt.show()

# Apply GMM clustering with the optimal number of clusters
gmm = GaussianMixture(n_components=3, n_init=10, random_state=0)
gmm.fit(data)
labels = gmm.predict(data)

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

################################################################################

from sklearn.cluster import KMeans
from sklearn.mixture import GaussianMixture
from sklearn.metrics import silhouette_score
import numpy as np

# Load data
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# K-means clustering
kmeans = KMeans(n_clusters=4, random_state=0).fit(data)
kmeans_score = silhouette_score(data, kmeans.labels_)

# Gaussian Mixture Model clustering
gmm = GaussianMixture(n_components=2, random_state=0).fit(data)
gmm_score = silhouette_score(data, gmm.predict(data))

print(f"K-means silhouette score: {kmeans_score}")
print(f"GMM silhouette score: {gmm_score}")

################################################################################
import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.mixture import GaussianMixture
from sklearn.metrics import silhouette_score

# Load data
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# Perform K-means clustering with different number of clusters
kmeans_scores = []
for k in range(2, 14):
    kmeans = KMeans(n_clusters=k, random_state=0).fit(data)
    kmeans_scores.append(silhouette_score(data, kmeans.labels_))

# Perform GMM clustering with different number of components
gmm_scores = []
for k in range(2, 14):
    gmm = GaussianMixture(n_components=k, random_state=0).fit(data)
    gmm_scores.append(silhouette_score(data, gmm.predict(data)))

# Plot the silhouette scores for K-means and GMM clustering
plt.plot(range(2, 14), kmeans_scores, label='K-means')
plt.plot(range(2, 14), gmm_scores, label='GMM')
plt.xlabel('Number of Clusters/Components')
plt.ylabel('Silhouette Score')
plt.legend()
plt.show()

# Print the best number of clusters/components and the corresponding silhouette score
best_kmeans = np.argmax(kmeans_scores) + 2
best_gmm = np.argmax(gmm_scores) + 2
print(f'Best number of clusters for K-means: {best_kmeans}, silhouette score: {kmeans_scores[best_kmeans-2]}')
print(f'Best number of components for GMM: {best_gmm}, silhouette score: {gmm_scores[best_gmm-2]}')

################################################################################

import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.mixture import GaussianMixture
from sklearn.metrics import silhouette_score

# Load data
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# Perform K-means clustering
kmeans_scores = []
kmeans_silhouette_scores = []
for n_clusters in range(2, 11):
    kmeans = KMeans(n_clusters=n_clusters, random_state=0).fit(data)
    kmeans_scores.append(kmeans.score(data))
    kmeans_silhouette_scores.append(silhouette_score(data, kmeans.labels_))

# Perform GMM clustering
gmm_scores = []
gmm_silhouette_scores = []
for n_components in range(2, 11):
    gmm = GaussianMixture(n_components=n_components, random_state=0).fit(data)
    gmm_scores.append(gmm.score(data))
    gmm_silhouette_scores.append(silhouette_score(data, gmm.predict(data)))

# Plot performance scores
plt.plot(range(2, 11), kmeans_scores, '-o', label='K-means')
plt.plot(range(2, 11), gmm_scores, '-o', label='GMM')
plt.xlabel('Number of clusters/components')
plt.ylabel('Score')
plt.title('Performance comparison')
plt.legend()
plt.show()

# Plot silhouette scores
plt.plot(range(2, 11), kmeans_silhouette_scores, '-o', label='K-means')
plt.plot(range(2, 11), gmm_silhouette_scores, '-o', label='GMM')
plt.xlabel('Number of clusters/components')
plt.ylabel('Silhouette score')
plt.title('Silhouette score comparison')
plt.legend()
plt.show()

# Plot K-means clustering results with 3 clusters
kmeans = KMeans(n_clusters=3, random_state=0).fit(data)
plt.scatter(data[:, 0], data[:, 1], c=kmeans.labels_)
plt.xlabel('PC 1')
plt.ylabel('PC 2')
plt.title('K-means clustering with 3 clusters')
plt.show()

# Plot GMM clustering results with 3 components
gmm = GaussianMixture(n_components=3, random_state=0).fit(data)
plt.scatter(data[:, 0], data[:, 1], c=gmm.predict(data))
plt.xlabel('PC 1')
plt.ylabel('PC 2')
plt.title('GMM clustering with 3 components')
plt.show()
