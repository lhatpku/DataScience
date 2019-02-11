import pandas as pd

df = pd.read_csv('./cities.csv')
df.head()

df.to_html('./cities_raw.html')

