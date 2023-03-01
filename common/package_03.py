import pandas as pd
import numpy as np
import logging


def data(cols, rows):
    logging.info(f'Rows: {rows} | Cols: {cols}')

    a = np.random.randn(rows, cols)
    df = pd.DataFrame(data=a, columns=[f'col_{i}' for i in range(a.shape[1])])
    return df
