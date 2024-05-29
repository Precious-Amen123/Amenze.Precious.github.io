#!/usr/bin/env python
# coding: utf-8

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import datetime
import seaborn as sns
from random import randint

covid_cases = pd.read_csv("C:/Users/otasp/Desktop/CIS4044 SOFTWARE FOR DIGITAL INNOVATION/ICA/ELEMENT 2/specimenDate_ageDemographic-unstacked.csv")
print(covid_cases)
covid_cases.head(10)
covid_cases.info()

import numpy as np
print(np.__version__)

covid_cases.drop(['areaType'], axis=1, inplace=True)
covid_cases.head(10)
covid_cases.drop(['areaCode'], axis=1, inplace=True)
covid_cases.head(10)

#Date time feature
covid_cases['date'] = pd.to_datetime(covid_cases['date']).dt.date
covid_cases.head(10)
covid_cases.info()
covid_cases['date'] = pd.to_datetime(covid_cases['date']).dt.date
covid_cases.info()
covid_cases.head(10)

covid_cases.columns
covid_cases.index

covid_cases["total cases"] = covid_cases.sum(axis = 1)
covid_cases.head()
covid_cases.head(20)

covid_cases["percentage"] = (covid_cases['total cases'] / covid_cases['total cases'].sum()) * 100
covid_cases.head(20)

covid_cases["date"] = pd.to_datetime(covid_cases["date"])
covid_cases.head(20)

covid_cases["day"] = covid_cases["date"].dt.weekday
covid_cases.head(20)

covid_cases.rename(columns = {'newCasesBySpecimenDate-0_4' : 'Age 0_4', 'newCasesBySpecimenDate-0_59' : 'Age 0_59',
                             'newCasesBySpecimenDate-10_14' : 'Age 10_14', 'newCasesBySpecimenDate-15_19' : 'Age 15_19',
                             'newCasesBySpecimenDate-20_24' : 'Age 20_24', 'newCasesBySpecimenDate-25_29' : 'Age 25_29',
                             'newCasesBySpecimenDate-30_34' : 'Age 30_34', 'newCasesBySpecimenDate-35_39' : 'Age 35_39',
                             'newCasesBySpecimenDateRollingSum-65_69' : 'Age 65_69', 'newCasesBySpecimenDateRollingSum-70_74' : 'Age 70_74',
                             'newCasesBySpecimenDateRollingSum-75_79' : 'Age 75_79', 'newCasesBySpecimenDateRollingSum-80_84' : 'Age 80_84',
                             'newCasesBySpecimenDateRollingSum-85_89' : 'Age 85_89', 'newCasesBySpecimenDateRollingSum-90+' : 'Age 90+',
                             'newCasesBySpecimenDateRollingSum-unassigned' : 'Age unassigned'}, inplace = True)
covid_cases.head(20)
covid_cases.columns
