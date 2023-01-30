import pandas as pd
import numpy as np
from os.path import join
from pathlib import Path
from numpy.random import choice

class data_handler:

    def __init__(self,file_path):
        self.path = join(Path(__file__).parent.resolve(),file_path)
        self.data = None
        self.privateized_data = None
        self.file_name = file_path

    def load_data(self):
        df = pd.read_csv(self.path,index_col="index")
        print("Loaded data ", self.file_name, "has ", df.isna().sum().sum(), " NaNs ... dropping")
        df.dropna(inplace=True)
        print(df.describe())
        self.data = df

        if(not self.data.empty):
            return self.data.shape[1] # returns the number of features
        else:
            print("No data loaded!")
            return False

    def privatize(self,column,mechansim):
        categories = self.get_categories(column=column)
        feature = self.data[column]
        y = np.empty(len(feature))
        for idx, values in enumerate(feature):
            mech_col = np.where(categories == values)[0][0]
            pmf = mechansim[mech_col,:]
            y[idx] = choice(categories,1,p=pmf)

        return pd.Series(y,dtype=int)



    def get_categories(self, column):
        feature = self.data[column]
        categories = feature.unique()

        return categories


        