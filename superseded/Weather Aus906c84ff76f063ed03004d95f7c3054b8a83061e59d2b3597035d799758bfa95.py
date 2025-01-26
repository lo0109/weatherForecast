#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns


# In[4]:


data = pd.read_csv('weatherAUS.csv')


# In[5]:


num_samples = data.shape[0]


# In[6]:


categorical_attributes = data.select_dtypes(include=['object']).columns


# In[7]:


numerical_attributes = data.select_dtypes(include=['float64', 'int64']).columns


# In[8]:


numerical_summary = data[numerical_attributes].describe()


# In[9]:


print(numerical_summary)


# In[10]:


plt.figure(figsize=(10, 6))


# In[11]:


sns.boxplot(data=data[numerical_attributes])


# In[12]:


plt.title('Boxplots of Numerical Attributes')


# In[13]:


plt.xticks(rotation=45)


# In[15]:


plt.show()


# In[16]:


data[numerical_attributes].hist(figsize=(10, 6))


# In[17]:


plt.suptitle('Histograms of Numerical Attributes')


# In[18]:


plt.tight_layout(rect=[0, 0.03, 1, 0.95])


# In[19]:


plt.show()


# In[20]:


sns.pairplot(data[numerical_attributes])


# In[21]:


plt.suptitle('Scatter Matrix of Numerical Attributes')


# In[22]:


plt.show()


# In[23]:


missing_data = data.isnull().sum()


# In[24]:


data_cleaned = data.dropna()


# In[ ]:




