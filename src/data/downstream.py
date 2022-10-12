# downstream.py
import pandas as pd
from connect import DATA_PATH
import json


def get_gdp_data():
    """Get GDP data from the DB."""

    file_name = f'{DATA_PATH}/raw/gdp_data.json'
    resp = json.load(open(file_name))
    data = pd.DataFrame(resp['data'])

    data['date'] = data['date'].apply(pd.to_datetime)
    data['value'] = data['value'].astype('float')

    return data


def get_stock_data():
    """Get SP500 data from the DB."""
    file_name = f'{DATA_PATH}/raw/stock_data.json'
    resp = json.load(open(file_name))
    data = pd.DataFrame(resp['Time Series (Daily)']).T.reset_index()

    data.columns = ['date', 'open', 'high', 'low', 'close', 'volume']
    data['date'] = data['date'].apply(pd.to_datetime)

    return data
