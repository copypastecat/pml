import matplotlib.pyplot as plt
import numpy as np
from egtsimplex.egtsimplex import simplex_dynamics
from math import *

priors = np.array([0.6,0.2,0.2])
assert (np.sum(priors) > 1 - 0.05 and np.sum(priors) < 1 + 0.05), "priors aren't valid pmf (don't sum to 1)"
epsilon = 0.35

#define privacy function as function of transition  probabilities p
def f(p,t):
    leakage = np.log(np.max(p)) - np.log(np.dot(priors,p))
    #print(np.greater(leakage,exp(epsilon)))
    return np.greater(leakage,epsilon)


#initialize simplex_dynamics object with function
dynamics=simplex_dynamics(f)

#plot the simplex dynamics
fig,ax=plt.subplots()
dynamics.plot_simplex(ax)
plt.show()