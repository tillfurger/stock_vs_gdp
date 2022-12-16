Final Project: Stock Market Capitalization vs. GDP Growth
==============================

Intro
------------

In this project, we are examining whether the stock market capitalization grows faster than the GDP, with a focus on developed countries, namely the United States. The ratio between a country's market capitalization and its GDP is also called the "Buffet indicator" and is often used to get an insight if the stock market is undervalued or overvalued. 

For our research, we use data from Alpha Vantage for the United States and provide an analysis of the data through graphs and tables. We also give a short interpretation of our findings.

In a second step, we are comparing our analysis to the situation in emerging markets in order to get insights about the situation in middle and low income countries and to bring forth potential similarities and differences. In order to visualize these effectively, we have developed an interactive app where each user can undertake robustness checks on his own. We have considered visualisation principles for our graphs and apps and designed them in a colorblind-friendly manner.

Finally, we also compare our research to the findings of selected studies and papers in the field. 


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
    │   └── helper.R                <- Helper function
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

- Use R Shiny and Plotly to create interactive graphs in order to do robustness checks (date range, frequency, type of country)

- Analysis and interpretation of findings

- Compare results with those of selected papers

Data 
------------

Data is pulled from [Alpha Vantage]: www.alphavantage.co

Resources
------------

Alajekwu Udoka Bernard and Achugbu Austin (2011); “The Role of Stock Market Development on Economic Growth in Nigeria: A Time Series Analysis,” African Research Review Vol. 5 (6), Serial No. 23, November.

Beware the Bubble? The US Stock Market Cap-to-GDP Ratio, [CFA Institute]: https://blogs.cfainstitute.org/investor/2021/02/02/beware-the-bubble-the-us-stock-market-cap-to-gdp-ratio/

Why economic growth has been a mirage for emerging market investors, [Schroders]: https://www.schroders.com/en/ch/wealth-management/insights/markte/why-economic-growth-has-been-a-mirage-for-emerging-market-investors/

Market Cap to GDP Ratio (the Buffett Indicator), [Corporate Finance Institute]: https://corporatefinanceinstitute.com/resources/valuation/market-cap-to-gdp-buffett-indicator/![image](https://user-images.githubusercontent.com/53712031/206927198-af7a423d-d89f-4eda-9eb2-92817d75a8fd.png)

Market Capitalization of Listed Domestic Companies (% of GDP), [World Bank]: https://data.worldbank.org/indicator/CM.MKT.LCAP.GD.ZS

Contributors
------------

Flurina Schneider (@flurinaschneider), Till Furger (@tillfurger), Luis Escobar Farfan (@Iescobarfarfan), Martina Stieger (@mstiege)

--------

<p><small>Project based on the <a target="_blank" href="https://drivendata.github.io/cookiecutter-data-science/">cookiecutter data science project template</a>. #cookiecutterdatascience</small></p>
