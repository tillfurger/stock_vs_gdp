from downstream import get_gdp_data, get_stock_data
from connect import DATA_PATH
import numpy as np
import pandas as pd

# Import clean and save stock data
stock_data = get_stock_data()
stock_data['return'] = stock_data['adjusted_close'].pct_change()
stock_data['q_date'] = stock_data['date'].dt.to_period('Q')
stock_data['return_1'] = stock_data['return'] + 1
stock_data['q_return'] = stock_data.groupby(['q_date'])['return_1'].transform(np.product) - 1
clean_stock_data = stock_data.groupby('q_date').first().drop(columns=['return_1', 'return'])
clean_stock_data['date'] = clean_stock_data['date'] + pd.offsets.MonthBegin(1)
clean_stock_data.to_csv(f'{DATA_PATH}/processed/clean_stock_data.csv', index=False)

# Import clean and save gdp data
gdp_data = get_gdp_data()
gdp_data.to_csv(f'{DATA_PATH}/processed/clean_gdp_data.csv', index=False)

# Import clean and save stock indexes data with more countries
stock_data_all = pd.read_csv(f'{DATA_PATH}/raw/stock_data_all.csv')
stock_data_all["date"] = stock_data_all.date.apply(pd.to_datetime)
stock_data_all["q_date"] = stock_data_all["date"].dt.to_period('Q')
clean_stock_data_all = stock_data_all.groupby(['q_date', 'country'], as_index=False).first()
clean_stock_data_all["date"] = clean_stock_data_all["date"] + pd.offsets.MonthBegin(-1)
clean_stock_data_all.to_csv(f'{DATA_PATH}/processed/clean_stock_data_all.csv', index=False)
