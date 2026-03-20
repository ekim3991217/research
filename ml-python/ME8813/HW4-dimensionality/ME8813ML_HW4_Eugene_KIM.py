
################################################################################
# PROBLEM 1 GENERATE SCREE PLOT

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.decomposition import PCA

# Load the data
# data = pd.read_csv("HW4Dataset.csv", header=None)
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# Perform PCA
pca = PCA()
pca.fit(data)
eigenvalues = pca.explained_variance_

# Generate scree plot
fig, ax = plt.subplots()
ax.plot(np.arange(1, len(eigenvalues)+1), eigenvalues, 'ro-', linewidth=2)
ax.set_xlabel('Principal Component')
ax.set_ylabel('Eigenvalue')
ax.set_title('Scree Plot')
plt.show()

################################################################################
# PROBLEM 2 K MEANS CLUSTIENRING, USE SSE AND RANDOM RESTART 
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans

# Load the data
# data = pd.read_csv("HW4Dataset.csv", header=None)
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# Calculate within-cluster sum of squares for each k
max_k = 10
wcss = []
for k in range(1, max_k+1):
    kmeans = KMeans(n_clusters=k, n_init=10, max_iter=300, random_state=0)
    kmeans.fit(data)
    wcss.append(kmeans.inertia_)

# Plot SSE vs. k
fig, ax = plt.subplots()
ax.plot(np.arange(1, max_k+1), wcss, 'ro-', linewidth=2)
ax.set_xlabel('Number of Clusters (k)')
ax.set_ylabel('Within-Cluster Sum of Squares (SSE)')
ax.set_title('Elbow Method')
plt.show()

################################################################################
# PROBLEM 3 GMM clustering 
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.mixture import GaussianMixture

# Load the data
# data = pd.read_csv("HW4Dataset.csv", header=None)
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)


# Perform GMM clustering
n_components = 4
gmm = GaussianMixture(n_components=n_components, covariance_type='full', random_state=0)
gmm.fit(data)
labels = gmm.predict(data)

# Visualize the results
fig, ax = plt.subplots()
scatter = ax.scatter(data.iloc[:, 0], data.iloc[:, 1], c=labels, cmap='viridis')
legend1 = ax.legend(*scatter.legend_elements(),
                    loc="upper right", title="Clusters")
ax.add_artist(legend1)
ax.set_xlabel('PC1')
ax.set_ylabel('PC2')
ax.set_title('GMM Clustering')
plt.show()

################################################################################
# PROBLEM 4 AUTOENCODER 
import pandas as pd
import numpy as np
import keras
import tensorflow as tf 
from keras.models import Model
from keras.layers import Input, Dense

# from tensorflow.keras.models import Model
# from tensorflow.keras.layers import Input, Dense

# Load data
data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW4_Dimension/HW4Dataset.csv',header=None)

# Define autoencoder architecture
input_dim = data.shape[1]
encoding_dim = 5
input_layer = Input(shape=(input_dim,))
encoder = Dense(encoding_dim, activation='relu')(input_layer)
decoder = Dense(input_dim, activation='sigmoid')(encoder)

# Define autoencoder model
autoencoder = Model(inputs=input_layer, outputs=decoder)
autoencoder.compile(optimizer='adam', loss='mse')

# Train autoencoder on data
autoencoder.fit(data, data, epochs=50, batch_size=32)

# Use encoder to obtain reduced-dimension representation of data
encoder_model = Model(inputs=input_layer, outputs=encoder)
encoded_data = encoder_model.predict(data)

# Print shape of encoded data
print(encoded_data.shape)
