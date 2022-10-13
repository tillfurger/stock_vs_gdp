from downstream import get_gdp_data, get_stock_data
from connect import DATA_PATH
import numpy as np
import pandas as pd

stock_data = get_stock_data()
stock_data['return'] = stock_data['adjusted_close'].pct_change()
stock_data['q_date'] = stock_data['date'].dt.to_period('Q')
stock_data['return_1'] = stock_data['return'] + 1
stock_data['q_return'] = stock_data.groupby(['q_date'])['return_1'].transform(np.product) - 1
clean_stock_data = stock_data.groupby('q_date').first().drop(columns=['return_1', 'return'])
clean_stock_data['date'] = clean_stock_data['date'] + pd.offsets.MonthBegin(1)
clean_stock_data.to_csv(f'{DATA_PATH}/processed/clean_stock_data.csv', index=False)

gdp_data = get_gdp_data()
gdp_data.to_csv(f'{DATA_PATH}/processed/clean_gdp_data.csv', index=False)
