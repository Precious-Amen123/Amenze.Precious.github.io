#!/usr/bin/env python
# coding: utf-8

# In[14]:


import numpy as np
from numpy import percentile
from numpy.random import rand


# In[4]:


x2 = np.arange(8)
print(x2)


# In[9]:


print(x2.mean())


# In[11]:


print(x2.std())


# In[12]:


x3 = (x2-x2.mean())/x2.std()
print(x3)


# In[13]:


print(x3.std())


# In[15]:


#generate data sample

data = np.random.rand(1000)
print(data)


# In[22]:


#calculate the quartiles, min and max

quartiles = percentile(data, [25,50,75])
data_min = data.min()
data_max = data.max()


# In[50]:


print('Minimum: %.2f' % data_min)
print('Q1 value: %.3f' % quartiles[0])
print('Median: %.3f' % quartiles[1])
print('Mean Val: %.3f' % data.mean())
print('Std Dev: %.3f' % data.std())
print('Maximum: %.3f' % data_max)
print('Q3 value: %.3f' % quartiles[2])


# In[37]:


import pandas as pd
import numpy as np


# In[38]:


myarray = np.array([[10,30,20],
                     [50,40,60],
                     [1000,2000,3000]])
rownames = ['apples', 'oranges', 'beer']
colnames = ['January', 'February', 'March']

mydf = pd.DataFrame(myarray, index=rownames, columns=colnames)
print(mydf)


# In[39]:


print(mydf.describe())


# In[41]:


df1 = pd.DataFrame(np.random.randn(10,4), columns=["A", "B", "C", "D"])
df2 = pd.DataFrame(np.random.randn(7, 3), columns=['A','B','C'])
df3 = df1 + df2
print(df3)


# In[42]:


#combining pandas DataFrames
can_weather = pd.DataFrame({
    "city": ["Vancouver","Toronto","Montreal"],
    "temperature": [72,65,50],
    "humidity": [40, 20, 25]})
us_weather = pd.DataFrame({
    "city": ["SF","Chicago","LA"],
    "temperature": [60,40,85],
    "humidity": [30, 15, 55]})
df = pd.concat([can_weather, us_weather])
print(df)


# In[43]:


#Data manipulation with Pandas DataFrames

summary = {
    'Quarter': ['Q1', 'Q2', 'Q3', 'Q4'],
    'Cost': [23500, 34000, 57000, 32000],
    'Revenue': [40000, 40000, 40000, 40000]}

df = pd.DataFrame(summary)
print("Entire Dataset:\n",df)
print("Quarter:\n",df.Quarter)
print("Cost:\n",df.Cost)
print("Revenue:\n",df.Revenue)


# In[44]:


print("First Dataset:\n",df)
df['Total'] = df.sum(axis=1)
print("Second Dataset:\n",df)


# In[45]:


df['Total'] = df.sum(axis=1)
df.loc['Sum'] = df.sum()
print(df)


# In[46]:


print("Second Dataset:\n",df)


# In[49]:


df.loc['avg'] = df[:3].mean()
print("Third Dataset:\n",df)


# In[52]:


# initialize list of lists
data = [['Tom', 20], ['Paul', 35], ['Julie', 14], ['James', 28],['Myriam', 22],['Kate', 27]]

# Create the pandas DataFrame
df = pd.DataFrame(data, columns = ['Name', 'age'])
df.info()
print('Name:')
print(df['Name'])
print('____________')
print('age over 24:')
print(df['age'] > 24)
print('____________')
print('age over 24:')

myfilter = df['age'] > 24
print(df[myfilter])


# In[54]:


#select, add and delete columns in a Dataframe

df = pd.DataFrame.from_dict(dict([('A',[1,2,3]),( 'B',[4,5,6])]),
                            orient = 'index',
                            columns=['one', 'two', 'three'])
print(df)


# In[55]:


df['three'] = df['one'] * df['two']
df['flag'] = df['one'] > 2
print(df)


# In[56]:


#columns can be deleted or popped using the following method

del df['two']
three = df.pop('three')
print(df)


# In[57]:


#inserting a scalar value
df['foo'] = 'bar'
print(df)


# In[58]:


#When inserting a Series that does not have the same index as the DataFrame, 
#it will be“conformed” to the index of the DataFrame

df['one_trunc'] = df['one'][:2]
print(df)


# In[60]:


#Pandas Dataframes and scatterplots

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from pandas import read_csv
from pandas.plotting import scatter_matrix

myarray = np.array([[10,30,20],[50,40,60],[1000,2000,3000]])
rownames = ['apples', 'oranges', 'beer']
colnames = ['January', 'February', 'March']

mydf = pd.DataFrame(myarray, index=rownames, columns=colnames)
print(mydf)
print(mydf.describe())
scatter_matrix(mydf)
plt.show()


# In[ ]:




