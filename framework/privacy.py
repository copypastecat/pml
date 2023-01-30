import numpy as np

class privacy:

    def __init__(self):
        return None

    def evaluate_PML(self, mechanism,priors):
        # numpy-array indexing: A[row,column]

        leakage = np.zeros(len(mechanism[:,0]))

        for i, column in enumerate(mechanism.T):
            leakage[i] = np.log(np.max(column)/np.sum(priors*column))

        return np.max(leakage)


    def evaluate_LDP(self,mechanism):
        return None

    def randomizes_response(self,n_features,epsilon):
        return True # return mechanism here
