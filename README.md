Final Project: Stock Market Capitalization vs. GDP Growth
==============================

Intro
------------

In this project, we are examining whether the stock market capitalization grows faster than the GDP, with a focus on developed countries, namely the United States. The ratio between a country's market capitalization and its GDP is also called the "Buffet indicator" and is often used to get an insight if the stock market is undervalued or overvalued. 

For our research, we use data from Alpha Vantage for the United States and provide an analysis of the data through graphs and tables. In a second step, we are comparing our analysis to the situation in Indonesia and Mexico to get insights about the situation in upper middle and lower middle income countries and to bring forth potential similarities and differences. In order to visualize these effectively, we have developed an [interactive app](https://flurinaschneider.shinyapps.io/DTFF22/) where each user can undertake robustness checks on his own. We have considered visualisation principles for our graphs and apps and designed them in a colorblind-friendly manner (checked with Colorblindly).

We find that between 2000 and 2022, there is a positive correlation if we regress the SPY on the US GDP. However, the average US GDP growth rate lies below the average growth rate of the SPY. The median growth rate of the US GDP is lower than the median growth rate of the stock market capitalization as well and the volatility of the SPY growth rate is larger. For the same time period, both Indonesia's mean stock index growth rate and GDP growth rate exceed the respective ones of the United States. Mexico's mean GDP rate is below the US mean GDP rate, its mean stock index growth rate above the one of the USA. 

In conclusion, the stock market capitalization is growing at a faster rate then the GDP in all three of the examined countries. If we interpret the results according to the Buffet Indicator, the results might indicate a potential bubble.

Project Organization
------------

    ├── LICENSE
    ├── README.md                   <- The top-level README for developers using this project
    ├── data
    │   ├── processed               <- The final, canonical data sets for modeling
    │   └── raw                     <- The original, immutable data dump
    │   └── catalogues              <- Country catalogues
    │
    ├── notebooks                   <- Jupyter notebooks
    │
    │
    ├── reports                     <- Generated analysis as PDF and LaTeX report and beamer presentation
    │   └── figures                 <- Generated graphics and figures to be used in reporting as .svg
    │   └── svg-inkscape            <- Generated graphics and figures to be used in reporting as .pdf and .pdf_tex
    │   └── tables                  <- Generated tables to be used in reporting as .tex
    │
    │
    ├── src                         <- Source code for use in this project
    │   └──init__.py              <- Makes src a Python module
    │   │
    │   └── data                    <- Scripts to download or generate data
    │       └── make_dataset.py
    │ 
    │ 
    │── shiny                       <- Rshiny application folder
    │   └── rsconnect/shinyapp.io   <- Hosting app online
    │   └── shiny_data              <- Data pre-processed for shiny app
    |   └── app.R                   <- Interactive app
    │
    │
    │
    └── requirements.txt            <- Requirements necessary for this project


Description of Steps 
------------

- Preparation of  a folder structure, using the cookiecutter Data Science template

- Import of data, both raw and processed (stock market capitalization and GDP for both developed and emerging markets)

- Create upstream and downstream functions

- Generation of tables which can be directly imported to Latex 

- Connect Overleaf to Github (all Overleaf Files can be directly accessed [here](https://www.overleaf.com/7537555654mtpkfdhpvwcf))

- Use R Shiny and Plotly to create interactive graphs in order to do robustness checks (date range, frequency, different countries)

- Making Shiny app reproducible by adding a Dockerfile

- Analysis and interpretation of findings

- Compare results with current research

Data 
------------

US GPD and SPY data is pulled from [Alpha Vantage](www.alphavantage.co)

Income level data for multiple countries is obtained from the [World Bank API](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-about-the-indicators-api-documentation)

GDP quarterly data for a sample of countries is obtained from the [FRED API](https://fred.stlouisfed.org/docs/api/fred/) using the [fredapi](https://github.com/mortada/fredapi) python package.

Stock indices data is obtained from [Yahoo Finance](https://finance.yahoo.com) using the [yfinance](https://pypi.org/project/yfinance/) python package.

Resources
------------
Aali-Bujari, Ali, Francisco Venegas-Mart ́ınez, and Gilberto P ́erez-Lechuga (Dec. 2017). “Impact of the stock market capitalization and the banking spread in growth and development in Latin American: A panel data estimation with System GMM”. In: Contaduria y Administracion 62(5), pp. 1427–1441. issn: 0186-1042. https://doi.org/10.1016/j.cya.2017.09.005

Corporate Finance Institute (Dec. 2022). Market Cap to GDP Ratio (the Buffett Indicator). https://corporatefinanceinstitute.com/resources/valuation/market-cap-to-gdp-buffett-indicator/

How the Stock Market Affects GDP (2022).https://www.investopedia.com/ask/answers/033015/how-does-stock-market-affect-gross-domestic-product-gdp.asp

Inc. MSCI (May 2010). Is There a Link between GDP Growth and Equity Returns? SSRN Scholarly Paper. Rochester, NY. Inc., MSCI, Is There a Link between GDP Growth and Equity Returns? (May 13, 2010). MSCI Barra Research Paper No. 2010-18. http://dx.doi.org/10.2139/ssrn.1707483

Kuvshinov, Dmitry and Kaspar Zimmermann (Aug. 2022). “The big bang: Stock market capitalization in the long run”. In: Journal of Financial Economics 145(2, Part B), pp. 527–552. issn: 0304-405X. https://doi.org/10.1016/j.jfineco.2021.09.008 

Prats, Maria A. and Beatriz Sandoval (Dec. 2020). “Does stock market capitalization cause GDP? A causality study for Central and Eastern European countries”. en. In: Economics 14(1). Publisher: De Gruyter Open Access. issn: 1864-6042. https://doi.org/10.1016/j.cya.2017.09.005

Contributors
------------

Flurina Schneider (@flurinaschneider), Till Furger (@tillfurger), Luis Escobar Farfan (@Iescobarfarfan), Martina Stieger (@mstiege)

--------

<p><small>Project based on the <a target="_blank" href="https://drivendata.github.io/cookiecutter-data-science/">cookiecutter data science project template</a>. #cookiecutterdatascience</small></p>
