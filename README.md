Final Project: Stock Market Capitalization vs. GDP Growth
==============================

Intro
------------

In this project, we are examining whether the stock market capitalization grows faster than the GDP, with a focus on developed countries, namely the United States. The ratio between a country's market capitalization and its GDP is also called the "Buffet indicator" and is often used to get an insight if the stock market is undervalued or overvalued. 

For our research, we use data from Alpha Vantage for the United States and provide an analysis of the data through graphs and tables. We also give a short interpretation of our findings. In a second step, we are comparing our analysis to the situation in Indonesia and Mexico in order to get insights about the situation in upper middle and lower middle income countries and to bring forth potential similarities and differences. In order to visualize these effectively, we have developed an [interactive app](https://flurinaschneider.shinyapps.io/DTFF22/) where each user can undertake robustness checks on his own. We have considered visualisation principles for our graphs and apps and designed them in a colorblind-friendly manner.

We find that between 2000 and 2022, there is a positive correlation if we regress the SPY on the US GDP. The average US GDP growth rate lies below the average growth rate of the SPY. The median growth rate of the US GDP is lower than the median growth rate of the stock market capitalization as well. The volatility of the SPY growth is larger. For the same time period, both Indonesia's mean stock index growth rate and GDP growth rate exceed the respective ones of the United States. Mexico's mean GDP rate is below the US mean GDP rate, its mean stock index growth rate above the one of the USA. 

Comparing our research to the findings of selected papers in the field, we can see...

Project Organization
------------

    ├── LICENSE
    ├── README.md                <- The top-level README for developers using this project.
    ├── data
    │   ├── processed            <- The final, canonical data sets for modeling.
    │   └── raw                  <- The original, immutable data dump.
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
    │   ├──__init__.py              <- Makes src a Python module
    │   │
    │   ├── data                    <- Scripts to download or generate data
    │       └── make_dataset.py
    │ 
    │ 
    │── shiny                       <- Shiny app
    │   └── rsconnect/shinyapp.io   <- Hosting app online
    │   └── app.R                   <- Interactive app
    |   └── shiny_data              <- data pre-processed for shiny app
    │
    │
    │
    └── requirements.txt         <- Requirements necessary for this project


Description of Steps 
------------

- Preparation of  a folder structure, using the cookiecutter Data Science template

- Import of data, both raw and processed (stock market capitalization and GDP for both developed and emerging markets)

- Create upstream and downstream functions

- Generation of tables which can be directly imported to Latex 

- Connect Overleaf to Github

- Use Docker to ensure reproducibility by packaging and sharing environments in a consistent manner

- Use R Shiny and Plotly to create interactive graphs in order to do robustness checks (date range, frequency, different countries)

- Analysis and interpretation of findings

- Compare results with those of selected papers

Data 
------------

US GPD and SPY data is pulled from [Alpha Vantage](www.alphavantage.co)

Income level data for multiple countries is obtained from the [World Bank API](https://datahelpdesk.worldbank.org/knowledgebase/articles/889392-about-the-indicators-api-documentation)

GDP quarterly data for a sample of countries is obtained from the [FRED API](https://fred.stlouisfed.org/docs/api/fred/) using the [fredapi](https://github.com/mortada/fredapi) python package.

Stock Indexes data is obtained from [Yahoo Finance](https://finance.yahoo.com) using the [yfinance](https://pypi.org/project/yfinance/) python package.

Resources
------------
Aali-Bujari, Ali, Francisco Venegas-Mart ́ınez, and Gilberto P ́erez-Lechuga (Dec. 2017). “Impact of the stock market capitalization and the banking spread in growth and development in Latin American: A panel data estimation with System GMM”. en. In: Contadur ́ıa y Administraci ́on 62(5), pp. 1427–1441. issn: 0186-1042. doi: 10.1016/j.cya.2017.09.005. 

Kuvshinov, Dmitry and Kaspar Zimmermann (Aug. 2022). “The big bang: Stock market capitalization in the long run”. en. In: Journal of Financial Economics 145(2, Part B), pp. 527–552. issn: 0304-405X. doi: 10 .1016 / j .jfineco .2021 .09 .008. 

Prats, Mar ́ıa A. and Beatriz Sandoval (Dec. 2020). “Does stock market capitalization cause GDP? A causality study for Central and Eastern European countries”. en. In: Economics 14(1). Publisher: De Gruyter Open Access. issn: 1864-6042. doi: 10 .5018 / economics
-ejournal .ja .2020 -17. 

Market Cap to GDP Ratio (The Buffett Indicator), [Corporate Finance Institute]: https://corporatefinanceinstitute.com/resources/valuation/market-cap-to-gdp-buffett-indicator/![image](https://user-images.githubusercontent.com/53712031/206927198-af7a423d-d89f-4eda-9eb2-92817d75a8fd.png)

Why economic growth has been a mirage for emerging market investors, [Schroders]: https://www.schroders.com/en/ch/wealth-management/insights/markte/why-economic-growth-has-been-a-mirage-for-emerging-market-investors/



Contributors
------------

Flurina Schneider (@flurinaschneider), Till Furger (@tillfurger), Luis Escobar Farfan (@Iescobarfarfan), Martina Stieger (@mstiege)

--------

<p><small>Project based on the <a target="_blank" href="https://drivendata.github.io/cookiecutter-data-science/">cookiecutter data science project template</a>. #cookiecutterdatascience</small></p>
