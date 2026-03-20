################################################################################
##  ME8813ML Homework 1: 
##  Implement a quasi-Newton optimization method for data fitting
#####################################################
import numpy as np
import matplotlib.pyplot as plt
import sympy


########################################################
## Implement a parameter fitting function fit() so that 
##  p = DFP_fit(x,y)
## returns a list of the parameters as p of model:
##  p0 + p1*cos(2*pi*x) + p2*cos(4*pi*x) + p3*cos(6*pi*x) + p4*cos(8*pi*x) 
########################################################


# Fixing random state for reproducibility
np.random.seed(19680801)

dx = 0.1
x_lower_limit = 0
x_upper_limit = 40                                       
x = np.arange(x_lower_limit, x_upper_limit, dx)
data_size = len(x)                                 # data size
noise = np.random.randn(data_size)                 # white noise

# Original dataset 
y = 2.0 + 3.0*np.cos(2*np.pi*x) + 1.0*np.cos(6*np.pi*x) + noise

epsilon = 0.5

def DFP_fit(x,y,epsilon):
    p = np.array([[1],[2],[3],[4]])
    b = np.identity(4)
    while True:
        alpha=10
        L = np.sum((p[0] + p[1]*np.cos(2*np.pi*x) + p[2]*np.cos(4*np.pi*x) + p[3]*np.cos(6*np.pi*x) - y)**2)
        grad_L = np.ndarray([4,1])
        grad_L[0] = 2*np.sum(p[0] + p[1]*np.cos(2*np.pi*x) + p[2]*np.cos(4*np.pi*x) + p[3]*np.cos(6*np.pi*x) - y)
        grad_L[1] = 2*np.sum((p[0] + p[1]*np.cos(2*np.pi*x) + p[2]*np.cos(4*np.pi*x) + p[3]*np.cos(6*np.pi*x) - y)*np.cos(2*np.pi*x))
        grad_L[2] = 2*np.sum((p[0] + p[1]*np.cos(2*np.pi*x) + p[2]*np.cos(4*np.pi*x) + p[3]*np.cos(6*np.pi*x) - y)*np.cos(4*np.pi*x))
        grad_L[3] = 2*np.sum((p[0] + p[1]*np.cos(2*np.pi*x) + p[2]*np.cos(4*np.pi*x) + p[3]*np.cos(6*np.pi*x) - y)*np.cos(6*np.pi*x))
        d = np.matmul(-1*b,grad_L)
        
        while True:
            p_tmp = p - alpha*grad_L
            L_tmp = np.sum(np.power((p_tmp[0] + p_tmp[1]*np.cos(2*np.pi*x) + p_tmp[2]*np.cos(4*np.pi*x) + p_tmp[3]*np.cos(6*np.pi*x) - y), 2))
        
            if abs(L-L_tmp) <= epsilon*alpha*(np.linalg.norm(grad_L))**2:
                break
            alpha = alpha*0.5
        
        p_new = p + alpha*d
        delta_p = p_new-p
        grad_L_new = np.ndarray([4,1])
        grad_L_new[0] = 2*np.sum(p_new[0] + p_new[1]*np.cos(2*np.pi*x) + p_new[2]*np.cos(4*np.pi*x) + p_new[3]*np.cos(6*np.pi*x) - y)
        grad_L_new[1] = 2*np.sum((p_new[0] + p_new[1]*np.cos(2*np.pi*x) + p_new[2]*np.cos(4*np.pi*x) + p_new[3]*np.cos(6*np.pi*x) - y)*np.cos(2*np.pi*x))
        grad_L_new[2] = 2*np.sum((p_new[0] + p_new[1]*np.cos(2*np.pi*x) + p_new[2]*np.cos(4*np.pi*x) + p_new[3]*np.cos(6*np.pi*x) - y)*np.cos(4*np.pi*x))
        grad_L_new[3] = 2*np.sum((p_new[0] + p_new[1]*np.cos(2*np.pi*x) + p_new[2]*np.cos(4*np.pi*x) + p_new[3]*np.cos(6*np.pi*x) - y)*np.cos(6*np.pi*x)) 
        delta_g = grad_L_new - grad_L
        
        if np.linalg.norm(delta_p) == 0:
            break
        
        b = b + np.matmul(delta_p,delta_p.T) / (np.matmul(delta_p.T,delta_g)) - np.matmul(np.matmul(b,delta_g),np.matmul(b,delta_g).T) / (np.matmul(delta_g.T, np.matmul(b, delta_g)))
        current_error = np.matmul(grad_L_new.T,grad_L_new)
        
        if current_error < 0.3:
            return p
            break
        
        p = p_new
        grad_L = grad_L_new

###########################################
p = DFP_fit(x, y, epsilon)
###########################################


fig, axs = plt.subplots(2, 1)
axs[0].plot(x, y)
axs[0].set_xlim(x_lower_limit, x_upper_limit)
axs[0].set_xlabel('x')
axs[0].set_ylabel('observation')
axs[0].grid(True)


#########################################
## Plot the predictions from your fitted model here
pred_y = p[0] + p[1]*np.cos(2*np.pi*x) + p[2]*np.cos(4*np.pi*x) + p[3]*np.cos(6*np.pi*x)
axs[1].plot(x,pred_y)
axs[1].set_xlim(x_lower_limit, x_upper_limit)
axs[1].set_xlabel('x')
axs[1].set_ylabel('model prediction')

fig.tight_layout()
plt.show()
