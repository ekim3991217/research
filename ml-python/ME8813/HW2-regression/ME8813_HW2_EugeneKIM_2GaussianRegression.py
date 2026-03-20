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
##  PROBLEM 2: GAUSSIAN REGRESSION
#####################################################
for train, test in kfold.split(X_train, y_train):
    X_train5 = X_train[:,0:5]
    kernel = RBF(length_scale=[1,1,1,1,1])
    gp_regressor = GaussianProcessRegressor(kernel=kernel, alpha=1, normalize_y=False)
    gp_regressor.fit(X_train5[train], y_train[train])
    print(f"RBF Lengthscale: {gp_regressor.kernel_}")
    
    y_pred_mean, y_pred_std = gp_regressor.predict(X_train[test,0:5], return_std=True)
    
    print('GPR cross val r^2: ')
    print(sklearn.metrics.r2_score(y_train[test],y_pred_mean))
    print('GPR cross val MSE: ')
    print(sklearn.metrics.mean_squared_error(y_train[test],y_pred_mean))
    
X_train5 = X_train[:,0:5]

kernel = RBF(length_scale=[1,1,1,1,1])
gp_regressor = GaussianProcessRegressor(kernel=kernel, alpha=1, normalize_y=False)
gp_regressor.fit(X_train5, y_train)
print(f"RBF Lengthscale: {gp_regressor.kernel_}")

y_pred_mean, y_pred_std = gp_regressor.predict(X_test[:,0:5], return_std=True)

plt.figure()
plt.scatter(y_test,y_pred_mean)

plt.title('Gaussian Regression')
plt.xlabel('Actual')
plt.ylabel('Prediction')

print('GPR r^2: ')
print(sklearn.metrics.r2_score(y_test,y_pred_mean))
print('GPR MSE: ')
print(sklearn.metrics.mean_squared_error(y_test,y_pred_mean))
