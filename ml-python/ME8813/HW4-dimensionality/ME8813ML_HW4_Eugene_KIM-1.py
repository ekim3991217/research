import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# load the data from the CSV file
data = pd.read_csv('HW4Dataset.csv')

# calculate the covariance matrix of the data
cov_matrix = np.cov(data.T)

# calculate the eigenvalues and eigenvectors of the covariance matrix
eig_vals, eig_vecs = np.linalg.eig(cov_matrix)

# sort the eigenvalues and eigenvectors in descending order
idx = eig_vals.argsort()[::-1]
eig_vals = eig_vals[idx]
eig_vecs = eig_vecs[:, idx]

# plot the scree plot
plt.plot(np.arange(1, 16), eig_vals, 'o-', color='black')
plt.xlabel('Principal Component')
plt.ylabel('Eigenvalue')
plt.title('Scree Plot')
plt.show()
