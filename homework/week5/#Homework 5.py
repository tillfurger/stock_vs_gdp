#Homework 5

#non empty data frame, 2 columns identical

import pandas as pd
import numpy as np

import time as time

df2 = pd.DataFrame(np.random.randint(0,100,size=(1000000, 5)), columns=list("ABCDE"))
df2.head()

print(df2)




#make 2 columns identical
df2.iloc[: , 0]= df2.iloc[: ,1]

print(df2)

#Feather
start_time = time.time()

df2.to_feather("data/data_feather.ftr")
end_time = time.time()

with open ("time.txt","w") as f:
    f.write("Feather: " + "--- %s seconds ---" % (end_time - start_time))

print("--- %s seconds ---" % (end_time - start_time))


#HDF
start_time = time.time()

df2.to_hdf("data/data_HDF.h5", key="df2")
end_time = time.time()

with open ("time.txt","a") as f:
    f.write("\n HDF: " + "--- %s seconds ---" % (end_time - start_time))

print("--- %s seconds ---" % (end_time - start_time))



#Parquet
start_time = time.time()

df2.to_hdf("data/data_Parquet.gzip", key="df2")
end_time = time.time()

with open ("time.txt","a") as f:
    f.write("\n Parquet: " + "--- %s seconds ---" % (end_time - start_time))

print("--- %s seconds ---" % (end_time - start_time))



