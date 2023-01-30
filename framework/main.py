from data_handler import data_handler
import numpy as np
import matplotlib.pyplot as plt
from privacy import privacy
from sklearn.metrics import mean_squared_error, accuracy_score
handler = data_handler(file_path="datasets/cancer_patient_data_sets.csv")
priv = privacy()
num_features = handler.load_data()

#mechanism = np.array([[1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8],
#                      [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8],
#                      [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8],
#                      [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8],
#                      [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8],
#                      [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8],
#                      [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8],
#                      [1/8,1/8,1/8,1/8,1/8,1/8,1/8,1/8]])

#mechanism = np.array([[0.8,0.2],[0.2,0.8]])
#mechanism = np.eye(2)

step = 0.01
iters = int(1/step)
MSEs = np.zeros(iters)
ACCs = np.zeros(iters)
PMLs = np.zeros(iters)
for index, i in enumerate(np.arange(0,1,step=step)):
    mechanism = np.array([[1-i,i],[i,1-i]])

    pml = priv.evaluate_PML(mechanism=mechanism,priors=np.array([0.5,0.5]))

    data = handler.data["Gender"]
    private_data = handler.privatize("Gender",mechansim=mechanism)
    mse = mean_squared_error(data,private_data)
    acc = accuracy_score(data,private_data)
    PMLs[index] = pml
    ACCs[index] = acc
    MSEs[index] = mse

plt.plot(PMLs,ACCs)
plt.show()


