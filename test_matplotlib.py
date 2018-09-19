# Qiitaの記事コピペしただけ
# https://qiita.com/hik0107/items/de5785f680096df93efa

#import matplotlib
#import matplotlib.pyplot as plt
#
#import pandas as pd
#import numpy as np
#import datetime
#
#plt.style.use('ggplot') 
#font = {'family' : 'meiryo'}
#matplotlib.rc('font', **font)
#
#url = 'https://vincentarelbundock.github.io/Rdatasets/csv/robustbase/ambientNOxCH.csv'
#df_sample = pd.read_csv(url, parse_dates=1, index_col=1)
#
## dfの準備
#df = df_sample.iloc[:, 1:]
#
## df_monthlyの準備
#df_monthly = df.copy()
#df_monthly.index = df_monthly.index.map(lambda x: x.month)
#df_monthly = df_monthly.groupby(level=0).sum()
#
#df_monthly.plot.bar(y=['ad', 'ba', 'se'], alpha=0.6, figsize=(12,3))
#plt.title(u'普通の棒グラフ', size=16)

import matplotlib.pyplot as plt
matplotlib.use('Agg')
import numpy as np


def f(t):
    'A damped exponential'
    s1 = np.cos(2 * np.pi * t)
    e1 = np.exp(-t)
    return s1 * e1


t1 = np.arange(0.0, 5.0, .2)

l = plt.plot(t1, f(t1), 'ro')
plt.setp(l, markersize=30)
plt.setp(l, markerfacecolor='C0')

#plt.show()
plt.savefig('figure.png')
