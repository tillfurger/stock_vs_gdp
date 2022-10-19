import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Read data from csv file
df = pd.read_csv("data/coding-environment-exercise.csv", parse_dates=["date"])

fig = plt.figure(figsize=(9, 7))
eje = fig.add_subplot(111)
sns.lineplot(data=df, x="date", y="value", ax=eje)
eje.set_xlabel("date", fontsize=16)
eje.set_ylabel("value", fontsize=16)
eje.set_title("Example of a time series", fontsize=18, fontweight="bold")
eje.grid(True)

fig.savefig("plot.pdf")
