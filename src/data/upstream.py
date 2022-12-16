import os
import json
import requests
from connect import DATA_PATH
import pandas as pd
from fredapi import Fred
import yfinance as yf
import time

API_KEY = os.environ.get("ALPHA_VANTAGE_API_KEY")
FRED_API_KEY = os.environ.get("FRED_API_KEY")

print("Obtaining GDP data for the US from AlphaVantage")
gdp_url = f'https://www.alphavantage.co/query?function=REAL_GDP&interval=quarterly&apikey={API_KEY}'
gdp_r = requests.get(gdp_url)
gdp_data = gdp_r.json()

with open(f'{DATA_PATH}/raw/gdp_data.json', 'w') as outfile:
    json.dump(gdp_data, outfile)

print("Obtaining Stock index data for the US from AlphaVantage")
stock_url = f'https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=SPY&apikey={API_KEY}'
stock_r = requests.get(stock_url)
stock_data = stock_r.json()

with open(f'{DATA_PATH}/raw/stock_data.json', 'w') as outfile:
    json.dump(stock_data, outfile)


# Request income level data from the World Bank API
# First, we need a catalogue with ISO 2 codes
cat_countries = pd.read_excel(DATA_PATH + "catalogues/CountriesCatalogues.xlsx", sheet_name="ISO Codes", usecols=["Country", "ISO_2"])
# World Bank requires lowecase iso codes
cat_countries.loc[:, "ISO_2"] = cat_countries.ISO_2.str.lower()
country_codes = cat_countries.ISO_2.to_numpy()
income_data = pd.DataFrame()
print("Obtaining income data from the World Bank API")
for c in country_codes:
    income_url = f'http://api.worldbank.org/v2/country/{c}?format=json'
    inc_r = requests.get(income_url)
    inc_data = inc_r.json()
    if len(inc_data) == 1 and inc_data[0]["message"][0]["key"] == 'Invalid value':
        next
    else:
        # write
        #with open(f'{DATA_PATH}/raw/income_data_{c}.json', 'w') as outfile:
        #    json.dump(inc_data, outfile)
        aux_r = pd.DataFrame(inc_data[1][0])
        income_data = pd.concat([income_data, aux_r])

# Filter to keep only wanted values and save
income_data = income_data.loc["value", :]
income_data = income_data.reset_index().drop("index", axis=1)
income_data.to_csv(f'{DATA_PATH}/processed/clean_income_data.csv', index=False)

# Request GDP quarterly data from the FRED API, we will use the fredapi package
fred = Fred(api_key=FRED_API_KEY)
gdp_all_data = pd.DataFrame()
print("Obtaining GDP data for a sample of countries from FRED")
for c in country_codes:
    try:
        series_id = f'NGDPRSAXDC{c.upper()}Q'
        aux_d = fred.get_series(series_id).to_frame().reset_index()
        aux_d.rename(columns={"index":"date", 0:"value"}, inplace=True)
        aux_d["country"] = c.upper()
        gdp_all_data = pd.concat([gdp_all_data, aux_d], axis=0, ignore_index=True)
    except:
        print(f'{c} does not have data in FRED')
        next
    time.sleep(1)
    

# Add quarter id to the observations
gdp_all_data['q_date'] = gdp_all_data['date'].dt.to_period('Q')

# Save
gdp_all_data.to_csv(f'{DATA_PATH}/processed/clean_gdp_data_all.csv', index=False)

# Request stock indexes data using a python wrapper for the Yahoo Finance API
countries_indexes_tickers = pd.read_excel(f'{DATA_PATH}/catalogues/CountriesCatalogues.xlsx', sheet_name="StockIndexes_Tickers")
tickers = countries_indexes_tickers["YahooFinance Ticker"].to_numpy()
stock_all_data = pd.DataFrame()
print("Obtaining Stock Indexes data for a sample of countries from Yahoo Finance")
for t in tickers:
    try:
        ticker = yf.Ticker(t)
        d = ticker.history(period="max")
        d = d[["Close"]]
        d.reset_index(inplace=True)
        d["country"] = countries_indexes_tickers.loc[countries_indexes_tickers["YahooFinance Ticker"] == t, "ISO_2"].to_numpy()[0]
        stock_all_data = pd.concat([stock_all_data, d], axis=0)
    except:
        print(f'{t} does not have information in Yahoo Finance')
        next
    time.sleep(1)

# Clean and save data
stock_all_data["Date"] = stock_all_data["Date"].apply(lambda x: x.date()).apply(lambda x: pd.to_datetime(x))
stock_all_data.rename(columns={"Date":"date", "Close":"value"}, inplace=True)
stock_all_data.to_csv(f'{DATA_PATH}/raw/stock_data_all.csv', index=False)