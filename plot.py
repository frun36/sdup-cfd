import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

df = pd.read_csv('output.csv', sep=',')

t = df['time_ns']
din = df['din']
dout = df['dout']

plt.figure(figsize=(16, 4))
x_max = int(np.max(t))

plt.plot(t, din, label='p', color='blue', linestyle='--')
plt.plot(t, dout, label='sum', color='purple')

plt.xlabel('t')
plt.ylabel('V')
plt.legend()
plt.grid(True)

plt.show()
