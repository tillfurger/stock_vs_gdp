import os
import json
import requests
from connect import DATA_PATH

API_KEY = os.environ.get("ALPHA_VANTAGE_API_KEY")

gdp_url = f'https://www.alphavantage.co/query?function=REAL_GDP&interval=quarterly&apikey={API_KEY}'
gdp_r = requests.get(gdp_url)
gdp_data = gdp_r.json()

with open(f'{DATA_PATH}/raw/gdp_data.json', 'w') as outfile:
    json.dump(gdp_data, outfile)

stock_url = f'https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=SPY&apikey={API_KEY}'
stock_r = requests.get(stock_url)
stock_data = stock_r.json()

with open(f'{DATA_PATH}/raw/stock_data.json', 'w') as outfile:
    json.dump(stock_data, outfile)
