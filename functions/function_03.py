import pandas as pd
import numpy as np


def data(cols=4, rows=5):
    a = np.random.randn(rows, cols)
    df = pd.DataFrame(data=a, columns=[f'col_{i}' for i in range(a.shape[1])])
    print(df)
    return df
