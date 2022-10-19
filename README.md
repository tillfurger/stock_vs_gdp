final_project
==============================

Does the stock market capitalization grow faster than the GDP?

Intro
------------

Using data from Alpha Vantage for the United States,  we are examining whether stock market capitalization grows faster than the GDP. For that purpose, we are providing an analysis of the data through interactive graphs and tables, as well as an interpretation of our output.

In a second step, we are comparing our analysis to the findings of selected papers, which focus on the situation in middle and low income countries. 


Project Organization
------------

    ├── LICENSE
    ├── README.md          <- The top-level README for developers using this project.
    ├── data
    │   ├── processed      <- The final, canonical data sets for modeling.
    │   └── raw            <- The original, immutable data dump.
    │
    ├── notebooks          <- Jupyter notebooks
    │
    │
    ├── reports            <- Generated analysis as PDF and LaTeX report and beamer presentation
    │   └── figures        <- Generated graphics and figures to be used in reporting as .svg
    │   └── svg-inkscape   <- Generated graphics and figures to be used in reporting as .pdf and .pdf_tex
    │   └── tables         <- Generated tables to be used in reporting as .tex
    │
    │
    ├── src                <- Source code for use in this project
    │   ├──__init__.py     <- Makes src a Python module
    │   │
    │   ├── data           <- Scripts to download or generate data
    │       └── make_dataset.py
    │  
    │
    └── requirements.txt   <- Requirements necessary for this project


Description of steps (necessary?/ how?)
------------

Preparation of  a folder structure, using the cookiecutter Data Science template

Import of data, both raw and processed

Generation of tables which can be directly imported to latex 

Connect Overleaf to Github

Use Plotly to create interactive graphs in order to do robustness checks

Analysis and interpretation of findings

Provision of context (international markets)

Data 
------------

Data is pulled from [Alpha Vantage]
(www.alphavantage.co) 

(More detailed info on data: raw& processed etc.)

Resources
------------

Papers

US data: XXX

Emerging market data: XXX

[World Bank]: (https://data.worldbank.org/indicator/CM.MKT.LCAP.GD.ZS)



--------

<p><small>Project based on the <a target="_blank" href="https://drivendata.github.io/cookiecutter-data-science/">cookiecutter data science project template</a>. #cookiecutterdatascience</small></p>
