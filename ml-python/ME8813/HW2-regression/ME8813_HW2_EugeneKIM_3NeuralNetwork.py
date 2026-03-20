#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 16 17:09:20 2023

@author: eugenekim
"""

#####################################################
##  ME8813ML Homework 2: 
##  Eugene Kim
#####################################################
import numpy as np

import sklearn.model_selection

import sklearn.linear_model

import matplotlib.pyplot as plt

import pandas as pd

import numpy

from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import (
    RBF,
    WhiteKernel,
    ExpSineSquared,
    DotProduct
)

import keras
from keras import backend as K
from keras import Sequential

import tensorflow as tf
from sklearn.model_selection import KFold
from sklearn import preprocessing

random = 420

data = pd.read_csv(r'/Users/eugenekim/Dropbox (GaTech)/ME 8813 ML for Mechanical Engineers/HW2_Regression/HW2Dataset.csv')
data = data.to_numpy()
X = data[:,1:-1]
y = data[:,-1]

X_train, X_test, y_train, y_test = sklearn.model_selection.train_test_split(X,y,test_size=0.3,random_state=random)

## Cross validation split
kfold = KFold(n_splits=5, shuffle=True, random_state = random)

## Standardize data
scaler = preprocessing.StandardScaler().fit(X_train)
X_train = scaler.transform(X_train)
X_test = scaler.transform(X_test)

#####################################################
##  PROBLEM 3: NEURAL NETWORK
#####################################################
# # Build Neural Network
from keras.layers import Dense

for train, test in kfold.split(X_train, y_train):
    model = keras.Sequential()
    model.add(Dense(20, input_shape=(15,)))
    model.add(Dense(100, activation="elu"))
    model.add(Dense(100, activation="elu"))
    model.add(Dense(1))
    
    # Define the optimizer and its hyperparameters
    opt = tf.keras.optimizers.Adam(
        learning_rate=0.001
    )
    
    # Compile model
    model.compile(optimizer=opt,
                  loss='mean_squared_error',)
    
    # Train the NN model
    # The gradients are modified every 50 samples (batch size)
    history = model.fit(x=X_train[train], y=y_train[train], epochs=250, batch_size=50, validation_split=0.2,verbose = 0)
    
    y_pred = model.predict(X_train[test])
    
    print('NN cross val r^2: ')
    print(sklearn.metrics.r2_score(y_train[test],y_pred))
    print('NN cross val MSE: ')
    print(sklearn.metrics.mean_squared_error(y_train[test],y_pred))

model = keras.Sequential()
model.add(Dense(20, input_shape=(15,)))
model.add(Dense(100, activation="elu"))
model.add(Dense(100, activation="elu"))
model.add(Dense(1))

# Define the optimizer and its hyperparameters
opt = tf.keras.optimizers.Adam(
    learning_rate=0.001
)

# Compile model
model.compile(optimizer=opt,
              loss='mean_squared_error',)

# Train the NN model
# The gradients are modified every 50 samples (batch size)
history = model.fit(x=X_train, y=y_train, epochs=250, batch_size=50, validation_split=0.2,verbose = 0)

y_pred = model.predict(X_test)

plt.figure()
plt.scatter(y_test,y_pred)

plt.title('Neural Network')
plt.xlabel('Actual')
plt.ylabel('Prediction')

print('NN r^2: ')
print(sklearn.metrics.r2_score(y_test,y_pred))
print('NN MSE: ')
print(sklearn.metrics.mean_squared_error(y_test,y_pred))

