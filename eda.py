#!/usr/bin/env python
# coding: utf-8

# In[42]:


import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import mysql.connector
import numpy as np



# In[43]:


sales=pd.read_csv(r"D:\GLOBAL ELECTRONICS\Sales.csv")


# In[44]:


data_dictionary=pd.read_csv(r"D:\GLOBAL ELECTRONICS\Data_Dictionary.csv")
exchange_rates=pd.read_csv(r"D:\GLOBAL ELECTRONICS\Exchange_Rates.csv")



# In[45]:


product=pd.read_csv(r"D:\GLOBAL ELECTRONICS\Products.csv")
stores=pd.read_csv(r"D:\GLOBAL ELECTRONICS\Stores.csv")


# In[46]:


product


# In[47]:


cs = pd.read_csv(r"D:\GLOBAL ELECTRONICS\Customers.csv", encoding='windows-1252')



# In[48]:


sales


# In[49]:


sales.info()


# In[50]:


sales.fillna(0)


# In[51]:


sales['Delivery Date']=sales['Delivery Date'].replace(0,pd.NaT)
sales['Delivery Date']=pd.to_datetime(sales['Delivery Date'],errors='coerce')


# In[52]:


sales['Order Date']=sales['Order Date'].replace(0,pd.NaT)
sales['Order Date']=pd.to_datetime(sales['Order Date'],errors='coerce')


# In[53]:


cs['Birthday']=pd.to_datetime(cs['Birthday'],errors='coerce')


# In[54]:


exchange_rates['Date'] = pd.to_datetime(exchange_rates['Date'], format='%m/%d/%Y', errors='coerce')


exchange_rates['Date'] = exchange_rates['Date'].dt.strftime('%d/%m/%Y')



# In[55]:


exchange_rates['Date'] = pd.to_datetime(exchange_rates['Date'], format='%d/%m/%Y', errors='coerce')


# In[56]:


exchange_rates.info()


# In[57]:


cs


# In[58]:


sales


# In[59]:


exchange_rates


# In[60]:


cs


# In[61]:


def find_empty(df):
    null_or_empty = df.isnull() | ( df== '')
    null_positions = null_or_empty.stack()
    null_positions = null_positions[null_positions]
    print(null_positions)


# In[62]:


cs2=cs[["State",'State Code']]


# In[63]:


cs2.info()


# In[64]:


from sklearn.preprocessing import LabelEncoder


# In[65]:


lb=LabelEncoder()


# In[66]:


cs2['State Code Encoded'] = lb.fit_transform(cs2['State'])
cs2['State Code Encoded2']=lb.fit_transform(cs2['State Code'])


# In[67]:


cs2


# In[68]:


cs2[['State Code Encoded',	'State Code Encoded2']].corr()


# In[69]:


product['Unit Cost USD']=product['Unit Cost USD'].str.replace('$','')
product['Unit Price USD']=product['Unit Price USD'].str.replace('$','')


# In[70]:


product


# In[71]:


product['Unit Price USD']=product['Unit Price USD'].str.replace(',',"")
product['Unit Cost USD']=product['Unit Cost USD'].str.replace(',','')


# In[72]:


product['Unit Price USD']=product['Unit Price USD'].astype('float64')
product['Unit Cost USD']=product['Unit Cost USD'].astype('float64')


# In[73]:


product


# In[74]:


stores['Open Date'] = pd.to_datetime(stores['Open Date'] , format='%m/%d/%Y', errors='coerce')


# In[75]:


stores.fillna(0)


# In[76]:


exchange_rates


# In[77]:


cs.info()


# In[78]:


exchange_rates.info()


# In[79]:


product.info()


# In[80]:


sales.info()


# In[90]:


# visualize currency counts
plt.figure(figsize=(12,5))
sns.countplot(x=exchange_rates["Currency"],data=exchange_rates,hue="Currency")
plt.xlabel("Currency Code")
plt.ylabel("counts")
plt.title("counts as per Currency")


# In[86]:


#visualize the brand and category
plt.figure(figsize=(50,8))
plt.subplot(1,2,1)
sns.countplot(x=product["Brand"],data=product,hue="Brand")
plt.xlabel("Brand")
plt.ylabel("counts")
plt.title("counts as per Brand")
plt.show()
plt.figure(figsize=(40,8))
plt.subplot(2,2,2)
sns.countplot(x=product["Category"],data=product,hue="Category")
plt.xlabel("Category")
plt.ylabel("counts")
plt.title("counts as per Category")
plt.show()


# In[94]:


# visualize country counts
plt.figure(figsize=(12,5))
sns.countplot(x=cs["Country"],data=cs,hue="Country")
plt.xlabel("Country")
plt.ylabel("counts")
plt.title("counts as per Country")


# In[96]:


# visualize gender details
plt.figure(figsize=(12,6))
plt.subplot(1,2,1)
plt.pie(cs["Gender"].value_counts(), 
        autopct='%1.0f%%', 
        labels=['Male', 'Female'])
plt.subplot(2,2,2)
sns.countplot(x=cs["Gender"],data=cs,hue="Gender")
plt.xlabel("Gender")
plt.ylabel("counts")
plt.title("counts as per Gender")
plt.show()


# In[ ]:


get_ipython().system('pip install pymysql')


# In[ ]:


import pandas as pd
import pymysql
from sqlalchemy import create_engine
host = "localhost"
port = "3306"
username = "global_electronics"
password = "msp"
database = "global_electronics"
 
engine_string = f"mysql+pymysql://{username}:{password}@{host}:{port}/{database}"
engine = create_engine(engine_string)
 
table_name = ['customer','dataditonary','exchangerates','product','sales','stores']
cs.to_sql(table_name[0], engine,if_exists="replace", index=False)
data_dictionary.to_sql(table_name[1], engine,if_exists="replace", index=False)
exchange_rates.to_sql(table_name[2], engine,if_exists="replace", index=False)
product.to_sql(table_name[3], engine,if_exists="replace", index=False)
sales.to_sql(table_name[4], engine,if_exists="replace", index=False)
stores.to_sql(table_name[5], engine,if_exists="replace", index=False)
print("success")


# In[ ]:




