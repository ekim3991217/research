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
##  PROBLEM 1: LINEAR REGRESSION
#####################################################
## linear regression: no regularization
model = sklearn.linear_model.LinearRegression(fit_intercept=True)
model.fit(X_train,y_train)
w_L = model.coef_
intercept = model.intercept_

y_pred = numpy.dot(X_test, w_L) + intercept

##  plot 1: linear regression without regularization
plt.figure()
plt.scatter(y_test,y_pred)

plt.title('Linear Regression')
plt.xlabel('Actual')
plt.ylabel('Prediction')

print('Linear reg R^2: ')
print(sklearn.metrics.r2_score(y_test,y_pred))
print('Linear reg MSE: ')
print(sklearn.metrics.mean_squared_error(y_test,y_pred))

## linear regression: lasso regularization 
model = sklearn.linear_model.LassoCV(cv = 5, random_state = random)
model.fit(X_train,y_train)
a = model.alpha_

model = sklearn.linear_model.Lasso(alpha = a)
model.fit(X_train,y_train)
w_L = model.coef_
intercept = model.intercept_

y_pred = numpy.dot(X_test, w_L) + intercept

##  plot 2: linear regression with lasso regularization 
plt.figure()
plt.scatter(y_test,y_pred)

plt.title('Linear Regression (Lasso)')
plt.xlabel('Actual')
plt.ylabel('Prediction')

print('Lasso R^2: ')
print(sklearn.metrics.r2_score(y_test,y_pred))
print('Lasso MSE: ')
print(sklearn.metrics.mean_squared_error(y_test,y_pred))

## linear regression: ridge regularization 
model = sklearn.linear_model.RidgeCV(cv=5)
model.fit(X_train,y_train)
a = model.alpha_

model = sklearn.linear_model.Ridge()
model.fit(X_train,y_train)
w_L = model.coef_
intercept = model.intercept_

y_pred = numpy.dot(X_test, w_L) + intercept

##  plot 3: linear regression with ridge regularization 
plt.figure()
plt.scatter(y_test,y_pred)

plt.title('Linear Regression (Ridge)')
plt.xlabel('Actual')
plt.ylabel('Prediction')

print('Ridge R^2: ')
print(sklearn.metrics.r2_score(y_test,y_pred))
print('Ridge MSE: ')
print(sklearn.metrics.mean_squared_error(y_test,y_pred))