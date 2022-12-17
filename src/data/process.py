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

# Prepare data for the shiny app
income_data = pd.read_csv(f'{DATA_PATH}/processed/clean_income_data.csv', usecols=["iso2Code", "name", "region", "incomeLevel"])
income_data.rename(columns={"iso2Code":"country", "incomeLevel":"income level"}, inplace=True)
income_data.set_index("country", inplace=True)

gdp_data_all = pd.read_csv(f'{DATA_PATH}/processed/clean_gdp_data_all.csv')
gdp_data_all.rename(columns={"value":"gdp"}, inplace=True)
gdp_data_all["date"] = pd.to_datetime(gdp_data_all.q_date)
gdp_data_all.set_index(["country", "date"], inplace=True)
gdp_data_all.drop("q_date", axis=1, inplace=True)

stock_data_all = pd.read_csv(f'{DATA_PATH}/processed/clean_stock_data_all.csv', usecols=["q_date", "value", "country"])
stock_data_all.rename(columns={"value":"stock_index"}, inplace=True)
stock_data_all["date"] = pd.to_datetime(stock_data_all.q_date)
stock_data_all.set_index(["country", "date"], inplace=True)
stock_data_all.drop("q_date", axis=1, inplace=True)

data_all = gdp_data_all.join(stock_data_all)
data_all = data_all.sort_index()
data_all.dropna(how="any", inplace=True)

data_all = data_all.join(income_data)

data_all = data_all.loc[data_all.index.get_level_values("date") >= "2000-01-01", :]
countries = data_all.index.get_level_values("country").unique()

# Do the calculations for each country
data_all.reset_index(inplace=True)
data = pd.DataFrame()
for c in countries:
    aux_d = data_all.loc[data_all.country == c, :]
    aux_d.sort_values("date", inplace=True)
    aux_d["gdp_q_growth"] = aux_d.gdp.pct_change(1)
    aux_d["stock_index_q_growth"] = aux_d.stock_index.pct_change(1)
    aux_d["gdp_y_growth"] = aux_d.gdp.pct_change(4)
    aux_d["stock_index_y_growth"] = aux_d.stock_index.pct_change(4)
    aux_d["gdp_100"] = 100*np.exp(np.nan_to_num(aux_d["gdp_q_growth"].cumsum()))
    aux_d["stock_index_100"] = 100*np.exp(np.nan_to_num(aux_d["stock_index_q_growth"].cumsum()))
    data = pd.concat([data, aux_d])

data.set_index(["country", "date"], inplace=True)
data.to_csv(f'{DATA_PATH}/processed/data_full_shiny.csv', index=True)

# change to a long format to help visualizations in the shiny app
data_long = data.melt(ignore_index=False, id_vars=["name", "region"],
                      value_vars=["gdp", "stock_index", "gdp_q_growth",
                                  "stock_index_q_growth", "gdp_y_growth",
                                  "stock_index_y_growth", "gdp_100", "stock_index_100"])
data_long.to_csv(f'{DATA_PATH}/processed/data_full_shiny_long.csv', index=True)
