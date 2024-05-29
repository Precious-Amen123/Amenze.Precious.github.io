#!/usr/bin/env python
# coding: utf-8

# In[24]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import datetime
import seaborn as sns
from random import randint


# In[3]:


covid_cases = pd.read_csv("C:/Users/otasp/Desktop/CIS4044 SOFTWARE FOR DIGITAL INNOVATION/ICA/ELEMENT 2/specimenDate_ageDemographic-unstacked.csv")
print(covid_cases)


# In[4]:


covid_cases.head(10)


# In[5]:


covid_cases.info()


# In[8]:


import numpy as np
print(np.__version__)


# In[10]:


get_ipython().system('pip3 install numpy --upgrade')


# In[11]:


pip install --upgrade pandas


# In[7]:


covid_cases.drop(['areaType'], axis=1, inplace=True)
covid_cases.head(10)


# In[8]:


covid_cases.drop(['areaCode'], axis=1, inplace=True)
covid_cases.head(10)


# In[40]:


#Date time feature
covid_cases['date'] = pd.to_datetime(covid_cases['date']).dt.date
covid_cases.head(10)


# In[13]:


covid_cases.info()


# In[25]:


covid_cases['date'] = pd.to_datetime(covid_cases['date']).dt.date


# In[26]:


covid_cases.info()


# In[27]:


covid_cases.head(10)


# In[28]:


covid_cases.columns


# In[29]:


covid_cases.index


# In[30]:


covid_cases["total cases"] = covid_cases.sum(axis = 1)
covid_cases.head()


# In[31]:


covid_cases.head(20)


# In[38]:


covid_cases["percentage"] = (covid_cases['total cases'] / covid_cases['total cases'].sum()) * 100
covid_cases.head(20)


# In[42]:


covid_cases["date"] = pd.to_datetime(covid_cases["date"])
covid_cases.head(20)


# In[44]:


covid_cases["day"] = covid_cases["date"].dt.weekday
covid_cases.head(20)


# In[47]:


covid_cases.rename(columns = {'newCasesBySpecimenDate-0_4' : 'Age 0_4', 'newCasesBySpecimenDate-0_59' : 'Age 0_59',
                             'newCasesBySpecimenDate-10_14' : 'Age 10_14', 'newCasesBySpecimenDate-15_19' : 'Age 15_19',
                             'newCasesBySpecimenDate-20_24' : 'Age 20_24', 'newCasesBySpecimenDate-25_29' : 'Age 25_29',
                             'newCasesBySpecimenDate-30_34' : 'Age 30_34', 'newCasesBySpecimenDate-35_39' : 'Age 35_39',
                             'newCasesBySpecimenDateRollingSum-65_69' : 'Age 65_69', 'newCasesBySpecimenDateRollingSum-70_74' : 'Age 70_74',
                             'newCasesBySpecimenDateRollingSum-75_79' : 'Age 75_79', 'newCasesBySpecimenDateRollingSum-80_84' : 'Age 80_84',
                             'newCasesBySpecimenDateRollingSum-85_89' : 'Age 85_89', 'newCasesBySpecimenDateRollingSum-90+' : 'Age 90+',
                             'newCasesBySpecimenDateRollingSum-unassigned' : 'Age unassigned'}, inplace = True)
covid_cases.head(20)


# In[48]:


covid_cases.columns


# In[52]:





# In[ ]:




